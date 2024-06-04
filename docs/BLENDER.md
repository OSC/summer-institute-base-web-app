# Blender App to render Movies

This document walks through the different stages you'll need to go through
to create a web app that can render frames and movies.

It attempts to break features out into stages.

## Preface

Let's start small and familarize ourselves with this web application.

## Preface: app.rb

First, let's look at the `app.rb` file in the root of this project.
We're using the [Sinatra] framework to start this app.

When you load the initial page the server (the `app.rb` file itself)
responds through this function.

First we're using the `logger` to write some information to the
log file (located at `log/app.log`).  This can be useful in debugging.

Next we set the `@flash` [instance variable] to welcome the users
to the application.

Lastly, the `erb` function renders the page. The argument we give
to the `erb` function is `:index` the page we want to render. I.e.,
`views/index.erb` will be the page we want to render when the
server responds.

```ruby
  get '/' do
    logger.info('requsting the index')
    @flash = session.delete(:flash) || { info: 'Welcome to Summer Institute!' }
    erb(:index)
  end
```

### Preface: app.rb: change the flash message

To start off, let's change the flash message from
`Welcome to Summer Institute!` to anything else you like.

Note that along with `info`, there's also `danger` to
generate a red panel and `warning` to generate a yellow
panel.

### Preface: views/index.erb: change the page content

The initial page that's rendered - `views/index.erb` -
doesn't have a lot to it yet. It simply says `Hello world!`.
Let's change this text now just to get a feel for
changing the page and seeing it render.


## 1. Start the new projects page.

First we want the ability to create new rendering projects.

### 1a. Add the link to the navigation bar.

In this step we'll add a link ([anchor (a)]) in the navigation bar
([nav]) that points to the pages we'll setup in later steps.

You may have noticed that the navigation bar ([nav]) already
exists in `views/layout.erb`. It already has one link that
points to the root of this project.

The structure of the links in the navigation bar ([nav]) are
as follows: There is one single [unordered list (ul)] with many
[list item (li)]s as children. Within the [list item (li)] is an
[anchor (a)] that has an [href] that points to the page we'll be
creating in later steps. Within the [anchor (a)] is an [idiomatic text (i)]
tag for icons and the actual text we'll display for users.

The [anchor (a)]'s [href] needs a [URL] to point to.
We can use the `url` [Sinatra] function to generate one for us.
The [href] should point to `url('/projects/new')`.

```
ul (already exists)
  li
    a
      i
      "text to display"
```

**Be sure to add the [list item (li)] (li) as a child of the existing [unordered list (ul)] (ul)**

<details>
  <summary>official solution - addition to views/layout.erb.</summary>

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
</details>

<br>

<details>
  <summary>official solution - full views/layout.erb file.</summary>

  ```erb
  <!doctype html>

  <html lang="en">
  <head>
    <meta charset="utf-8">

    <title><%= title %></title>
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-fQybjgWLrvvRgtW6bFlB7jaZrFsaBXjsOMm/tB9LTS58ONXgqbR9W8oWht/amnpF" crossorigin="anonymous"></script>
    <script src="<%= url("/app.js") %>" type="text/javascript"></script>
    <link rel="icon" type="image/png" href="<%= url("/favicon.ico") %>"/>

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

Now if you refresh the page, you should see a camera in the navigation bar.
However, if you click it the webserver will return an error because we haven't
created the server actions or pages yet.

### 1b. Add the new projects webpage and server actions

Now let's make the server action and web page for this "New Projects"
functionality.

First, let's add the server action in `app.rb`.  The server needs
to respond to [GET] requests to the `/projects/new` URL path. In fact,
the error page that [Sinatra] responds with gives you a hint on how
to do this.



<details>
  <summary>official solution - addition to app.rb.</summary>

```diff
     @flash = session.delete(:flash) || { info: 'Welcome to Summer Institute!' }
     erb(:index)
   end
+
+  get '/projects/new' do
+    erb(:new_project)
+  end
 end
```
</details>
<br>

If you click this link at this point, you may get an error page
containing the error `Errno::ENOENT` because we're trying to render
a file that does not exist yet.  Simply creating the file resolves the issue.

Once you've created the `views/new_project.erb`, you can start editing
it. This webpage needs to supply an [form] for users to fill out.
Websites use [form]s to pass information from the user to the server.


This [form] should have one text [input] for specifying the
project name. This is the only piece of information required
to create a project - the name of the project.

Tips:
* [form]s need a [button] to submit the form.
* [form]s need an [action] attribute to know where to submit the form.
* [label]s are not strictly required, but should always be used to label
  [input]s.

<details>
  <summary>official solution - addition to views/new_project.erb.</summary>

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
+  <button type="submit" class="btn btn-primary my-3">Submit</button>
+</form>
```
</details>

<br>

Now if you click on `New Project` in the navigation bar the [form] should
be rendering because the file exists and the server knows that it needs to
render it for this [URL].

Submitting this [form] however, will not work because the server does not
know how to respond to [POST] requests at the same url.

Let's add another method to the `app.rb` file so that it knows how to
respond to [POST] requests to `/projects/new` as well as [GET] requests.

For simplicity in this step, let's re-render the `views/new_project.erb`
while providing a new `@flash` message containing the parameters
that were sent. [Sinatra] provides the `params` variable to inspect
what parameters have been sent to the web server.


<details>
  <summary>official solution - addition to app.rb file.</summary>

```diff
     @flash = session.delete(:flash) || { info: 'Welcome to Summer Institute!' }
     erb(:index)
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
+    erb(:new_project)
+  end
 end
```
</details>

<br>

<details>
  <summary>official solution - full app.rb file.</summary>

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
    erb(:index)
  end

  get '/projects/new' do
    erb(:new_project)
  end

  post '/projects/new' do
    logger.info("Trying to create a project with: #{params.inspect}")
    @flash = { info: "Trying to create a project with: #{params.inspect}" }

    erb(:new_project)
  end
end
```

</details>
<br>

<details>
  <summary>official solution - full views/new_project.erb file.</summary>

```erb
<div class="d-flex justify-content-center">
  <h1 class="my-2">Create a new rendering project</h1>    
</div>

<form action="<%= url("/projects/new") %>" method="post">

  <div class="form-group">
    <label for="name">Name</label>
    <input id="name" name="name" type="text" class="form-control" required/>
  </div>

  <button type="submit" class="btn btn-primary my-2">Submit</button>
</form>
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
This will be `get '/projects/:name'` route that we'll also use to create new
projects.

**Note that `/projects/new` changes to `/projects/:name` with `:name` being a variable.**
**There's also a special case when `:name` is `new`**.

### 2a. Implement new projects.

Given users input the project `name` - we need to:

* Sanitize the input by lowercasing it and changing any spaces to underscores.
* Create the directory on the file system.
* Redirect to the page that shows the project the user just created.
  Though this redirection will fail until we get to step 2b.

Tips:
* You should create project directories under the `projects` directory
  already a part of this application. Calling `__dir__` within `app.rb`
  will give you the current directory of the file (app.rb).
* You can use [FileUtils] to create directories.
* [Sinatra] provides a `redirect` helper function to redirect
  the client to a different page.

<br>

<details>
  <summary>official solution - addition to app.rb.</summary>

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

-    erb(:new_project)
+    session[:flash] = { info: "made new project '#{params[:name]}'" }
+    redirect(url("/projects/#{dir}"))
   end
 end
```
</details>

<br>

<details>
  <summary>official solution - full app.rb file</summary>

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
    erb(:index)
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

Now when you submit the [form] in the ` get '/projects/:name'` page - you'll find
that the directory `./projects/<user input>` has been created. However,
the application doesn't know how to respond to the `/projects/<user input>` route yet.
We'll create this functionality in the next step.

### 2b. Creating a page for showing projects.

Now that [POST] requests to `/projects/new` modify the system
to create a project, we need the functionality to actually show that
project.

In this step you need to:
* Modify the `get '/projects/new'` method to respond to `/projects/:name`
  where `:name` is the variable project name the user is trying to navigate to.
* Create the HTML to be displayed when showing a project. This
  should be `views/show_project.erb` file. It can contain anything at this point,
  it just needs to exist.

Tips:
* When changing the route from `/projects/new` to `/projects/:name`
  [Sinatra] will extract the variable `:name` from the [URL] and populate
  the `params` [Hash] with that key that you can access through `params[:name]`.
* See https://sinatrarb.com/intro.html for more information. You can
  search this page for `:name` to see the examples.
* Note that you'll have to account for the edge case when `:name` is `new`.
  If the `:name` variable is 'new' we should render `views/new_project.erb`
  instead of `views/show_project.erb`.

<br>

<details>
  <summary>official solution - addition to app.rb.</summary>

```diff
-  get '/projects/new' do
-    erb(:new_project)
+  get '/projects/:name' do
+    if params[:name] == 'new'
+      erb(:new_project)
+    else
+      erb(:show_project)
+    end
   end
