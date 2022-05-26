# frozen_string_literal: true

require 'sinatra/base'
require 'logger'

# App is the main application where all your logic & routing will go
class App < Sinatra::Base
  set :erb, escape_html: true

  logger = Logger.new('log/app.log')

  def title
    'Summer Instititue Starter App'
  end

  get '/' do
    logger.info('requsting the index')
    erb :index
  end
end
