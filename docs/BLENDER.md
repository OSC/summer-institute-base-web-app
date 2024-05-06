# Blender App to render Movies

This document walks through the different stages you'll need to go through
to create a web app that can render frames and movies.

It attempts to break features out into stages.

## 1. Start the new projects page.

This will add the ability to create new projects.

### 1a. Add the link to the navigation bar.

We want to create a page that users can navigate to to create a new project.
So the first thing we need to do is to add a link to the layout using a
[list item] and an [anchor].  We'll also add an [idiomatic text] tag to get the
camera icon.

**Be sure to add the [list item] (li) as a child of the existing [unorderd list] (ul)**

`views/layout.erb`

```diff
             <i class="fas fa-home"></i> <%= title %>
           </a>
         </li>
+
+        <li class="nav-item active">
+          <a href="<%= url('/projects/new') %>" class="nav-link">
+            <i class="fas fa-camera"></i> New Project
+          </a>
+        </li>
```

<details>
<summary>full views/layout.erb file</summary>
  
  ```erb
  <!doctype html>

  <html lang="en">
  <head>
    <meta charset="utf-8">

    <title><%= title %></title>
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-fQybjgWLrvvRgtW6bFlB7jaZrFsaBXjsOMm/tB9LTS58ONXgqbR9W8oWht/amnpF" crossorigin="anonymous"></script>
    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css" integrity="sha384-zCbKRCUGaJDkqS1kPbPd7TveP5iyJE0EjAuZQTgFLD2ylzuqKfdKlfG/eSrtxUkn" crossorigin="anonymous">

    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.0.13/css/all.css" integrity="sha384-DNOHZ68U8hZfKXOrtjWvjxusGo9WQnrNx2sqG0tfsghAvtVlRW3tvkXWZh58N9jp" crossorigin="anonymous">
  </head>
  <body>

  <header>
    <nav class="navbar navbar-expand-md navbar-dark bg-dark">
      <a href="/" class="navbar-brand"><%= ENV["ONDEMAND_TITLE"] %></a>
      <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>

      <div class="collapse navbar-collapse" id="navbarSupportedContent">
        <ul class="navbar-nav mr-auto">
          <li class="nav-item active">
            <a href="<%= url("/") %>" class="nav-link">
              <i class="fas fa-home"></i> <%= title %>
            </a>
          </li>

          <li class="nav-item active">
            <a href="<%= url('/projects/new') %>" class="nav-link">
              <i class="fas fa-camera"></i> New Project
            </a>
          </li>
        </ul>
      </div>
    </nav>
  </header>

  <div class="container" role="main">
    <% @flash.each do |type, msg| %>
      <div class="alert alert-<%= type %> alert-dismissible fade show my-3" role="alert">
        <%= msg %>
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
    <% end unless @flash.nil? %>

    <%== yield %>
  </div>

  </body>
  </html>
  ```
</details>
<br>

Now if you refresh the page, you should see a camera in the navigatiion bar.
However, if you click it the webserver will return an error because we haven't
created the server actions or pages yet.

### 1a. Add the new projects webpage and server actions

Now you need to create a new file called `new_project.erb` in the `views` directory.
This is the webpage that will be served when users navigate to the link provided
in the previous step.

In this webpage we need to supply an [form] for users to fill out.
They will be able to specify one input which is the name of the project.


`views/new_project.erb`

```diff
+<h1 class="my-3">Create a new Rendering Project</h1>
+
+<form action="<%= url("/projects/new") %>" method="post">
+
+  <div class="form-group">
+    <label for="name">Project Name</label>
+    <input type="text" name="name" class="form-control" id="name" required>
+  </div>
+
+
+  <button type="submit" class="btn btn-primary">Submit</button>
+</form>
```

Now that the form is created, add this action to the server so that the server
will know how to respond when it gets requests to the `/projects/new` [URL] through
HTTP [GET] requests.

`app.rb`

```diff
     @flash = { info: 'Welcome to Summer Institute!' }
     erb(:index)
   end
+
+  get '/projects/new' do
+    erb(:new_project)
+  end
 end
```