```
</details>

<br>

### 2c. Validate the directory.

While this works fine, we need to account for the cases when the user
has input a [URL] to a project that doesn't exist. So we need to ensure
that when we render the show page (`erb(:show_project)`) we only
render pages for valid projects.

In this step you must validate that the parameter `:name` is actually
a directory.

Tips:
* Create a [Pathname] variable that is `projects_root` (created in a previous step)
  and the `params[:name]` variable. [Pathname] has nice helper functions
  like `directory?` to check if the path is an actual directory.
* Use an `if` block to check if the path is valid. If it isn't
  you should provide a danger flash message and redirect to the root
  [URL] ("/").


<details>
  <summary>official solution - addition to app.rb.</summary>

```diff
   get '/projects/:name' do
     if params[:name] == 'new'
       erb(:new_project)
     else
       @directory = Pathname.new("#{projects_root}/#{params[:name]}")
-      erb(:show_project)
+
+      if(@directory.directory? && @directory.readable?)
+        erb(:show_project)
+      else
+        session[:flash] = { danger: "#{@directory} does not exist" }
+        redirect(url('/'))
+      end
+
```
</details>

<br>

<details>
  <summary>official solution - views/show_project.erb file.</summary>

```erb
Showing project at <%= @directory %>
```
</details>

<br>

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
    erb(:index)
  end

  get '/projects/:name' do
    if params[:name] == 'new'
      erb(:new_project)
    else
      @directory = Pathname.new("#{projects_root}/#{params[:name]}")

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

```
</details>
<br>

## 3. Update the / (index) page to list all the projects.

### 3a. Find all the project directories.

Now that we can create projects, we need the `/` (index) route
to list them all out so that we can navigate to and from them.


In this step you'll need to generate an [Array] of all the project
directories.

Tips:
* You should already have helper method `projects_root` that is the
  parent directory for all the projects.
* You can use the [Dir] class to find children of that directory.
* You'll need to show only directories, filtering out files. The
  [Pathname] class is a great choice to help you do this.

Let's write a helper method called `project_dirs` that will return a list
of all the children of `projects_root` through the [Dir] class. Sorting the
list alphabetically is just a nice thing to do.

<details>
  <summary>official solution - addition to app.rb file.</summary>


```diff
     'Summer Instititue Starter App'
   end

+  def project_dirs
+    Dir.children(projects_root).select do |path|
+      Pathname.new("#{projects_root}/#{path}").directory?
+    end.sort_by(&:to_s)
+  end
+
   get '/' do
     logger.info('requsting the index')
     @flash = session.delete(:flash) || { info: 'Welcome to Summer Institute!' }
```
</details>

<br>

### 3b. Find all the project directories.

Now we can use the helper method `project_dirs` to loop through each
project directory and create an [unordered list (ul)] with a [list item (li)]
for each project directory and create an [anchor (a)] link so users
can navigate to the `/projects/:name` route for each project.

Additionally, within the [anchor (a)] we can use [idiomatic text (i)] tags
for icons to make it look nice and a [paragraph (p)] tag to display
the project name.

Here is the structure we're looking for. Note that you can also use
[div] tags for spacing and sizing.

So, this is the structure we're going for more or less.  Note that
you may opt for an outer [div] to create the right size of icons.

```
ul
  li
    a
      i
      p
```

<details>
  <summary>official solution - addition to views/index.erb file.</summary>

```diff
   <%= title %>
 </h1>

-Hello world!
+<h2 class="my-4">Projects</h2>
+
+<div class='row my-5'>
+  <ul class='list-group list-group-horizontal flex-wrap col-md-12'>
+    <% project_directories.each do |project_dir| %>
+    <li class='list-group-item btn btn-outline-dark m-3 border'>
+      <div>
+        <a href='<%= url("/projects/#{project_dir}") %>' class="text-center">
+          <i class='fas fa-fw fa-camera fa-5x'></i>
+          <p><%= project_dir.gsub('_', ' ').capitalize %><p/>
+        </a>
+      </div>
+    </li>
+    <% end %>
+  </ul>
+</div>
```
</details>
<br>

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
    Dir.children(projects_root).select do |path|
      Pathname.new("#{projects_root}/#{path}").directory?
    end.sort_by(&:to_s)
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
is meant to generate frames from a blend file. So, in the `show_project.erb`
page we need to provide users with a [form] to fill out to submit a job
with various settings like how many frames they want to render from which
blend file and so on.

**Note that this form should POST requests to /render/frames and this POST request will not work until we finish step 5.**


We need a [form] that users can fill out these fields:
  * `blend_file` [select] - which blend file they want to generate frames from.
  * `account` [select] - the account code to be used (jobs require an account for billing purposes).
  * `num_cpus` [number input] - how many CPUs the job will use.
    This should have a minimum of 4 and a maximum of 48.
  * `frame_range` [text input] - the range of frames the job will generate
    (like `1-100` will   generate frames 1 through 100).  Note `blender`
    expects this field to be a specific format and that we can check for specific
    patterns using the `pattern` attribute.
  * `walltime` [number input] - how long the job will run for.
  * `project_directory` [hidden input] - this will be a hidden field that tells the job where to output the images.

Note that we'll also need a [button] to submit the [form] and that
all fields are required.

Beyond just providing the [form] for functionality, we should
style it too so that it looks visually pleasing to users. The
official solution provides the structure for this [form] as follows.
You can read this as `<tag name>.<css class list>`. So a `div.row`
would be `<div class="row">...</div>` and so on.

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


This is the visual structure we're going for:

||||
| ------- | ------- | ------ |
|    blend_file ||    account   |
| num_cpus |frame_range|walltime|

Tips:
* As a first pass, you should put temporary values in the [select] options
  for `account` and `blend_file`.  We'll be updating this in later phases.
* Create the form with all the fields first, then add the [div]s and style it.
* After styling it, at a minimum you should add [label]s. Additionally,
  you could add [small] help text for some fields.
