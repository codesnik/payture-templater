require 'rubygems'
require 'bundler/setup'

ROOT_PATH = "#{File.dirname(__FILE__)}" unless defined?(ROOT_PATH)

Bundler.require

require File.join(ROOT_PATH, 'app')

run App
