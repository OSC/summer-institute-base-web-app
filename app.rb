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

  get '/' do
    logger.info('requsting the index')
    @flash = { info: 'Welcome to Summer Institute!' }
    erb :index
  end

  get '/projects/new' do
    erb :new_project
  end

  post '/projects/new' do
    logger.info("Trying to render frames with: #{params.inspect}")
    @flash = { info: "Trying to render frames with: #{params.inspect}" }

    erb :new_project
  end
end