* Remember [form]s need an [action] and `method` attributes to know how
  and where to submit the form. The [action] will be `<%= url("/render/frames") %>`
  (even though we haven't implemented this on the server yet) and the
  `method` will be `post`.


<details>
  <summary>official solution - addition to views/show_project.erb file.</summary>

```diff
-Showing project at <%= @directory %>
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
+        <input id="num_cpus" name="num_cpus" type="number" min="4" max="48" class="form-control" value='4' required>
+        <small class="form-text text-muted">More CPUs means less time rendering.</small>
+      </div>
+
+      <div class="form-group col-md-4">
+        <label for="frame_range">Frame Range (N-M)</label>
+        <input id="frame_range" name="frame_range" type="text" class="form-control" pattern="(\d+\.\.\d+)|(\d+(?:,\d+)*)" required>
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
+        <input type="hidden" name="project_directory" id="project_directory" value="<%= @directory %>" required>
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
</details>

<br>

<details>
  <summary>official solution - full views/show_project.erb file.</summary>

```html
<form action="<%= url("/render/frames") %>" method="post" enctype="multipart/form-data">

  <div class="col-md-12">
    <div class="row">

      <div class="form-group col-md-6">
        <label for="blend_file">Blend File</label>
        <select name="blend_file" id="blend_file" class="form-control">
          <option value="tmp">Temp</option>
        </select>
      </div>

      <div class="form-group col-md-6">
        <label for="account">Account</label>
        <select name="account" id="account" class="form-control">
          <option value="tmp">Temp</option>
        </select>
      </div>

      <div class="form-group col-md-4">
        <label for="num_cpus">CPUs</label>
        <input id="num_cpus" name="num_cpus" type="number" min="4" max="48" class="form-control" value='4' required>
        <small class="form-text text-muted">More CPUs means less time rendering.</small>
      </div>

      <div class="form-group col-md-4">
        <label for="frame_range">Frame Range (N-M)</label>
        <input id="frame_range" name="frame_range" type="text" class="form-control" pattern="(\d+\.\.\d+)|(\d+(?:,\d+)*)" required>
        <small class="form-text text-muted">Ex: "1..10" renders frames 1-10, "1,3,5" renders frames 1, 3 and 5...</small>
      </div>

      <div class="form-group col-md-4">
        <label for="walltime">Walltime</label>
        <input type="number" id="walltime" name="walltime" class="form-control" value="1" min="1" max="48">
        <small class="form-text text-muted">Hours</small>
      </div>

      <div>
        <input type="hidden" name="project_directory" id="project_directory" value="<%= @directory %>" required>
      </div>

    </div> <!-- end class="row" -->

    <div class="row justify-content-md-end my-1">
      <button type="submit" class="btn btn-primary float-right">Render Frames</button>
    </div>
  </div>

</form>
```
</details>

<br>

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


<details>
  <summary>official solution - addition to app.rb file.</summary>

```diff
  def project_dirs
    Dir.children(projects_root).select do |path|
      Pathname.new("#{projects_root}/#{path}").directory?
    end.sort_by(&:to_s)
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
</details>
<br>

Now that the account list is populated on the backend server,
we can use them in the view.  Instead of having the 1 temporary
[select] option - let's use some [ERB] to list out all the possible
account options that one could use.

<details>
  <summary>official solution - addition to views/show_project.erb file.</summary>

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

</details>
<br>

### 4c. Populate the blend file list.

Similar to the step above for accounts - let's populate the
[select] [form] field for the choice of blend file (`blend_file` [select]).

Note that this step requires you downloading a blend file or two.  At the
time of writing, version `4.2` is what's available. Blender distributes
[blender demo files] that are freely available. So please download
a blend file or two that is compatible with `4.2` and place them in the
`blend_files` directory before starting this step.

Once you've downloaded one or two [blender demo files], we first need to
get the backend server to recognize the files in the `blend_files` folder.

Let's add a `blend_files` helper method in the server to generate a list of
files that are available. The official solution uses the [Dir] module with
the `glob` API to use wildcards like `*` to list all files in that directory
that end with the `.blend` extension.

Tips:
* [Dir].glob will return the full path of the file, so you
  should also [map] that full file to the file's basename. You can
  use [File] class find the basename.

<details>
  <summary>official solution - addition to app.rb file.</summary>

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
</details>
<br>

Now that the server can list all our blend files, we need to update
the view to list them out. Here we can use [each] to iterate through
the collection and generate a [select] option for each blend file.

<details>
  <summary>official solution - addition to views/show_project.erb file</summary>

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
</details>
<br>

### 4d. Fixup the show_project page.

This step is just a couple UI enhancements to make the page
layout a little bit better in `get /projects/:name`.

We'd like to add the project name to the page. Before we can
add it to the HTML page, we need to define it in the server.

Recall that the directory name is the name of the project.
Also recall that we did some sanitization to the directory
changing spaces (` `) to underscores (`_`), so we'll want
to reverse that operation before presenting it in the UI.

Tips:
* `@directory` is a [Pathname], which we can use `basename` on
  to get the directory name (and not the full path).
* Refer to another location where we used `gsub` on a string
  to change it.
* Strings also provide a `capitalize` function.
* `project_name` should be an [instance variable] (i.e., `@project_name`).


<details>
  <summary>official solution - addition to app.rb file.</summary>

```diff
       erb(:new_project)
     else
       @directory = Pathname.new("#{projects_root}/#{params[:name]}")
+      @project_name = @directory.basename.to_s.gsub('_', ' ').capitalize

       if(@directory.directory? && @directory.readable?)
         erb(:show_project)
```
</details>
<br>


Now that the server has the [instance variable] `@project_name`,
we can display it in the web page.

The official solution uses [heading elements] to display the
name of the project as well as the section of the page that
you're rendering frames in the [form].


<details>
  <summary>official solution - addition to views/show_project.erb file.</summary>

```diff
+<h1 class='d-flex my-2 justify-content-center'><%= @project_name %></h1>
+
+<h2>Render Frames</h2>
+
 <form action="<%= url("/render/frames") %>" method="post" enctype="multipart/form-data">

   <div class="col-md-12">
```
</details>
<br>

<details>
  <summary>official solution - full app.rb file.</summary>

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
```
</details>
<br>

<details>
  <summary>full views/show_project.erb file</summary>

```erb
<h1 class='d-flex my-2 justify-content-center'><%= @project_name %></h1>

<h2>Render Frames</h2>

<form action="<%= url("/render/frames") %>" method="post" enctype="multipart/form-data">

  <div class="col-md-12">
    <div class="row">

      <div class="form-group col-md-6">
        <label for="blend_file">Blend File</label>
        <select name="blend_file" id="blend_file" class="form-control">
          <%- blend_files.each do |file| -%>
          <option value="<%= file %>"><%= file %></option>
          <%- end -%>
        </select>
      </div>

      <div class="form-group col-md-6">
        <label for="account">Account</label>
        <select name="account" id="account" class="form-control">
          <%- accounts.each do |account| -%>
          <option value="<%= account %>"><%= account %></option>
          <%- end -%>
        </select>
      </div>


      <div class="form-group col-md-4">
        <label for="num_cpus">CPUs</label>
        <input id="num_cpus" name="num_cpus" type="number" min="4" max="48" class="form-control" value='4' required>
        <small class="form-text text-muted">More CPUs means less time rendering.</small>
      </div>

      <div class="form-group col-md-4">
        <label for="frame_range">Frame Range (N-M)</label>
        <input id="frame_range" name="frame_range" type="text" class="form-control" pattern="(\d+\.\.\d+)|(\d+(?:,\d+)*)" required>
        <small class="form-text text-muted">Ex: "1..10" renders frames 1-10, "1,3,5" renders frames 1, 3 and 5...</small>
      </div>

      <div class="form-group col-md-4">
        <label for="walltime">Walltime</label>
        <input type="number" id="walltime" name="walltime" class="form-control" value="1" min="1" max="48">
        <small class="form-text text-muted">Hours</small>
      </div>

      <div>
        <input type="hidden" name="project_directory" id="project_directory" value="<%= @directory %>" required>
      </div>

    </div> <!-- end class="row" -->

    <div class="row justify-content-md-end my-1">
      <button type="submit" class="btn btn-primary float-right">Render Frames</button>
    </div>
  </div>

</form>
```
</details>
<br>

## 5. Rendering frames.

Step 4 added a [form] so that users can render frames from within
a project view. However, the route for rendering frames does not
exist yet (or doesn't do anything). In this step we'll make that
route and start an [HPC] job that renders the frames from the
chosen blend file.

If you haven't already, you can add a starter `post '/render/frames`
method. You can simply `redirect` somewhere else in this function.
It may also be nice to provide a `flash` message, perhaps containing
the `params` object.

<details>
  <summary>official solution - addition to app.rb file</summary>

```diff
     end
   end
 
+  post '/render/frames' do
+    session[:flash] = { info: "rendering frames with '#{params}'" }
+    redirect(url("/"))
+  end
+
   get '/' do
     logger.info('requsting the index')
     @flash = session.delete(:flash) || { info: 'Welcome to Summer Institute!' }
```
</details>

Now if you press `Render Frames` in the [form] of the `get '/projects/:name`
page you'll get redirected to the root [URL] with a flash message.

At this point, we need to buildout the [sbatch] command to run the job given
all the input that the user entered in the [form].

[sbatch] takes many command line arguments. Here's what we'll be setting
from the `params` variable the user provides in the [form]:
  * `account` will set the `-A` flag.
  * `walltime` will set `-t` flag after being formatted to `HH:00:00`.
  * `num_cpus` will set `-n` flag.
  * `blend_file` will populate the `BLEND_FILE_PATH` environment variable.
  * `project_directory` will populate the `OUTPUT_DIR` environment variable
    and be used to set the job's output location for the `--output` flag.
  * `frame_range` will populate the `FRAME_RANGE` environment variable.
  * We can hard code the cluster to be `pitzer` through the `-M` flag.
  * You should also hard code the `--parseable` flag so that the command
    output is parseable.
  * We should also set the job name with the `-J` option. This job name
    should have the `blend_file` parameter in it to distinguish the job.
  * The last argument to `sbatch` will be the shell script we're trying to
    run in the job. This shell script already exists in this project at
    `scripts/render_frames.sh`.

We can use backtick characters (`` ` ``) to issue a command from the Ruby server.
For example `` `echo 'hello world'` `` within your Ruby program will issue the
command `echo 'hello world'`.

Tips:
* Start the `sbatch` command with as few arguments as possible.
  Get it to launch the job, then add parameters.
* The [format] function to format the `params[:walltime]` into the
  `HH:00:00` format.
* You can assign the output of commands to a variable when running
  commands with backticks (`` ` ``) in Ruby.
* The official solution takes the output of the `sbatch` command
  and displays a `flash` message when the next page is loaded.
  You can extract this message from the `session` object in the
  `get '/projects/:name'` method.

<details>
  <summary>official solution - addition to app.rb file</summary>

```diff
     else
         @directory = Pathname.new("#{projects_root}/#{name}")
         @project_name = @directory.basename.to_s.gsub('_', ' ').capitalize
+        @flash = session.delete(:flash)
 
         if(@directory.directory? && @directory.readable?)
             erb(:show_project)
```

```diff
   post '/render/frames' do
-    session[:flash] = { info: "rendering frames with '#{params}'" }
-    redirect(url("/"))
+    logger.info("rendering frames with #{params.inspect}")
+
+    blend_file = "#{__dir__}/blend_files/#{params[:blend_file]}"
+    walltime = format('%02d:00:00', params[:walltime])
+    dir = params[:project_directory]
+
+    args = ['-J', "blender-#{params[:blend_file]}", '--parsable', '-A', params[:account]]
+    args.concat ['--export', "BLEND_FILE_PATH=#{blend_file},OUTPUT_DIR=#{dir},FRAME_RANGE=#{params[:frame_range]}"]
+    args.concat ['-n', params[:num_cpus], '-t', walltime, '-M', 'pitzer']
+    args.concat ['--output', "#{dir}/%j.out"]
+
+    output = `/bin/sbatch #{args.join(' ')}  #{__dir__}/scripts/render_frames.sh 2>&1`
+    job_id = output.strip.split(';').first
+
+    session[:flash] = { info: "submitted job #{job_id}" }
+    redirect(url("/projects/#{dir.split('/').last}"))
   end
 
   get '/' do
```
</details>

<br>

<details>
  <summary>official solution - full app.rb file.</summary>

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

  post '/render/frames' do
    logger.info("rendering frames with #{params.inspect}")

    blend_file = "#{__dir__}/blend_files/#{params[:blend_file]}"
    walltime = format('%02d:00:00', params[:walltime])
    dir = params[:project_directory]

    args = ['-J', "blender-#{params[:blend_file]}", '--parsable', '-A', params[:account]]
    args.concat ['--export', "BLEND_FILE_PATH=#{blend_file},OUTPUT_DIR=#{dir},FRAME_RANGE=#{params[:frame_range]}"]
    args.concat ['-n', params[:num_cpus], '-t', walltime, '-M', 'pitzer']
    args.concat ['--output', "#{dir}/%j.out"]

    output = `/bin/sbatch #{args.join(' ')}  #{__dir__}/scripts/render_frames.sh 2>&1`
    job_id = output.strip.split(';').first

    session[:flash] = { info: "submitted job #{job_id}" }
    redirect(url("/projects/#{dir.split('/').last}"))
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
      @flash = session.delete(:flash)

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
```
</details>
<br>

## 6. Add image carousel.

### 6a. Start the image carousel.

Now that we can submit jobs, step 6 adds an image carousel to the `get '/projects/:name'`
page so that users can see the output of the render job.

The official solution uses the [Bootstrap carousel] library to show the
images on the page in a visually pleasing way.

To complete this step we need to:
  * Find all the images on the backend server and assign the [Array]
    to and [instance variable].
  * Use the [Bootstrap carousel] library to display all the images.

Finding the images is as easy as using the [Dir] module to glob (use wildcards)
the directory where they should be. This will find all the files in the directory
that end with `.png` extension and assign this [Array] to an [instance variable]
we call `@images`.

<details>
  <summary>official solution - addition to app.rb file</summary>

```diff
       @directory = Pathname.new("#{projects_root}/#{params[:name]}")
       @project_name = @directory.basename.to_s.gsub('_', ' ').capitalize
       @flash = session.delete(:flash)
+      @images = Dir.glob("#{@directory}/*.png")
 
       if(@directory.directory? && @directory.readable?)
         erb(:show_project)
```
</details>
<br>

The [HTML] to show the images is far more complicated.
Looking at the [Bootstrap carousel] documentation we need to
create some outer [div]s around our [img]s so that [Bootstrap]
knows where to apply the changes.

This is the basic structure of elements with [CSS Class]es
that we'll need to get this on the page.

```
div[class="carousel slide" data-ride="carousel"]
  div[class="carousel-inner]

    <!-- loop start -->
    div[class="carousel-item"] (the first image will also have the 'active' class)
      img
    <!-- loop end -->
```

This works by:
* Applying the [HTML data attributes] `data-ride="carousel"`
  to the outer most `div`.
* Applying the [CSS Classs]es `carousel` and `slide` to the
  outer most div.
* Applying the [CSS Classs] `carousel-inner` to the inner
  [div].
* Looping through all the `@images` to create a [div] that
  has the [CSS CLass] `carousel-item`.  This [div] will have
  a child [img] element that is the actual image.
  * The very first image will additionally have the [CSS CLass]
    `active`. Instead of [each] you can use [each_with_index]
    to supply the index of the [Array] and apply the `active`
    class when the index is zero.
  * The `@images` is an [Array] of full paths to the file.
    You can use `/pun/sys/dashboard/files/fs<%= image %>` as
    the [src] attribute for the [img].


<details>
  <summary>official solution - addition to views/show_project.erb file</summary>

```diff
 <h1 class='d-flex my-2 justify-content-center'><%= @project_name %></h1>
 
+<div class="row my-3">
+
+  <div id="blend_image_carousel" class="carousel slide" data-ride="carousel">
+    <div id="blend_image_carousel_inner" class="carousel-inner">
+
+      <%- @images.each_with_index do |image, index| -%>
+      <div id="<%= File.basename(image) %>" class="carousel-item <%= index == 0 ? 'active' : nil %>">
+        <img class="d-block w-100" src="/pun/sys/dashboard/files/fs<%= image %>">
+      </div>
+      <%- end -%>
+
+    </div> <!-- carousel inner -->
+
+  </div><!-- carousel -->
+</div>
+
+
 <h2>Render Frames</h2>
```
</details>
<br>

### 6b. Add carousel indicators.

With the carousel created, you should see the images in the `get '/projects/:name'`
routes. The bootstrap [javascript] should be iterating through these images.

That's all well and good, but should still enable a way for users to navigate
through all the images. 

First, we'll add an [unordered list (ul)] with [list item (li)]s to be our carousel
indicators. Carousel indicators are the items at the bottom of the carousel
that users can click on to navigate to specific images.

We'll add this [unordered list (ul)] as a sibling to the [div] with the [CSS Class] `carousel-inner`.

So if we take the structure from step 6a and add this, it becomes:

```
div[class="carousel slide" data-ride="carousel"]
  div[class="carousel inner"]

    <!-- loop over each image begin -->
    div[class="carousel-item"] (the first image will also have class 'active')
      img
    <!-- loop end >

    ol[class="carousel-indicators"]
    <!-- loop over each image number begin -->
      li[data-slide-to="the image number"] (the first indicator will have the class 'active')
    <!-- loop end >
```

This works by:
* Applying the [CSS Class] `carousel-indicators` to the [unordered list (ul)]
* Each [list item (li)] needs:
  * A `data-target` [HTML data attributes]. This is a [CSS Selector] that should
    just be a query for the `id` of `id` of the outer most [div] with the `data-ride="carousel"`.
    A [CSS Selector] for an `id` is just `#` and the `id` for example `#my_div_id` when
    `my_div_id` is the `id` of the [div] you're looking for.
    **Note you may have to add an id to the outer most [div] if you haven't already**.
  * A `data-slide-to` [HTML data attributes] that is the image number that indicator
    will slide to. **Note that `data-slide-to` numbers are expected to start at 0.**
  * The very first [list item (li)] will need the [CSS Class] `active`.

Tips:
* The [list item (li)]s all need a number to know where to slide to.
  * The `@images` [instance variable] is an [Array] so you can call
    `length` on that array to find the length of the [Array].
  * You can use the [Range] class to create another [Array] that is
    all the numbers 1 through `@images.length`.
  * Or you can use [each_with_index] on `@images` and just disregard
    the image variable, using only the index variable.
* Note that the [Bootstrap carousel] library expects the `data-slide-to`
  [HTML data attributes] to start at 0. So if you have 2 images, the
  `data-slide-to` attributes would be `0` and `1` not `1` and `2`.

<br>

<details>
  <summary>official solution - update to views/show_project.erb file.</summary>

```diff
   <div id="blend_image_carousel" class="carousel slide" data-ride="carousel">
 
+    <ol id="blend_image_carousel_indicators" class="carousel-indicators">
+      <% (1..@images.length).each do |index| %>
+      <li data-target="#blend_image_carousel" data-slide-to="<%= index-1 %>" class="<%= index == 1 ? 'active' : nil %>" ></li>
+      <% end %>
+    </ol>
+
     <div id="blend_image_carousel_inner" class="carousel-inner">
```
</details>
<br>

Now you should have indicators at the bottom of the images. There should be
one for each image. They should be clickable and correctly 

### 6c. Add carousel previous & next buttons. 

Now that we have carousel indicators, we also want to add buttons to
navigate to the previous and next images.

We'll use [anchor (a)]s that are siblings to the [div] with the
[CSS Class] `carousel-inner`.

These [anchor (a)]s will have two children, both of them [span]s.
The first [span] will be the actual clickable icon. The second
is for Accessibility of screen readers to indicate what this button
does (because there's no visual text for what the button does).

Tips:
* This is the structure with [CSS Class]es. Note that this example is
  for the previous button. The next button would use `carousel-control-next`
  and `carousel-control-next-icon` [CSS Class]es.

```
a[class="carousel-control-prev" role="button" href="#blend_image_carousel" data-slide="prev"]
  span[class="carousel-control-prev-icon" aria-hidden="true"]
  span[class="sr-only"]
    Previous
```

<details>
  <summary>official solution - addition to views/show_project.erb file.</summary>

```diff
     </div> <!-- carousel inner -->
 
+    <a class="carousel-control-prev" href="#blend_image_carousel" role="button" data-slide="prev">
+      <span class="carousel-control-prev-icon" aria-hidden="true"></span>
+      <span class="sr-only">Previous</span>
+    </a>
+
+    <a class="carousel-control-next" href="#blend_image_carousel" role="button" data-slide="next">
+      <span class="carousel-control-next-icon" aria-hidden="true"></span>
+      <span class="sr-only">Next</span>
+    </a>
+
   </div><!-- carousel -->
```
</details>

<br>

<details>
  <summary>official solution - full app.rb file.</summary>

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

  post '/render/frames' do
    logger.info("rendering frames with #{params.inspect}")

    blend_file = "#{__dir__}/blend_files/#{params[:blend_file]}"
    walltime = format('%02d:00:00', params[:walltime])
    dir = params[:project_directory]

    args = ['-J', "blender-#{params[:blend_file]}", '--parsable', '-A', params[:account]]
    args.concat ['--export', "BLEND_FILE_PATH=#{blend_file},OUTPUT_DIR=#{dir},FRAME_RANGE=#{params[:frame_range]}"]
    args.concat ['-n', params[:num_cpus], '-t', walltime, '-M', 'pitzer']
    args.concat ['--output', "#{dir}/%j.out"]

    output = `/bin/sbatch #{args.join(' ')}  #{__dir__}/scripts/render_frames.sh 2>&1`
    job_id = output.strip.split(';').first

    session[:flash] = { info: "submitted job #{job_id}" }
    redirect(url("/projects/#{dir.split('/').last}"))
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
      @flash = session.delete(:flash)
      @images = Dir.glob("#{@directory}/*.png")

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
```
</details>
<br>

<details>
  <summary>official solution - full views/show_project.erb file.</summary>

```erb
<h1 class='d-flex my-2 justify-content-center'><%= @project_name %></h1>

<div class="row my-3">

  <div id="blend_image_carousel" class="carousel slide" data-ride="carousel">

    <ol id="blend_image_carousel_indicators" class="carousel-indicators">
      <% (1..@images.length).each do |index| %>
      <li data-target="#blend_image_carousel" data-slide-to="<%= index-1 %>" class="<%= index == 1 ? 'active' : nil %>" ></li>
      <% end %>
    </ol>

    <div id="blend_image_carousel_inner" class="carousel-inner">

      <%- @images.each_with_index do |image, index| -%>
      <div id="<%= File.basename(image) %>" class="carousel-item <%= index == 0 ? 'active' : nil %>">
        <img class="d-block w-100" src="/pun/sys/dashboard/files/fs<%= image %>">
      </div>
      <%- end -%>

    </div> <!-- carousel inner -->

    <a class="carousel-control-prev" href="#blend_image_carousel" role="button" data-slide="prev">
      <span class="carousel-control-prev-icon" aria-hidden="true"></span>
      <span class="sr-only">Previous</span>
    </a>

    <a class="carousel-control-next" href="#blend_image_carousel" role="button" data-slide="next">
      <span class="carousel-control-next-icon" aria-hidden="true"></span>
      <span class="sr-only">Next</span>
    </a>

  </div><!-- carousel -->

</div>


<h2>Render Frames</h2>

<form action="<%= url("/render/frames") %>" method="post" enctype="multipart/form-data">

  <div class="col-md-12">
    <div class="row">

      <div class="form-group col-md-6">
        <label for="blend_file">Blend File</label>
        <select name="blend_file" id="blend_file" class="form-control">
          <%- blend_files.each do |file| -%>
          <option value="<%= file %>"><%= file %></option>
          <%- end -%>
        </select>
      </div>

      <div class="form-group col-md-6">
        <label for="account">Account</label>
        <select name="account" id="account" class="form-control">
          <%- accounts.each do |account| -%>
          <option value="<%= account %>"><%= account %></option>
          <%- end -%>
        </select>
      </div>


      <div class="form-group col-md-4">
        <label for="num_cpus">CPUs</label>
        <input id="num_cpus" name="num_cpus" type="number" min="4" max="48" class="form-control" value='4' required>
        <small class="form-text text-muted">More CPUs means less time rendering.</small>
      </div>

      <div class="form-group col-md-4">
        <label for="frame_range">Frame Range (N-M)</label>
        <input id="frame_range" name="frame_range" type="text" class="form-control" pattern="(\d+\.\.\d+)|(\d+(?:,\d+)*)" required>
        <small class="form-text text-muted">Ex: "1..10" renders frames 1-10, "1,3,5" renders frames 1, 3 and 5...</small>
      </div>

      <div class="form-group col-md-4">
        <label for="walltime">Walltime</label>
        <input type="number" id="walltime" name="walltime" class="form-control" value="1" min="1" max="48">
        <small class="form-text text-muted">Hours</small>
      </div>

      <div>
        <input type="hidden" name="project_directory" id="project_directory" value="<%= @directory %>" required>
      </div>

    </div> <!-- end class="row" -->

    <div class="row justify-content-md-end my-1">
      <button type="submit" class="btn btn-primary float-right">Render Frames</button>
    </div>
  </div>

</form>
```
</details>
<br>

## 7. Automatically update carousel.

Having the carousel is great, but as it is in step 6,
users have to manually refresh the page to see any updates.
This is a poor user experience, so step 7 adds some [javascript]
to query the filesystem for new images. When there are new
images from the rendering job, the [javascript] will fetch it
and add it to the page automatically without users having to
refresh the page.

We're using the [jquery] [javascript] framework for convenience. 

### 7a. Start editing app.js

The [javascript] file `public/app.js` is already loaded on every page.
We're going to add to this file in this step.

`jQuery` is a function that will run when the [window page load event]
is fired. I.e., when the page is loaded.

Let's change this slightly by:
* Adding a new function called `updateCarousel` that takes no arguments.
* This new function `updateCarousel` should do something simple like logging
  some simple message through `console.log`.
* The block provided to the `jQuery` function should call this new function
  `updateCarousel`.

**Note that you may have to hard refresh the page (ctrl + shift + r) to download the new app.js file.**

<details>
  <summary>official solution - update to public/app.js file.</summary>

```diff
 jQuery(() => {
-  console.log('hello world');
+  updateCarousel();
 });
+
+function updateCarousel() {
+  console.log('hello world from the updateCarousel function.');
+}
```
</details>
<br>

### 7b. Pass directory to javascript.

Now that we have a helper function to update the carousel,
let's get started with that work!

First we need a way to pass the project's directory to
the [javascript] running on the client's browser.  We can do this
through [HTML data attributes].

Let's add a hidden [div] with on data attribute for the directory.
The [CSS Class] `d-none` sets the display attribute to none to make
it invisible.

Tips:
* A [div] with no text will not be visible on the page. However
  adding the [CSS Class] `d-none` will ensure that it's not on the page.
* This [div] will need an [id] so that we can easily query for the element.
* [HTML data attributes] can be arbitrarily named. That is, there's noting
  preventing you from adding `data-asdnwenbtadsnsdf='foo'` to an element.
  However, it would be hard to query for that. So you should likely just use
  `data-directory` to make it easy.

<details>
  <summary>official solution - update to views/show_project.erb file.</summary>

```diff
         </div>
     </div>
 </form>
+
+<div class='d-none' id="project_config" data-directory="<%= @directory %>">
+</div>
```
</details>
<br>

Now in `public/app.js` we can query for this element and extract
the directory so that we can then later list the files in that
directory.

First we use plain [javascript] APIs like [getElementById] to get
the [HTML] element we're looking for.  Note that `app.js` is being
loaded on every page. So if `configElement` is `null`, we should
just exit because we're not on a project's page.

Once we have the element we're looking for, we can use it's
[dataset] to find the `directory`. We'll need this parameter
because that is the file system location we'll be inspecting
for new png images.

Tips:
* Use [getElementById] to find the element we're looking for.
  (We're looking for the element we just created in this step).
* Remember to check if this element is `null` which it will be
  on the index page.
* [HTML data attributes] are present in [javascript] objects
  through the [dataset] property.

<details>
  <summary>official solution - addition to public/app.js file.</summary>

```diff
 function updateCarousel() {
-  console.log('hello world');
+  const configElement = document.getElementById('project_config');
+  if(configElement == null) {
+    return;
+  }
+
+  const directory = configElement.dataset.directory;
+
+  console.log(`will be querying ${directory} for new images.`);
 }
```
</details>
<br>

### 7c. Fetch the directory data.

Now that we know what directory we want to query to
find the new images - we can start making those queries.

We'll be using the [javascript]'s [fetch] API to make
HTTP calls to Open OnDemand's files app.

Since we already know the directory we need to query,
we can put that directly in the `url` variable.
Next we'll need a set of options, importantly,
the [Accept header]. This tells the server what
we're willing to accept in the response. We specify that
we're only willing to accept `application/json` in the
server's response.

We can then call [fetch] and simply turn the data into [json]
format. We'll then just log it to the console in this step.

Tips:
* The [URL] parameter is `/pun/sys/dashboard/files/fs/` +
  the directory you're searching.
* Be sure to use the `'Accept': 'application/json'` [HTTP Header]
  to tell the server you want a `json` response.
* Although the response is actually `json`, the initial response
  from [fetch] will be a text string. Use the `json()` function
  on the response to turn into actual `json` data.
* [fetch] will return a [Promise] object. You can chain together many
  instances of [then] after a [Promise] resolves. The data returned
  in one [then] will be the input to the next [then].

<details>
  <summary>official solution - update to public/app.js file.</summary>

```diff
  console.log(`will be querying ${directory} for new images.`);
+
+  const url = `/pun/sys/dashboard/files/fs/${directory}`;
+  const options = {
+    headers: {
+      'Accept': 'application/json'
+    }
+  }
+
+  fetch(url, options)
+    .then(response => response.json())
+    .then(data => console.log(data));
 }
```
</details>
<br>

### 7d. Mapping and filtering the json data

The files response we're getting from the server isn't
exactly what we need. So, we're going to need to do
some translations and filtering before we can update the 
[DOM (Document Object Model)].

We need to:
* Extract the file property from the json response.
* Extract the name property of the file from the file data.
* Filter the list of names for only names that end with png.

Tips:
* Use your browsers console to inspect the json object.
  (it should be printing to the console log).
* Use the [map (js)] function to map data from one format to another.
* Use the [filter] function to filter data.

<details>
  <summary>official solution - addition to public/app.js file.</summary>

```diff

   fetch(url, options)
     .then(response => response.json())
-    .then(data => console.log(data));
+    .then(data => data['files'])
+    .then(files => files.map(file => file['name']))
+    .then(files => files.filter(file => file.endsWith('png')))
+    .then(files => {
+      for(const file of files) {
+        console.log(file);
+      }
+    });
 }
```
</details>
<br>

### 7e. Determine if image needs to be added.

Now that we've extracted all the file names that currently
exist on the filesystem, we can almost begin to modify the
[DOM (Document Object Model)]. Let's setup the scaffoling
to do just that.

We need to:

* While looping through all the images - determine if the page
  already has that image.
* At the end of the loop call updateCarousel again to continue
  searching for new files.

In the loop of all files, we can generate the [HTML id] and use
[getElementById] to query for the iamge.  If we find the image
is already on the page (the query returned something that is not 
`null`) we can just continue the loop.

If we don't find the image already on the [DOM (Document Object Model)]
we'll just log that we will be adding it.

**Note that in step 6a you may not have provided a unique id to each image. The [div] that wraps images should have a unique [id] based off of the filename itself.**

As the last step, we can use [setTimeout] to call the `updateCarousel`
function all over again in 30,000 milliseconds (30 seconds) thereby
continuing our search for new images.

Tips:
* Use [setTimeout] to call `updateCarousel` again at some point in the future.
* The [div] wrapping the [img] needs a unique [id]. If you didn't apply unique
  [id]s in step 6a, you need to do so now.
* You can use [getElementById] to find the [div] that holds the [img].
  If this returns `null` the image does not yet exist on the page.

<details>
  <summary>official solution - addition to public/app.js file.</summary>

```diff
     .then(files => files.filter(file => file.endsWith('png')))
     .then(files => {
       for(const file of files) {
-        console.log(file);
+
+        const image = document.getElementById(file);
+
+        // image is already on the DOM so just return.
+        if(image != null) {
+          console.log(`skipping ${file} because it's already on the DOM.`);
+          continue;
+        }
+
+        console.log(`adding ${file} to the DOM.`);
+
       }
+
+      setTimeout(updateCarousel, 30000);
     });
 }