Now if you click on `New Project` in the navigation bar the [form] should
be rendering because the file exists and the server knows that it needs to
render it for this [URL].

Submitting this [form] however, will not work because the server does not
know how to respond to [POST] requests at the same url.

Let's add another method to the `app.rb` file so that it knows how to
respond to [POST] requests as well.

`app.rb`

```diff
     @flash = { info: 'Welcome to Summer Institute!' }
     erb :index
   end
+
+  get '/projects/new' do
+    erb(:new_project)
+  end
+
+  post '/projects/new' do
+    logger.info("Trying to create a project with: #{params.inspect}")
+    @flash = { info: "Trying to create a project with: #{params.inspect}" }
+
+    erb :new_project
+  end
 end
```

<details>
  <summary>full app.rb file</summary>

```ruby
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
    'Summer Instititue Starter App'
  end

  get '/' do
    logger.info('requsting the index')
    @flash = { info: 'Welcome to Summer Institute!' }
    erb :index
  end

  get '/projects/new' do
    erb(:new_project)
  end

  post '/projects/new' do
    logger.info("Trying to create a project with: #{params.inspect}")
    @flash = { info: "Trying to create a project with: #{params.inspect}" }

    erb :new_project
  end
end
```

</details>
<br>

Now that the server knows how to respond to the different HTTP methods on
the `/projects/new` route - you should be able to navigate to the new project's
page from the navigation bar, see the form, and submit the form without errors.

## 2. Creating new projects.

Now that we have the groundwork for creating projects - we need to
actually create the project in the `post '/projects/new'` method
(remember this is the action that's called when the users submits the
[form] through a [POST] request).

Once users create a project, we then need a route to show the project.
This will be `projects#show` that we'll also 

**Note that `/projects/new` changes to `/projects/:dir` with `:dir` being a variable.**
**There's also a special case when `:dir` is `new`**.

### 2a. Implment projects#new route.

Given users input the project `name` - we need to:

* Sanitize the input by lowercasing it and changing any spaces to underscores.
* Create the directory on the file system.
* Redirect to the page that shows the project the user just created.

Here you'll see we create a helper method called `projects_root`.
`__dir__` is the directory of the current file (`app.rb`).

`app.rb`

```diff
     erb(:new_project)
   end
 
+  # helper function for the parent directory of all projects.
+  def projects_root
+    "#{__dir__}/projects"
+  end
+
   post '/projects/new' do
-    logger.info("Trying to render frames with: #{params.inspect}")
-    @flash = { info: "Trying to render frames with: #{params.inspect}" }
+    dir = params[:name].downcase.gsub(' ', '_')
+
+    "#{projects_root}/#{dir}".tap { |d| FileUtils.mkdir_p(d) }
 
-    erb :new_project
+    session[:flash] = { info: "made new project '#{params[:name]}'" }
+    redirect(url("/projects/#{dir}"))
   end
 end
```

<details>
  <summary>full app.rb file</summary>

```ruby
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
    'Summer Instititue Starter App'
  end

  get '/' do
    logger.info('requsting the index')
    @flash = { info: 'Welcome to Summer Institute!' }
    erb :index
  end

  get '/projects/new' do
    erb(:new_project)
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
```

</details>
<br>

Note that we use [tap] method on the string `"#{projects_root}/#{dir}"`.
This one-liner is equivalent to the ruby code below, only we didn't have
to create & allocate the variable `temp_variable`.

We can create the string and use it directly with [tap] without having
to save it. We don't need to save it because we don't need to use it
a second time.

```ruby
temp_variable = "#{projects_root}/#{dir}"
FileUtils.mkdir_p(temp_variable)
```

Now when you submit the [form] in the `projects#new` page - you'll find
that the directory `./projects/<user input>` has been created. However,
the application doesn't know how to respond to the `/projects/<user input>` route yet.
We'll create this functionality in the next step.

### 2b. Creating a projects#show page.

Now that [POST] requests to `projects#new` modify the system
to create a project, we need the functionality to actually show that
project.

In this step you need to:
* modify the `get '/projects/new'` method to respond to `/projects/<some variable>`
  where `<some variable>` is the name of the project the user is trying to navigate to.
