# frozen_string_literal: true

require 'sinatra/base'

# App is the main application where all your logic & routing will go
class App < Sinatra::Base
  set :erb, escape_html: true

  def title
    'My App'
  end

  get '/' do
    erb :index
  end
end