```
</details>
<br>

### 7f. Create new image div.

Now that we have the [javascript] built out to query
the filesystem for new files, we need to edit the
[DOM (Document Object Model)] to add the new file.

Fist, we'll make the new [HTML] [div].  The [div]
we're attempting to make is given below. This should look
familar from the `views/show_project.erb`.

```html
<div id="render_0001_png" class="carousel-item">
  <img class="d-block w-100" src="/path/to/image/render_0001.png">
</div>
```

To do this with [javascript] we'll use the [createElement] API.
Let's create the outer [div] first. We'll use the [classList] API
to add the `carousel-item` class to it.

To add the [img] element as the inner child [HTML] to the parent
[div] `newImage` we can use the [innerHTML] API and provide a string.

Tips:
* Use the [createElement] API do create new elements.
* Use the [classList] property to add [CSS Class]es to the element.
* Use [innerHTML] to define the inner HTML of the element.
  * Note this can be a string and you can use [template literals] 
  like `` `constant and ${variable}` `` to create strings.


<details>
  <summary>official solution - addition to public/app.js file</summary>

```diff
         console.log(`adding ${imageId} to the DOM.`);
 
+        newImage = document.createElement('div');
+        newImage.id = file;
+        newImage.classList.add('carousel-item');
+        newImage.innerHTML = `<img class="d-block w-100" src="/pun/sys/dashboard/files/fs/${directory}/${file}" >`;
+
       }
 
       setTimeout(updateCarousel, 30000);
