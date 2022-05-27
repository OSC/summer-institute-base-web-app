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
    @flash = { info: 'Welcome to Summer Institute!' }
    erb :index
  end

  get '/render/frames/new' do
    @uploaded_blend_files = Dir.glob("#{__dir__}/jobs/input_files/*.blend").map { |f| File.basename(f) }
    erb :render_frames_new
  end

  post '/render/frames' do
    logger.info("Trying to render frames with: #{params.inspect}")

    erb :render_frames_new
  end
end
