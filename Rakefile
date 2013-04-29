
require 'rubygems'
require 'bundler/setup'
require 'releasy'

libdir = File.dirname(__FILE__)+"/lib"
$: << libdir
confdir = File.dirname(__FILE__)+"/config"
$: << confdir

require 'environment'
$: << GAMEBOX_PATH
load "tasks/gamebox_tasks.rake"
STATS_DIRECTORIES = [
  %w(Source            src/), 
  %w(Config            config/), 
  %w(Maps              maps/), 
  %w(Unit\ tests       specs/),
  %w(Libraries         lib/),
].collect { |name, dir| [ name, "#{APP_ROOT}/#{dir}" ] }.select { |name, dir| File.directory?(dir) }


# TODO wrap this all in Gamebox
Releasy::Project.new do
  name Gamebox.configuration.game_name.gsub(' ','')
  version "0.0.1"
  verbose # Can be removed if you don't want to see all build messages.

  executable "src/app.rb"
  files ["config/**/*.*", "src/**/*.rb", "data/**/*.*"]
  exposed_files "README.md"
  add_link "http://github.com/shawn42/seed_life", "Seed Life Source"
  exclude_encoding # Applications that don't use advanced encoding (e.g. Japanese characters) can save build size with this.

  # Create a variety of releases, for all platforms.
  add_build :osx_app do
    # lipo -remove x86_64 SeedLife.app/Contents/MacOS/SeedLife -output SeedLife.app/Contents/MacOS/SeedLife
    url "com.github.shawn42.seed_life"
    wrapper "#{ENV['HOME']}/tmp/gosu-mac-wrapper-0.7.41.tar.gz" 
    icon "data/icons/seedlife.icns"
    add_package :tar_gz
  end

  add_build :source do
    add_package :tar_gz
  end

  # If building on a Windows machine, :windows_folder and/or :windows_installer are recommended.
  add_build :windows_folder do
    icon "data/icons/seedlife.ico"
    executable_type :windows # Assuming you don't want it to run with a console window.
    add_package :exe # Windows self-extracting archive.
  end

  # add_build :windows_installer do
  #   icon "media/icon.ico"
  #   start_menu_group "Spooner Games"
  #   readme "README.html" # User asked if they want to view readme after install.
  #   license "LICENSE.txt" # User asked to read this and confirm before installing.
  #   executable_type :windows # Assuming you don't want it to run with a console window.
  #   add_package :zip
  # end

  # # If unable to build on a Windows machine, :windows_wrapped is the only choice.
  # add_build :windows_wrapped do
  #   wrapper "wrappers/ruby-1.9.3-p0-i386-mingw32.7z" # Assuming this is where you downloaded this file.
  #   executable_type :windows # Assuming you don't want it to run with a console window.
  #   exclude_tcl_tk # Assuming application doesn't use Tcl/Tk, then it can save a lot of size by using this.
  #   add_package :zip
  # end

  # add_deploy :local # Only deploy locally.
end
