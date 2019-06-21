require "sinatra/base"

class App < Sinatra::Base
  set :erb, :escape_html => true
  enable :sessions

  def title
    "My App"
  end

  get "/" do
    erb :index
  end
  
  get "/jobs" do
    output = `/opt/torque/bin/qselect`
    @jobs = output.split

    erb :jobs
  end

  get "/job" do
      @jobid = params['jobid']
      @jobstats = `/opt/torque/bin/qstat -f #{@jobid}`

      @results = []
      if params['output'] && File.exist?(params['output'])
        @results = Dir.glob("#{params['output']}/*png")
      end

      erb :job
  end

  get "/new" do
    erb :new
  end

  post "/job" do
    jobid = "123456"
    output = Pathname.new(params['inputfile']).dirname.join('output').to_s

    @flash = {info: "Job submitted!"}

    redirect to("/job?jobid=#{jobid}&output=#{output}")
  end

  before do
    @flashnow = session[:flash] || {}
  end


  after do
    session[:flash] = @flash || {} # unless we set the flash in this request?
  end

  # Morgan I didn't think a flash message was required here :-)
end
