#!/usr/bin/env ruby
require 'bundler'
require 'sinatra'
require 'slim'
require 'yaml'
require 'pathname'

unless ARGV[0]
  warn "provide root path, like this: #$0 path/to/dir [path/to/args.yml]"
  exit 1
end

enable :logging
set :public_folder, ARGV[0]
set :args_file, ARGV[1]

get '/' do
  base = Pathname.new(settings.public_folder)
  @templates = Pathname.glob(base.join('**/*.template')).map {|p| p.relative_path_from(base) }
  slim(:index)
end

get '/show' do
  @template = File.join(settings.public_folder, params[:template])
  # reloading args file here on every request
  args =
    if settings.args_file && test(?r, settings.args_file)
      YAML.load_file(settings.args_file)
    else
      {}
    end
  args.merge!(params)
  content = File.read(@template)
  content.gsub!(/{(.*?)}/) do
    args[$1] || "{#{$1}}"
  end
end

post '*' do
  @args = params.dup
  @args.delete_if {|k, v| k == "splat" || k == "captures" }
  @args = @args.sort
  slim(:post)
end

puts "open http://localhost:4567/"
