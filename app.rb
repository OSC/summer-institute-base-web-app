# frozen_string_literal: true

require 'sinatra/base'
require 'logger'

# App is the main application where all your logic & routing will go
class App < Sinatra::Base
  set :erb, escape_html: true
  enable :sessions

  attr_reader :logger, :groups

  def initialize
    super
    @logger = Logger.new('log/app.log')
    @groups ||= begin
      groups_from_id = `id`.to_s.match(/groups=(.+)/)[1].split(',').map do |g|
        g.match(/\d+\((\w+)\)/)[1]
      end

      groups_from_id.select { |g| g.match?(/^P\w+/) }
    end
  end

  def title
    'Summer Institute - Blender'
  end

  get '/' do
    logger.info('requsting the index')
    @flash = { info: 'Welcome to Summer Institute!' } if @flash.nil?
    erb :index
  end

  get '/render/frames/new' do
    @uploaded_blend_files = Dir.glob("#{__dir__}/jobs/input_files/*.blend").map { |f| File.basename(f) }
    erb :render_frames_new
  end

  post '/render/frames' do
    logger.info("Trying to render frames with: #{params.inspect}")

    if params['blend_file'].nil?
      blend_file = "#{input_files_dir}/#{params[:uploaded_blend_file]}"
    else
      blend_file = "#{input_files_dir}/#{params['blend_file'][:filename]}"
      copy_upload(input: params['blend_file'][:tempfile], output: blend_file)
    end

    base_dir = Time.now.to_i
    output_dir = "#{project_root}/jobs/#{base_dir}".tap { |p| Dir.mkdir(p) unless Pathname.new(p).exist? }
    basename = File.basename(blend_file, '.*')
    walltime = format('%02d:00:00', params[:num_hours])

    args = ['-J', "blender-#{basename}", '--parsable']
    args.concat ['--export', "BLEND_FILE_PATH=#{blend_file},OUTPUT_DIR=#{output_dir},FRAMES_RANGE=#{params[:frames_range]}"]
    args.concat ['-n', params[:num_cpus], '-t', walltime, '-M', 'pitzer']
    args.concat ['--output', "#{output_dir}/#{basename}-%j.out"]
    output = `/bin/sbatch #{args.join(' ')}  #{project_root}/render_frames.sh 2>&1`

    job_id = output.strip.split(';').first
    `echo #{job_id} > #{output_dir}/job_id`

    redirect(url("/jobs/#{base_dir}"))
  end

  post '/render/video' do
    logger.info("Trying to render video with: #{params.inspect}")

    output_dir = params[:dir]
    frames_per_second = params[:frames_per_second]
    walltime = format('%02d:00:00', params[:num_hours])

    args = ['-J', 'blender-video', '--parsable']
    args.concat ['--export', "FRAMES_PER_SEC=#{frames_per_second},FRAMES_DIR=#{output_dir}"]
    args.concat ['-n', params[:num_cpus], '-t', walltime, '-M', 'pitzer']
    args.concat ['--output', "#{output_dir}/video-render-%j.out"]
    output = `/bin/sbatch #{args.join(' ')}  #{project_root}/render_video.sh 2>&1`

    job_id = output.strip.split(';').first
    `echo #{job_id} > #{output_dir}/job_id`

    redirect(url("/jobs/#{output_dir.split('/').last}"))
  end

  get '/jobs' do
    @job_dirs = job_dirs
    erb :jobs
  end

  get '/jobs/:dir' do
    @dir = Pathname.new("#{project_root}/jobs/#{params[:dir]}")
    unless @dir.directory? && @dir.executable?
      @flash = { danger: "#{@dir} is not a valid job directory." }
      erb :index
    else
      @images = Dir.glob("#{@dir}/*.png")
      @job_id = File.read("#{@dir}/job_id").chomp
      @job_state = job_state(@job_id)
      @badge = badge(@job_state)

      erb :job
    end
  end

  def job_dirs
    Dir.children("#{project_root}/jobs").reject { |dir| dir == 'input_files' }.sort_by(&:to_i).reverse
  end

  def copy_upload(input: nil, output: nil)
    input_sha = Pathname.new(input).file? ? Digest::SHA256.file(input) : nil
    output_sha = Pathname.new(output).file? ? Digest::SHA256.file(output) : nil
    return if input_sha.to_s == output_sha.to_s

    File.open(output, 'wb') do |f|
      f.write(input.read)
    end
  end

  def project_root
    __dir__
  end

  def input_files_dir
    Pathname.new("#{project_root}/jobs/input_files")
  end

  def job_state(job_id)
    state = `/bin/squeue -j #{job_id} -h -o '%t'`.chomp
    s = {
      '' => 'Completed',
      'R' => 'Running',
      'C' => 'Completed',
      'Q' => 'Queued',
      'CF' => 'Queued',
      'PD' => 'Queued',
    }[state]

    s.nil? ? 'Unknown' : s
  end

  def badge(state)
    {
      '' => 'warning',
      'Unknown' => 'warning',
      'Running' => 'success',
      'Queued' => 'info',
      'Completed' => 'primary',
    }[state.to_s]
  end
end