* create the HTML to be displayed when showing a project.

Create a new file the `views` called `show_project.erb`. For now, all we need is
something simple. Just showing the name of the project directory is enough for now.
Note that we're using the `@dir` in this [ERB] template which is an [instance variable].

`views/show_project.erb`

```diff
+Showing project at <%= @dir %>
```

Now let's modify `get '/projects/new'` to respond to variables in the route.

First we need to change the route from `/projects/new` to `/projects/:dir` where
`:dir` is now a variable that [Sinatra] will extract from the [URL] and put in the
`params` variable which is a [Hash]. `:dir` is the key can acess the value through
`params[:dir]`.

```diff
-  get '/projects/new' do
-    erb(:new_project)
+  get '/projects/:dir' do
+    if params[:dir] == 'new'
+      erb(:new_project)
+    else
+      @dir = Pathname.new("#{projects_root}/#{params[:dir]}")
+      erb(:show_project)
+    end
   end
```

While this works fine, we need to account for the cases when the user
has input a [URL] to a project that doesn't exist. So we need to ensure
that when we render the show page (`erb(:show_project)`) we only
render pages for valid projects.

Luckily for us, `@dir` is a [Pathname] that has all sorts of helpers to
determine if the path is valid. For us, we need to check if it is an
actual directory (through the `directory?` API) and if it's readable
(through the `readable` API).

So instead of just blindly rendering the show project page, we can
check through an `if` block if the path is both a directory and
it's readable. If it is, it's a valid path and we'll render the
show_project page. 

If it isn't, we'll alert the user and redirect to the root [URL].
Additionally, we need to reset the `@flash` [instance variable]
to account for the new alert message if it exsts.

```diff
   get '/' do
     logger.info('requsting the index')
-    @flash = { info: 'Welcome to Summer Institute!' }
+    @flash = session.delete(:flash) || { info: 'Welcome to Summer Institute!' }
     erb :index
   end

   get '/projects/:dir' do
     if params[:dir] == 'new'
       erb(:new_project)
     else
       @dir = Pathname.new("#{projects_root}/#{params[:dir]}")
-      erb(:show_project)
+
+      if(@dir.directory? && @dir.readable?)
+        erb(:show_project)
+      else
+        session[:flash] = { danger: "#{@dir} does not exist" }
+        redirect(url('/'))
+      end
+
```

The full `views/show_project.erb` is already shown above.

<details>
  <summary>full app.rb file</summary>

```ruby
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
    'Summer Instititue Starter App'
  end

  get '/' do
    logger.info('requsting the index')
    @flash = session.delete(:flash) || { info: 'Welcome to Summer Institute!' }
    erb :index
  end

  get '/projects/:dir' do
    if params[:dir] == 'new'
      erb(:new_project)
    else
      @dir = Pathname.new("#{projects_root}/#{params[:dir]}")

      if(@dir.directory? && @dir.readable?)
        erb(:show_project)
      else
        session[:flash] = { danger: "#{@dir} does not exist" }
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

```
</details>
<br>

## 3. Update the projects#index page to list all the projects.

Now that we can create projects, we need the `projects#index` route
to list them all out so that we can navigate to and from them.

Let's write a helper method called `project_dirs` that will return a list
of all the children of `projects_root` through the [Dir] class. Sorting the
list alphabetically is just a nice thing to do.

`app.rb`

```diff
     'Summer Instititue Starter App'
   end
 
+  def project_dirs
+    Dir.children(projects_root).sort_by(&:to_s)
+  end
+
   get '/' do
     logger.info('requsting the index')
     @flash = session.delete(:flash) || { info: 'Welcome to Summer Institute!' }
```

Now we can use the helper method `project_dirs` to loop through each
project directory and create a [list item] (li) for each entry and create
an [anchor] (a) link so users can navigate to the `projects#show` route
for each project.

`views/index.erb`