```
</details>
<br>

### 7g. Create new li indicator.

Now we have the [javascript] creating a new [div] and [img]
which is great.  However, the [Bootstrap carousel] has
[list item (li)] indicators at the bottom for navigation.

We can't add the image without the [list item (li)] indicator, so
let's do that now.

The [HTML] we're trying to build is similar to this (though the numbers
in `data-slide-to` will be variable).

```html
<li data-target="#blend_image_carousel" data-slide-to="1"></li>
```

Again, we'll use the [createElement] API, but this time passing
`li` as the argument.

We can use the [setAttribute] API to add [HTML data attributes]
to the [list item (li)].

<details>
  <summary>official solution - addition to public/app.js file.</summary>

```diff
         newImage.innerHTML = `<img class="d-block w-100" src="/pun/sys/dashboard/files/fs/${q}/${file}" >`;
 
-
+        const newIndicator = document.createElement('li');
+        newIndicator.setAttribute('data-target', '#blend_image_carousel');
       }
 
       setTimeout(updateCarousel, 30000);
```
</details>
<br>

We also need to set the `data-slide-to` [HTML data attributes] as
well. To do this however, we need to find the current size of the
[ol] so that we can add 1 to that value to get the correct
`data-slide-to` value.

Luckily the [ol] in question has the [id] `blend_image_carousel_indicators`.
So we can use the handy [getElementById] to find it. When we call
[children] on this element, it'll return an [Array] of child elements.
We can then call `length` on that array to find the number of children
in the [ol].

<details>
  <summary>official solution - addition to public/app.js file</summary>

```diff
         newImage.innerHTML = `<img class="d-block w-100" src="/pun/sys/dashboard/files/fs/${q}/${file}" >`;
 
