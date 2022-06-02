# frozen_string_literal: true

require 'sinatra/base'
require 'logger'

# App is the main application where all your logic & routing will go
class App < Sinatra::Base
  set :erb, escape_html: true
  enable :sessions

  attr_reader :logger

  def initialize
    super
    @logger = Logger.new('log/app.log')
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
    "#{projects_root}/#{dir}".tap { |d| FileUtils.mkdir_p(d) }

    session[:flash] = { info: "made new project '#{params[:name]}'" }
    redirect(url("/projects/#{dir}"))
  end
end
