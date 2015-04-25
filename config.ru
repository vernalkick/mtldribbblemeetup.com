require 'rubygems'
require 'bundler'
require 'autoprefixer-rails'
require 'dotenv'

Bundler.require(:default, ENV['RACK_ENV'])

Dotenv.load

use Rack::CanonicalHost, ENV['CANONICAL_HOST'] if ENV['CANONICAL_HOST']

map '/assets' do
  sprockets = Sprockets::Environment.new
  sprockets.append_path 'assets/stylesheets'
  sprockets.append_path 'assets/images'
  sprockets.append_path 'assets/javascripts'
  run sprockets

  AutoprefixerRails.install(sprockets)
end

require './app'
run App