+
+        const indicatorList = document.getElementById('blend_image_carousel_indicators');
+        const totalImages = indicatorList.children.length;
         const newIndicator = document.createElement('li');
         newIndicator.setAttribute('data-target', '#blend_image_carousel');
+        newIndicator.setAttribute('data-slide-to', totalImages);
       }
 
       setTimeout(updateCarousel, 30000);
```
</details>
<br>

### 7h. Attach elements to the DOM.

Now that we have the elements, there's one
edge case we need to take care of - what
happens when there are no images on the page?

Well, if there are no images on the page yet,
we need to add the `active` [CSS Class] to the indicator
and image.  We can check the `totalImages` to see if
it's 0 or not. If it is, we'll apply the [CSS Class].

Tips:
* Use the [classList] property on the element to add the `active` class.

<details>
  <summary>official solution - addition to public/app.js file.</summary>

```diff
         newIndicator.setAttribute('data-target', '#blend_image_carousel');
         newIndicator.setAttribute('data-slide-to', totalImages);
+
+        if(totalImages == 0) {
+          newIndicator.classList.add('active');
+          newImage.classList.add('active');
+        }
       }
 
       setTimeout(updateCarousel, 30000);
```
</details>

With that edge case out of the way - we can now
actually add the newly created elements to the [DOM (Document Object Model)].

We can do this through the [append] API on elements that
are already a part of the [DOM (Document Object Model)].

Note that we want to append the new image [div]s to the
`blend_image_carousel_inner` element, so we have to query
for it.

Tips:
* [append] will append the new element as a child of the existing element.

```diff
           newIndicator.classList.add('active');
           newImage.classList.add('active');
         }
+        const carousel = document.getElementById('blend_image_carousel_inner');
+
+        carousel.append(newImage);
+        indicatorList.append(newIndicator);
       }
```

### 7i. Edge case for first image.

There is an edge case we have to account for and it's this:
What happens when the page loads without any images and the [javascript]
is adding the very first image?

The answer is: nothing. This is becuase we need to apply the `active`
[CSS Class] to the image if it's the very first image.

Tips:
* We have the variable `totalImages` which is the number of total
  images. If it is `0` - then this is the first image and we need to
  apply the [CSS Class] `active`.
* `active` needs to be applied to both the [div] that holds the image
  _and_ the [list item (li)] that is the indicator.
* You can use the [classList] property to add the `active` class to
  these elements.

<details>
  <summary>official solution - addition to the public/app.js file.</summary>

```diff
         const carousel = document.getElementById('blend_image_carousel_inner');
 
+        if(totalImages == 0){
+          newImage.classList.add('active');
+          newIndicator.classList.add('active');
+        }
+
         carousel.append(newImage);
         indicatorList.append(newIndicator);
       }
```
</details>
<br>
<details>
  <summary>official solution - full public/app.js file.</summary>

```javascript

jQuery(() => {
  updateCarousel();
});

