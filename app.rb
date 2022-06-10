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

  def title
    'Summer Institute - Blender'
  end

  def input_files_dir
    "#{project_dirs}/input_files"
  end

  def projects_root
    "#{__dir__}/projects"
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
    erb :show_project
    end
  end

  post '/projects/new' do
    logger.info("Trying to render frames with: #{params.inspect}")

    dir = params[:name].downcase.gsub(' ', '_')
    "#{projects_root}/#{dir}".tap{ |d| FileUtils.mkdir_p(d) }

    session[:flash] = { info: "made new project '#{params[:name]}'" }
    redirect(url("/projects/#{dir}"))
  end

  post 'render/frames' do
    session[:flash] = { info: "rendering frames with '#{params}'" }
    redirect(url('/'))
  end

  def project_dirs
    Dir.children(projects_root).reject{ |dir| dir == 'input_files' }.sort_by(&:to_s)
  end

  get '/' do
    logger.info('requsting the index')
    @flash = session.delete(:flash) || {info: 'Welcome to Summer Institute!'}

    @project_dirs = project_dirs

    erb :index
  end
end