```diff
   <%= title %>
 </h1>
 
-Hello world!
+<h2 class="my-4">Projects</h2>
+
+<div class='row my-5'>
+  <ol class='list-group list-group-horizontal flex-wrap col-md-12'>
+    <% project_dirs.each do |project_dir| %>
+    <li class='list-group-item btn btn-outline-dark m-3 border'>
+      <div>
+        <a href='<%= url("/projects/#{project_dir}") %>' class="text-center">
+          <i class='fas fa-fw fa-camera fa-5x'></i>
+          <p><%= project_dir.gsub('_', ' ').capitalize %><p/>
+        </a>
+      </div>
+    </li>
+    <% end %>
+  </ol>
+</div>
```

<details>
  <summary>full app.rb file</summary>

```ruby
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
    'Summer Instititue Starter App'
  end

  def project_dirs
    Dir.children(projects_root).sort_by(&:to_s)
  end

  get '/' do
    logger.info('requsting the index')
    @flash = session.delete(:flash) || { info: 'Welcome to Summer Institute!' }
    erb :index
  end

  get '/projects/:dir' do
    if params[:dir] == 'new'
      erb(:new_project)
    else
      @dir = Pathname.new("#{projects_root}/#{params[:dir]}")

      if(@dir.directory? && @dir.readable?)
        erb(:show_project)
      else
        session[:flash] = { danger: "#{@dir} does not exist" }
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
```
</details>
<br>

<details>
  <summary>full views/index.erb file</summary>

```erb
<h1 class="display-4 py-3 mb-3 border-bottom">
  <%= title %>
</h1>

<h2 class="my-4">Projects</h2>

<div class='row my-5'>
  <ol class='list-group list-group-horizontal flex-wrap col-md-12'>
    <% project_dirs.each do |project_dir| %>
    <li class='list-group-item btn btn-outline-dark m-3 border'>
      <div>
        <a href='<%= url("/projects/#{project_dir}") %>' class="text-center">
          <i class='fas fa-fw fa-camera fa-5x'></i>
          <p><%= project_dir.gsub('_', ' ').capitalize %><p/>
        </a>
      </div>
    </li>
    <% end %>
  </ol>
</div>
```
</details>
<br>

## 4. Form and route for rendering frames.

### 4a. Start the frame render form.

Now that we can create projects and can navigate to and from them,
this is where the real work of the app starts.  This application
is meant to generate frames from a blend file. So, we need to provide
users with a [form] to fill out to submit a job with various
settings like how many frames they want to render from which blend file
and so on.

We need a [form] that users can fill out these fields:
  * `blend_file` [select] - which blend file they want to generate frames from.
  * `account` [select] - the account code to be used (jobs require an account for billing purposes).
  * `num_cpus` [number input] - how many CPUs the job will use.
  * `frame_range` [text input] - the range of frames the job will generate (like `1-100` will generate frames 1 through 100).
  * `walltime` [number input] - how long the job will run for.
  * `project_directory` [hidden input] - this will be a hidden field that tells the job where to output the images.

Note that we'll also need a [button] to submit the [form].

The structure for this [form] is as follows. You can read this as `<tag name>.<css class list>`.
So a `div.row` would be `<div class="row">...</div>`.

`<sizing class>` is a column class like `col-md-6` or similar. We want the form to be presented
in a visually appealing way using the [bootstrap grid] system.  We want the first 2 fields to be
of size 6 (2 items taking up the whole row) and the next 3 fields to be of size 4 (3 items
taking up the whole row). `project_directory` is hidden, so there's no need to style it.

```
form
  div.col-md-12
    div.row
      div.form-group <sizing class>
        <field>.form-control
```

As a first pass, we're going to put temporary values in the [select] options.
We'll be updating this in later phases.

`views/project_show.erb`

The entire `views/project_show.erb` at this stage is given below.

