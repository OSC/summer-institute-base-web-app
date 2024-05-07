# Base Sinatra App for Summer Institute

![GitHub Release](https://img.shields.io/github/release/osc/ood-example-ps.svg)
[![GitHub License](https://img.shields.io/badge/license-MIT-green.svg)](https://opensource.org/licenses/MIT)

This app is meant as a base Passenger app that runs in an [OnDemand] portal
that uses the [Sinatra] web framework for OSC's [Summer Institute].

Feel free to modify it anyway you see fit.

## Deploy

The directions below require Ruby and Bundler be installed and accessible from
the command line. At OSC we use modules, so you'll need to issue this command
to load the right `ruby` environment.

```console
$ module load ruby/3.1.4
```

1. To deploy and run this app you will need to first go to your OnDemand
   sandbox directory (if it doesn't exist, then we create it):

   ```console
   $ mkdir -p ~/ondemand/dev
   $ cd ~/ondemand/dev
   ```

2. Then clone down this app and `cd` into it:

   ```console
   $ git clone https://github.com/OSC/summer-institute-base-web-app.git blender
   Cloning into 'blender'...
   $ cd blender
   ```

3. Setup the app before you use it:

   ```console
   $ bin/setup

   ...
   ```

4. Now you should be able to access this app from OSC OnDemand at
   https://ondemand.osc.edu/pun/dev/blender/

   Note: You may need to replace the domain above with your center's OnDemand
   portal location if not using OSC.

## Develop

Development instructions are in the `docs/` folder.

* Here's the link to [develop a Blender app](/docs/BLENDER.md)


## Locally develop

While this application is meant to be used at [OSC] during [Summer Institute]
you can develop this app on your own time on your own machine.

The one caveat being that you can't submit jobs to a scheduler from your
local machine. You can however, use this application to continue to learn
about [Ruby], [Sinatra], [HTML] and more!

Simply hop into a shell of your choosing, navigate to the directory of this
application and issue the command `bin/start`. You should see output similar
to what's given below.

Now you can connect to the application through http://localhost:9001. Note that
you can change the port in the `bin/start` script as it's given as the first
arguement `-p9001`.

```console
$ bin/start
...
Using sinatra 2.2.3
Using webrick 1.8.1
Bundle complete! 6 Gemfile dependencies, 16 gems now installed.
Bundled gems are installed into `./vendor/bundle`
[2024-05-07 09:57:30] INFO  WEBrick 1.8.1
[2024-05-07 09:57:30] INFO  ruby 3.0.2 (2021-07-07) [x86_64-linux-gnu]
[2024-05-07 09:57:30] INFO  WEBrick::HTTPServer#start: pid=7881 port=9001
```

[OnDemand]: http://openondemand.org/
[Sinatra]: http://sinatrarb.com/
[Summer Institute]: https://www.osc.edu/education/si
[OSC]: https://www.osc.edu/
[Ruby]: https://docs.ruby-lang.org/en/master/
[HTML]: https://developer.mozilla.org/en-US/docs/Web/HTML
