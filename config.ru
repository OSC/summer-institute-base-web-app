if ENV["RACK_ENV"] != "development"
  require_relative "app"
  run App
else
  require "auto_reloader"
  AutoReloader.activate reloadable_paths: [__dir__], delay: 1
  run ->(env) {
    AutoReloader.reload! do |unloaded|
      require_relative "app"
      App.call env
    end
  }
end
