#!/usr/bin/env ruby

# $: << File.join(File.dirname($0),"..","config")
require_relative '../config/environment'

GameboxApp.run ARGV, ENV