function updateCarousel() {
  const configElement = document.getElementById('project_config');
  if(configElement == null) {
    return;
  }

  const directory = configElement.dataset.directory;

  const url = `/pun/sys/dashboard/files/fs/${directory}`;
  const options = {
    headers: {
      'Accept': 'application/json'
    }
  }

  fetch(url, options)
    .then(response => response.json())
    .then(data => data['files'])
    .then(files => files.map(file => file['name']))
    .then(files => files.filter(file => file.endsWith('png')))
    .then(files => {
      for(const file of files) {
        
        const image = document.getElementById(file);

        // image is already on the DOM so just return.
        if(image != null) {
          console.log(`skipping ${file} because it's already on the DOM.`);
          continue;
        }

        console.log(`adding ${file} to the DOM.`);

        newImage = document.createElement('div');
        newImage.id = file;
        newImage.classList.add('carousel-item');
        newImage.innerHTML = `<img class="d-block w-100" src="/pun/sys/dashboard/files/fs/${directory}/${file}" >`;

        const indicatorList = document.getElementById('blend_image_carousel_indicators');
        const totalImages = indicatorList.children.length;
        const newIndicator = document.createElement('li');
        newIndicator.setAttribute('data-target', '#blend_image_carousel');
        newIndicator.setAttribute('data-slide-to', totalImages);

        const carousel = document.getElementById('blend_image_carousel_inner');

        if(totalImages == 0){
          newImage.classList.add('active');
          newIndicator.classList.add('active');
        }

        carousel.append(newImage);
        indicatorList.append(newIndicator);
      }

      setTimeout(updateCarousel, 30000);
    });
}
```
</details>
<br>

## 8. Render a video.

Now we have facilities to render frames which is great! However, frames
(images) are not the result we want. We want to bundle these frames into
a movie.

Step 8 creates another form for users to fill out to that will submit
another job that will create an `mp4` video file out of all the images
you've created.

### 8a. Video rendering form.

We're going to need another [form] for users to fill out to
submit another job.

This form will need:
* `account` is a [select] widget which is the same account from step 4a.
* `frames_per_second` is a [number input] to define the frames 
  per second the video is rendered with.
* `num_cpus` will be a [number input] to define how many CPUs the
  job will use just like in step 4a.
* `walltime` is an [number input] to define the job's running
  time just like in step 4a.
* `project_directory` is a [hidden input] to define the proejct's
  directory just like in step 4a.

There are 4 visible [form] items for the user to fill out.
For simplicity, we'll use `col-md-3` sizes for all [form]
fields so that they all fit on the same row.

This form will submit to a route that doesn't exist yet.
It should submit to `url("/render/video")` which we will
implement in the next step.

Tips:
* Many of these are already defined in the other form you
  created in step 4a. Refer to them for guidance.
* Remember that [form]s need an [action] and a [button].


<details>
  <summary>official solution - addition to views/show_project.erb</summary>

```diff
 <div id="project_config" class="d-none" data-directory="<%= @directory %>">
 </div>
+
+<h2 class="my-2">Render Video</h2>
+
+<form action="<%= url("/render/video") %>" method="post">
+  <div class="col-md-12">
+    <div class="row">
+
+      <div class="form-group col-md-3">
+        <label for="account">Account</label>
+        <select name="account" id="account" class="form-control">
+          <%- accounts.each do |account| -%>
+          <option value="<%= account %>"><%= account %></option>
+          <%- end -%>
+        </select>
+      </div>
+
+      <div class="form-group col-md-3">
+        <label for="frames_per_second">Frames Per Second</label>
+        <input class="form-control" type="number" max="60" name="frames_per_second">
+      </div>
+
+      <div class="form-group col-md-3">
+        <label for="num_cpus">CPUs</label>
+        <input id="num_cpus" name="num_cpus" type="number" min="1" max="48" class="form-control" value='4' required>
+        <small class="form-text text-muted">More CPUs means less time rendering.</small>
+      </div>
+
+      <div class="form-group col-md-3">
+        <label for="walltime">Walltime</label>
+        <input type="number" id="walltime" name="walltime" class="form-control" value="1" min="1" max="48">
+        <small class="form-text text-muted">Hours</small>
+      </div>
+
+      <div>
+        <input type="hidden" name="project_directory" id="project_directory" value="<%= @directory %>" required>
+      </div>
+
+    </div> <!-- row -->
+
+    <div class="row justify-content-md-end my-1">
+      <button type="submit" class="btn btn-primary float-right">Render Frames</button>
+    </div>
+  </div>
+</form>
```
</details>
<br>

### 8b. Video rendering job.

Just as before, we made the [form] before we made the route
that can handle it.  Similar to the `post '/render/frames'`
route, we need to make a `post '/render/videos'` route.

This method will be very similar to the method in
`post '/render/frames'` where we build an [sbatch]
command to submit a job.

The script we'll be submitting is `scripts/render_video.sh`.
The [sbatch] command will use the input from 

Once again, [sbatch] takes many command line arguments. Here's what 
we'll be setting from the `params` variable the user provides in 
the [form]:
* `account` will set the `-A` flag.
* `walltime` will set `-t` flag after being formatted to `HH:00:00`.
* `num_cpus` will set `-n` flag.
* `frames_per_second` will populate the `FRAMES_PER_SECOND` environment variable.
* `project_directory` will populate the `OUTPUT_DIR` environment variable
  and be used to set the job's output location for the `--output` flag.

Tips:
* Start small and build on what you have. You can start just by
  defining the method, then flashing params. I.e., `@flash = params.inspect`.
* Look at `post '/render/frames'` or step 4 for additional information on how
  to issue a command in Ruby.

<details>
  <summary>official solution - addition to app.rb file.</summary>

```diff
     session[:flash] = { info: "made new project '#{params[:name]}'" }
     redirect(url("/projects/#{dir}"))
   end
+
+  post '/render/video' do
+    logger.info("Trying to render video with: #{params.inspect}")
+
+    output_dir = params[:project_directory]
+    frames_per_second = params[:frames_per_second]
+    walltime = format('%02d:00:00', params[:walltime])
+
+    args = ['-J', 'blender-video', '--parsable', '-A', params[:account]]
+    args.concat ['--export', "FRAMES_PER_SEC=#{frames_per_second},OUTPUT_DIR=#{output_dir}"]
+    args.concat ['-n', params[:num_cpus], '-t', walltime, '-M', 'pitzer']
+    args.concat ['--output', "#{output_dir}/video-render-%j.out"]
+    output = `/bin/sbatch #{args.join(' ')}  #{__dir__}/scripts/render_video.sh 2>&1`
+
+    job_id = output.strip.split(';').first
+
+    session[:flash] = { info: "Submitted job #{job_id}"}
+    redirect(url("/projects/#{output_dir.split('/').last}"))
+  end
 end
```
</details>
<br>

<details>
  <summary>official solution - full app.rb file</summary>

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

  post '/render/frames' do
    logger.info("rendering frames with #{params.inspect}")

    blend_file = "#{__dir__}/blend_files/#{params[:blend_file]}"
    walltime = format('%02d:00:00', params[:walltime])
    dir = params[:project_directory]

    args = ['-J', "blender-#{params[:blend_file]}", '--parsable', '-A', params[:account]]
    args.concat ['--export', "BLEND_FILE_PATH=#{blend_file},OUTPUT_DIR=#{dir},FRAME_RANGE=#{params[:frame_range]}"]
    args.concat ['-n', params[:num_cpus], '-t', walltime, '-M', 'pitzer']
    args.concat ['--output', "#{dir}/%j.out"]

    output = `/bin/sbatch #{args.join(' ')}  #{__dir__}/scripts/render_frames.sh 2>&1`
    job_id = output.strip.split(';').first

    session[:flash] = { info: "submitted job #{job_id}" }
    redirect(url("/projects/#{dir.split('/').last}"))
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
      @flash = session.delete(:flash)
      @images = Dir.glob("#{@directory}/*.png")

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

  post '/render/video' do
    logger.info("Trying to render video with: #{params.inspect}")

    output_dir = params[:project_directory]
    frames_per_second = params[:frames_per_second]
    walltime = format('%02d:00:00', params[:walltime])

    args = ['-J', 'blender-video', '--parsable', '-A', params[:account]]
    args.concat ['--export', "FRAMES_PER_SEC=#{frames_per_second},OUTPUT_DIR=#{output_dir}"]
    args.concat ['-n', params[:num_cpus], '-t', walltime, '-M', 'pitzer']
    args.concat ['--output', "#{output_dir}/video-render-%j.out"]
    output = `/bin/sbatch #{args.join(' ')}  #{__dir__}/scripts/render_video.sh 2>&1`

    job_id = output.strip.split(';').first

    session[:flash] = { info: "Submitted job #{job_id}"}
    redirect(url("/projects/#{output_dir.split('/').last}"))
  end
end
```
</details>
<br>

<details>
  <summary>official solution - full views/show_project.erb file.</summary>

```erb
<h1 class='d-flex my-2 justify-content-center'><%= @project_name %></h1>

