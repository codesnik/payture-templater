require 'rubygems'
require 'sinatra/base'
require 'slim'
require_relative './lib/stuff'

class App < Sinatra::Base
  set :logging, true
  set :public_folder, File.join(ROOT_PATH, 'public')

  Settings = unmarshal_config(File.join(ROOT_PATH, 'config', 'config.yml')).symbolize_keys!
  I18n = unmarshal_config(File.join(ROOT_PATH, 'config', 'locale.yml'))[Settings[:language]].symbolize_keys!

  get '/' do
    @templates =
      Dir.entries(Settings[:templates_dir]).select do |fn|
        fn =~ /.*\.template$/
      end
    logger.info @templates

    slim(:index)
  end

  get '/show' do
    @template = File.join(Settings[:templates_dir], params[:template])
    content = File.read(@template)
    content.gsub!(/{(.*)}/) do
      I18n[$1.to_sym]
    end
  end

  run! if app_file == $PROGRAM_NAME
end