```diff
-Showing project at <%= @dir %>
+<form action="<%= url("/render/frames") %>" method="post" enctype="multipart/form-data">
+
+  <div class="col-md-12">
+    <div class="row">
+
+      <div class="form-group col-md-6">
+        <label for="blend_file">Blend File</label>
+        <select name="blend_file" id="blend_file" class="form-control">
+          <option value="tmp">Temp</option>
+        </select>
+      </div>
+
+      <div class="form-group col-md-6">
+        <label for="account">Account</label>
+        <select name="account" id="account" class="form-control">
+          <option value="tmp">Temp</option>
+        </select>
+      </div>
+
+      <div class="form-group col-md-4">
+        <label for="num_cpus">CPUs</label>
+        <input id="num_cpus" name="num_cpus" type="number" min="1" max="28" class="form-control" value='1' required>
+        <small class="form-text text-muted">More CPUs means less time rendering.</small>
+      </div>
+
+      <div class="form-group col-md-4">
+        <label for="frame_range">Frame Range (N-M)</label>
+        <input id="frame_range" name="fram_range" type="text" class="form-control" pattern="(\d+\.\.\d+)|(\d+(?:,\d+)*)" required>
+        <small class="form-text text-muted">Ex: "1..10" renders frames 1-10, "1,3,5" renders frames 1, 3 and 5...</small>
+      </div>
+
+      <div class="form-group col-md-4">
+        <label for="walltime">Walltime</label>
+        <input type="number" id="walltime" name="walltime" class="form-control" value="1" min="1" max="48">
+        <small class="form-text text-muted">Hours</small>
+      </div>
+
+      <div>
+        <input type="hidden" name="dir" id="dir" value="<%= @dir %>" required>
+      </div>
+
+    </div> <!-- end class="row" -->
+
+    <div class="row justify-content-md-end my-1">
+      <button type="submit" class="btn btn-primary float-right">Render Frames</button>
+    </div>
+  </div>
+
+</form>
```

### 4b. Populate the account list.

Now that we have the [form] ready, let's add somethings on the
backend to fill out those temporary selections and add a placeholder
for the route that we [POST] this [form] to.

First, let's populate a list of accounts that you can submit jobs with.
This will populate a list that we can use in the `account` [select] option
in the [form].