<div class="row my-3">

  <div id="blend_image_carousel" class="carousel slide" data-ride="carousel">

    <ol id="blend_image_carousel_indicators" class="carousel-indicators">
      <% (1..@images.length).each do |index| %>
      <li data-target="#blend_image_carousel" data-slide-to="<%= index-1 %>" class="<%= index == 1 ? 'active' : nil %>" ></li>
      <% end %>
    </ol>

    <div id="blend_image_carousel_inner" class="carousel-inner">

      <%- @images.each_with_index do |image, index| -%>
      <div id="<%= File.basename(image) %>" class="carousel-item <%= index == 0 ? 'active' : nil %>">
        <img class="d-block w-100" src="/pun/sys/dashboard/files/fs<%= image %>">
      </div>
      <%- end -%>

    </div> <!-- carousel inner -->

    <a class="carousel-control-prev" href="#blend_image_carousel" role="button" data-slide="prev">
      <span class="carousel-control-prev-icon" aria-hidden="true"></span>
      <span class="sr-only">Previous</span>
    </a>

    <a class="carousel-control-next" href="#blend_image_carousel" role="button" data-slide="next">
      <span class="carousel-control-next-icon" aria-hidden="true"></span>
      <span class="sr-only">Next</span>
    </a>

  </div><!-- carousel -->

</div>


<h2>Render Frames</h2>

<form action="<%= url("/render/frames") %>" method="post" enctype="multipart/form-data">

  <div class="col-md-12">
    <div class="row">

      <div class="form-group col-md-6">
        <label for="blend_file">Blend File</label>
        <select name="blend_file" id="blend_file" class="form-control">
          <%- blend_files.each do |file| -%>
          <option value="<%= file %>"><%= file %></option>
          <%- end -%>
        </select>
      </div>

      <div class="form-group col-md-6">
        <label for="account">Account</label>
        <select name="account" id="account" class="form-control">
          <%- accounts.each do |account| -%>
          <option value="<%= account %>"><%= account %></option>
          <%- end -%>
        </select>
      </div>


      <div class="form-group col-md-4">
        <label for="num_cpus">CPUs</label>
        <input id="num_cpus" name="num_cpus" type="number" min="4" max="48" class="form-control" value='4' required>
        <small class="form-text text-muted">More CPUs means less time rendering.</small>
      </div>

      <div class="form-group col-md-4">
        <label for="frame_range">Frame Range (N-M)</label>
        <input id="frame_range" name="frame_range" type="text" class="form-control" pattern="(\d+\.\.\d+)|(\d+(?:,\d+)*)" required>
        <small class="form-text text-muted">Ex: "1..10" renders frames 1-10, "1,3,5" renders frames 1, 3 and 5...</small>
      </div>

      <div class="form-group col-md-4">
        <label for="walltime">Walltime</label>
        <input type="number" id="walltime" name="walltime" class="form-control" value="1" min="1" max="48">
        <small class="form-text text-muted">Hours</small>
      </div>

      <div>
        <input type="hidden" name="project_directory" id="project_directory" value="<%= @directory %>" required>
      </div>

    </div> <!-- end class="row" -->

    <div class="row justify-content-md-end my-1">
      <button type="submit" class="btn btn-primary float-right">Render Frames</button>
    </div>
  </div>

</form>

<div id="project_config" class="d-none" data-directory="<%= @directory %>">
</div>

<h2 class="my-2">Render Video</h2>

<form action="<%= url("/render/video") %>" method="post">
  <div class="col-md-12">
    <div class="row">

      <div class="form-group col-md-3">
        <label for="account">Account</label>
        <select name="account" id="account" class="form-control">
          <%- accounts.each do |account| -%>
          <option value="<%= account %>"><%= account %></option>
          <%- end -%>
        </select>
      </div>

      <div class="form-group col-md-3">
        <label for="frames_per_second">Frames Per Second</label>
        <input class="form-control" type="number" max="60" name="frames_per_second">
      </div>

      <div class="form-group col-md-3">
        <label for="num_cpus">CPUs</label>
        <input id="num_cpus" name="num_cpus" type="number" min="1" max="48" class="form-control" value='4' required>
        <small class="form-text text-muted">More CPUs means less time rendering.</small>
      </div>

      <div class="form-group col-md-3">
        <label for="walltime">Walltime</label>
        <input type="number" id="walltime" name="walltime" class="form-control" value="1" min="1" max="48">
        <small class="form-text text-muted">Hours</small>
      </div>

      <div>
        <input type="hidden" name="project_directory" id="project_directory" value="<%= @directory %>" required>
      </div>

    </div> <!-- row -->

    <div class="row justify-content-md-end my-1">
      <button type="submit" class="btn btn-primary float-right">Render Frames</button>
    </div>
  </div>
</form>
```
</details>
<br>

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
* Add the ability to change the project icon. Right now, every project icon in the index page
  is a camera (it's an icon - `i` - tag with `fas fa-fw fa-camera fa-5x` CSS classes).
  Make this configurable so that when you create a new project, you get to choose the icon.
    * Hint: google fontawesome for the entire list of icons you can use.
* Once you've completed stop 8, you can additionally display the video on the webpage.
* Add the ability to track jobs. Once the job is created, the status of the job
  is not indicated on these pages. This makes the user navigate away from this page
  to see the job's status. This extra credit work would add the ability to track the
  jobs you submit through the [form]s.
    * Hint: Save the job id to a file that you can read back later.
    * Hint: Use the [squeue] command to query for the state of the job.


[form]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/form
[list item (li)]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/li
[unordered list (ul)]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/ul
[anchor (a)]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/a
[href]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/a#href
[idiomatic text (i)]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/i
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
[heading elements]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/Heading_Elements
[HPC]: https://en.wikipedia.org/wiki/High-performance_computing
[sbatch]: https://slurm.schedmd.com/sbatch.html
[squeue]: https://slurm.schedmd.com/squeue.html
[Bootstrap carousel]: https://getbootstrap.com/docs/4.0/components/carousel/
[Array]: https://docs.ruby-lang.org/en/master/Array.html
[div]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/div
[each]: https://docs.ruby-lang.org/en/master/Enumerable.html#method-i-each_entry
[img]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/img
[each_with_index]: https://docs.ruby-lang.org/en/master/Enumerable.html#method-i-each_with_index
[CSS Class]: https://developer.mozilla.org/en-US/docs/Web/CSS/Class_selectors
[jquery]: https://api.jquery.com/
[window page load event]: https://developer.mozilla.org/en-US/docs/Web/API/Window/load_event
[HTML data attributes]: https://developer.mozilla.org/en-US/docs/Learn/HTML/Howto/Use_data_attributes
[getElementById]: https://developer.mozilla.org/en-US/docs/Web/API/Document/getElementById
[fetch]: https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API
[Accept header]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Accept
[json]: https://www.json.org/json-en.html
[DOM (Document Object Model)]: https://developer.mozilla.org/en-US/docs/Web/API/Document_Object_Model
[HTML id]: https://developer.mozilla.org/en-US/docs/Web/HTML/Global_attributes/id
[setTimeout]: https://developer.mozilla.org/en-US/docs/Web/API/setTimeout
[javascript]: https://developer.mozilla.org/en-US/docs/Web/JavaScript
[HTML]: https://developer.mozilla.org/en-US/docs/Web/HTML
[newElement]: https://developer.mozilla.org/en-US/docs/Web/API/Document/createElement
[classList]: https://developer.mozilla.org/en-US/docs/Web/API/Element/classList
[innerHTML]: https://developer.mozilla.org/en-US/docs/Web/API/Element/innerHTML
[setAttribute]: https://developer.mozilla.org/en-US/docs/Web/API/Element/setAttribute
[id]: https://developer.mozilla.org/en-US/docs/Web/HTML/Global_attributes/id
[children]: https://developer.mozilla.org/en-US/docs/Web/API/Element/children
[nav]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/nav
[input]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input
[action]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/form#action
[label]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/label
[FileUtils]: https://docs.ruby-lang.org/en/master/FileUtils.html
[paragraph (p)]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/p
[small]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/small
[map]: https://docs.ruby-lang.org/en/master/Enumerable.html#method-i-map
[File]: https://docs.ruby-lang.org/en/master/File.html
[format]: https://docs.ruby-lang.org/en/master/format_specifications_rdoc.html
[src]: https://developer.mozilla.org/en-US/docs/Web/API/HTMLImageElement/src
[Bootstrap]: https://getbootstrap.com/docs/4.0/getting-started/introduction/
[Range]: https://docs.ruby-lang.org/en/master/Range.html
[CSS Selector]: https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_selectors
[span]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/span
[dataset]: https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/dataset
[HTTP Header]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers
[map (js)]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/map
[then]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/then
[Promise]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise
[filter]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/filter
[createElement]: https://developer.mozilla.org/en-US/docs/Web/API/Document/createElement
[classList]: https://developer.mozilla.org/en-US/docs/Web/API/Element/classList
[template literals]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals
[append]: https://developer.mozilla.org/en-US/docs/Web/API/Element/append