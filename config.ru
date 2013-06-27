require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/reloader'
require 'youtube_search'

require './environment'
require './playlister_app'

parser = LibraryParser.new
parser.call('data')

run PlaylisterApp.new