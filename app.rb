require "sinatra/base"

class App < Sinatra::Base
  set :erb, :escape_html => true
  enable :sessions

  # flash message support
  before do
    @flashnow = session[:flash] || {}
  end

  after do
    session[:flash] = @flash || {}
  end

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
    #TODO: error handling!
    #
    # submit job
    inputfile = Pathname.new(params['inputfile'])
    inputdir = inputfile.dirname
    outputdir = inputdir.join('output')

    # ahh - debugging this is problematic... that is where flash message is useful... you can have error msg or output msg then
    # could do "submitted job with command: ....."
    cmd = "/opt/torque/bin/qsub -A #{params['account']} -v BLEND_FILE_PATH=#{inputfile.to_s} -d #{inputdir.to_s} /users/PZS0562/efranz/ondemand/dev/jobs/jobs/blender_render_job.sh 2>&1".strip
    jobid = `#{cmd}`

    @flash = {info: "Job submitted using command: #{cmd} with output: #{jobid}"}

    redirect to("/job?jobid=#{jobid}&output=#{outputdir.to_s}")
  end
end
