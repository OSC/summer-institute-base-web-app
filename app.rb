# frozen_string_literal: true

require 'sinatra/base'
require 'logger'

# App is the main application where all your logic & routing will go
class App < Sinatra::Base
  set :erb, escape_html: true
  enable :sessions
  set :host_authorization, { permitted_hosts: ['ondemand.osc.edu'] }

  attr_reader :logger

  def initialize
    super
    @logger = Logger.new('log/app.log')
  end

  def title
    'Summer Instititue Starter App'
  end

  get '/examples' do
    erb(:examples)
  end

  def project_dirs
    Dir.children(projects_root).select do |path|
      Pathname.new("#{projects_root}/#{path}").directory?
    end.sort_by(&:to_s)
  end

  def accounts
    Process.groups.map do |group_id|
      Etc.getgrgid(group_id).name
    end.select do |group|
      group.start_with?('P')
    end
  end

  def blend_files
    Dir.glob("#{__dir__}/blend_files/*.blend").map do |f|
      File.basename(f)
    end
  end

  get '/' do
    logger.info('requsting the index')
    @flash = session.delete(:flash) || { info: 'Welcome to Summer Institute!' }
    erb(:index)
  end

  get '/projects/:name' do
    if params[:name] == 'new'
      erb(:new_project)
    else
      @directory = Pathname.new("#{projects_root}/#{params[:name]}")
      @project_name = @directory.basename.to_s.gsub('_', ' ').capitalize

      if(@directory.directory? && @directory.readable?)
        erb(:show_project)
      else
        session[:flash] = { danger: "#{@directory} does not exist" }
        redirect(url('/'))
      end

    end
  end

  # helper function for the parent directory of all projects.
  def projects_root
    "#{__dir__}/projects"
  end

  post '/projects/new' do
    dir = params[:name].downcase.gsub(' ', '_')

    "#{projects_root}/#{dir}".tap { |d| FileUtils.mkdir_p(d) }

    session[:flash] = { info: "made new project '#{params[:name]}'" }
    redirect(url("/projects/#{dir}"))
  end
end