We'll use the [Etc] and [Process] modules to pull the current user's
available Unix groups. Let's add this helper for `accounts` that:
  * takes the current processes' groups
  * maps those groups (they're integers) to strings (the name of the group)
  * filter that list for all groups that start with P (only groups that start with P
    are valid projects for the job scheduler).


`app.rb`

```diff
     Dir.children(projects_root).sort_by(&:to_s)
   end
 
+  def accounts
+    Process.groups.map do |group_id|
+      Etc.getgrgid(group_id).name
+    end.select do |group|
+      group.start_with?('P')
+    end
+  end
+
   get '/' do
     logger.info('requsting the index')
     @flash = session.delete(:flash) || { info: 'Welcome to Summer Institute!' }
```

Now that the account list is populated on the backend server,
we can use them in the view.  Instead of having the 1 temporary
[select] option - let's use some [ERB] to list out all the possible
account options that one could use.

`views/show_project.erb`

```diff
       <div class="form-group col-md-6">
         <label for="account">Account</label>
         <select name="account" id="account" class="form-control">
-          <option value="tmp">Temp</option>
+          <%- accounts.each do |account| -%>
+          <option value="<%= account %>"><%= account %></option>
+          <%- end -%>
         </select>
       </div>
```

### 4c. Populate the blend file list.

Similar to the step above for accounts - let's populate the
[select] [form] field for the choice of blend file (`blend_file` [select]).

Note that this step requires you downloading a blend file or two.  At the
time of writing, version `3.6.3` is what's available. Blender distributes
[blender demo files] that are freely available. So please download
a blend file or two that is compatible with `3.6.3` and place them in the
`blend_files` directory before starting this step.

Once you've downloaded one or two [blender demo files], we first need to
get the backend server to recognize the files in the `blend_files` folder.

Let's add a `blend_files` helper method in the server to generate a list of
files that are available. We'll use the [Dir] module with the `glob` API
to use wildcards like `*` to list all files in that directory that end
with the `.blend` extension.

`app.rb`

```diff
     end
   end
 
+  def blend_files
+    Dir.glob("#{__dir__}/blend_files/*.blend").map do |f|
+      File.basename(f)
+    end
+  end
+
   get '/' do
     logger.info('requsting the index')
     @flash = session.delete(:flash) || { info: 'Welcome to Summer Institute!' }
```

Now that the server can list all our blend files, we need to update
the view to list them out. Here we can use `each` to iterate through
the collection and generate a [select] option for each blend file.

```diff
       <div class="form-group col-md-6">
         <label for="blend_file">Blend File</label>
         <select name="blend_file" id="blend_file" class="form-control">
-          <option value="tmp">Temp</option>
+          <%- blend_files.each do |file| -%>
+          <option value="<%= file %>"><%= file %></option>
+          <%- end -%>
         </select>
       </div>
```

## 5. Run the job to render frames.

With step 4 complete, step 5 is to actually submit a job that will
render frames.

`submit the job to render frames`

https://github.com/OSC/summer-institute-base-web-app/commit/02419155944ef8479872aaadfddade841c667ada

## 6. Add image carousel.

Now that we can submit jobs, step 6 adds an image carousel to the `projects#show`
page so that users can see the output of the render job.

`enhance project#show to have an image carousel`

https://github.com/OSC/summer-institute-base-web-app/commit/e0fd971505860eb1723443c2f9f7cb19203f30dc


## 7. Automatically update carousel.

Having the carousel is great, but in step 6 to update it users have to
refresh the page. This is a poor user experience, so step 7 adds some javascript
to query the filesystem for new images. When there are new images from the rendering
job, the javascript will fetch it and add it to the page automatically without
having to refresh the page.

`add javascript to update carousel automatically`

https://github.com/OSC/summer-institute-base-web-app/commit/2d1f6b9190c1abe3a433a49e5ffd03107277e5b3


## 8. Render a video.

Now we have facilities to render frames which is great! However, frames
(images) are not the result we want. We want to bundle these frames into
a movie.

Step 8 creates another form for users to fill out to that will submit
another job that will create an `mp4` video file out of all the images
you've created.

`add ability to render a video`

https://github.com/OSC/summer-institute-base-web-app/commit/3320ba8665a371cf8a81d1c89f79512f45147f79

## 9. Extra credit and beyond.

Congratulations! At this point you're done. But, like anything else, there's always
more to do. Here are a couple examples of things you can add to this application.

* Add the ability to request multiple nodes instead of just 1.  This way rendering
  frames can go much quicker becuase you'll be able to use more cores than any one
  machine has.
    * Hint: Break the problem up! Instead of rendering `1..100` frames on a single
      machine, get the program to render `1..50` on one machine and `51..100` on
      the other.  The environment variable `SLURM_ARRAY_TASK_ID` will be a different
      number for each machine you've requested.
* Add the ability to change the project icon. Right now, every project icon in `projects#index`
  is a camera (it's an icon - `i` - tag with `fas fa-fw fa-camera fa-5x` CSS classes).
  Make this configurable so that when you create a new project, you get to choose the icon.
    * Hint: google fontawesome for the entire list of icons you can use.


[form]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/form
[list item]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/li
[unorderd list]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/ul
[anchor]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/a
[idiomatic text]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/i
[GET]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/GET
[POST]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/POST
[tap]: https://docs.ruby-lang.org/en/master/Kernel.html#method-i-tap
[instance variable]: https://ruby-doc.org/docs/ruby-doc-bundle/UsersGuide/rg/instancevars.html
[ERB]: https://docs.ruby-lang.org/en/master/ERB.html
[Sinatra]: https://sinatrarb.com/documentation.html
[URL]: https://developer.mozilla.org/en-US/docs/Web/API/URL
[Hash]: https://docs.ruby-lang.org/en/master/Hash.html
[Pathname]: https://docs.ruby-lang.org/en/master/Pathname.html
[Dir]: https://docs.ruby-lang.org/en/master/Dir.html
[select]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/select
[number input]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/number
[text input]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/text
[hidden input]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/hidden
[boostrap grid]: https://getbootstrap.com/docs/4.0/layout/grid/
[button]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/button
[Etc]: https://docs.ruby-lang.org/en/master/Etc.html
[Process]: https://docs.ruby-lang.org/en/master/Process.html
[blender demo files]: https://www.blender.org/download/demo-files/
