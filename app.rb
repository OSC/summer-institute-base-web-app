# frozen_string_literal: true

require 'sinatra/base'
require 'logger'
require 'open3'
require_relative 'node_helper'

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

  def projects_root
    "#{__dir__}/projects"
  end

  def project_dirs
    Dir.children(projects_root).reject { |dir| dir == 'input_files' }.sort_by(&:to_s)
  end

  def input_files_dir
    "#{projects_root}/input_files"
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

  def copy_upload(input: nil, output: nil)
    input_sha = Pathname.new(input).file? ? Digest::SHA256.file(input) : nil
    output_sha = Pathname.new(output).file? ? Digest::SHA256.file(output) : nil
    return if input_sha.to_s == output_sha.to_s

    File.open(output, 'wb') do |f|
      f.write(input.read)
    end
  end

  get '/' do
    logger.info('requsting the index')
    @flash = session.delete(:flash) || { info: 'Welcome to Summer Institute!' }

    @project_dirs = project_dirs


    erb :index
  end

  get '/projects/:dir' do
    if params[:dir] == 'new' || params[:dir] == 'input_files'
      erb :new_project
    else
      @dir = Pathname("#{projects_root}/#{params[:dir]}")
      @flash = session.delete(:flash)
      @uploaded_blend_files = Dir.glob("#{input_files_dir}/*.blend").map { |f| File.basename(f) }
      @project_name = @dir.basename.to_s.gsub('_', ' ').capitalize

      unless @dir.directory? || @dir.readable?
        session[:flash] = { danger: "#{@dir} does not exist" }
        redirect(url('/'))
      end

      `touch #{@dir}/.video_render_job_id`
      `touch #{@dir}/.frame_render_job_id`

      @images = Dir.glob("#{@dir}/*.png")
      @frame_render_job_id = File.read("#{@dir}/.frame_render_job_id").chomp
      @frame_render_job_state = job_state(@frame_render_job_id)
      @frame_render_badge = badge(@frame_render_job_state)

      @video_render_job_id = File.read("#{@dir}/.video_render_job_id").chomp
      @video_render_job_state = job_state(@video_render_job_id)
      @video_render_badge = badge(@video_render_job_state)


      erb :show_project
    end
  end

  post '/projects/new' do
    logger.info("Trying to render frames with: #{params.inspect}")

    dir = params[:name].downcase.gsub(' ', '_')
    "#{projects_root}/#{dir}".tap { |d| FileUtils.mkdir_p(d) }

    session[:flash] = { info: "made new project '#{params[:name]}'" }
    redirect(url("/projects/#{dir}"))
  end

  post '/render/frames' do
    logger.info("Trying to render frames with: #{params.inspect}")

    if params['blend_file'].nil?
      blend_file = "#{input_files_dir}/#{params[:uploaded_blend_file]}"
    else
      blend_file = "#{input_files_dir}/#{params['blend_file'][:filename]}"
      copy_upload(input: params['blend_file'][:tempfile], output: blend_file)
    end

    dir = params[:dir]
    basename = File.basename(blend_file, '.*')
    walltime = format('%02d:00:00', params[:num_hours])
    helper = NodeHelper.new(frames: params[:frames_range], nodes: params[:num_nodes])
    @start_frames, @end_frames = helper.task_frames

    template = ERB.new(File.read("#{__dir__}/render_frames.sh.erb"))
    script_content = template.result(binding)
    args = ['-J', "blender-#{basename}", '--parsable', '-A', params[:project_name]]
    args.concat ['--export', "BLEND_FILE_PATH=#{blend_file},OUTPUT_DIR=#{dir}"]
    args.concat ['-N', params[:num_nodes], '--exclusive', '-t', walltime, '-M', 'pitzer']
    args.concat ['--output', "#{dir}/frame-render-%j.out"]
    output, status = Open3.capture2({}, '/bin/sbatch', *args, stdin_data: script_content)

    job_id = output.strip.split(';').first
    `echo #{job_id} > #{dir}/.frame_render_job_id`
    File.open("#{dir}/#{job_id}.sh", "w+") { |f| f.write(script_content) }

    session[:flash] = { info: "submitted job #{job_id}" }
    redirect(url("/projects/#{dir.split('/').last}"))
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
    output = `/bin/sbatch #{args.join(' ')}  #{__dir__}/render_video.sh 2>&1`

    job_id = output.strip.split(';').first
    `echo #{job_id} > #{output_dir}/.video_render_job_id`

    session[:flash] = { info: "Submitted job #{job_id}"}
    redirect(url("/projects/#{output_dir.split('/').last}"))
  end
end
