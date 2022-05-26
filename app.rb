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

  get '/render/frames/new' do
    erb :render_frames_new
  end

  post '/render/frames' do
    logger.info("Trying to render frames with: #{params.inspect}")

    erb :render_frames_new
  end
end
