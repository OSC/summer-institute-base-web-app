require "sinatra/base"
require "ood_core"
require "json"

class App < Sinatra::Base
  set :erb, :escape_html => true
  enable :sessions

  def job_adapter
    @job_adapter ||= OodCore::Cluster.new(id: 'owens', job: {
      adapter: "torque",
      host: "owens-batch.ten.osc.edu",
      lib: "/opt/torque/lib64",
      bin: "/opt/torque/bin",
      version: "6.0.1"
    }).job_adapter
  end

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
      @jobinfo = job_adapter.info(@jobid)
      @jobstats = JSON.pretty_generate(@jobinfo.native)


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

    # by default adapter joins error and output files
    #
    jobid = job_adapter.submit(OodCore::Job::Script.new(
      content: erb(:blender_render_job, layout: false, locals: params),
      accounting_id: params['account'],
      job_enviroment: { 'BLEND_FILE_PATH' => inputfile.to_s },
      workdir: inputdir.to_s
    ))

    @flash = {info: "Job submitted using ood_core library with job id: #{jobid}"}

    redirect to("/job?jobid=#{jobid}&output=#{outputdir.to_s}")

    # TODO: rescue exception when submitting job
    #
    # rescue StandardError => e
    #   # you lose /new unless you could rerender with query params...
    #   @flash = {warning: "Job failed to submit using ood_core library with error msg: #{e.message}"}
    #   redirect to("/new.erb")
  end
end
