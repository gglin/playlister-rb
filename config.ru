require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/reloader'

require 'youtube_search'
require 'oembed'

require 'rack/webconsole'

require './environment'
# require './jukebox'
require './playlister_app'

parser = LibraryParser.new
parser.call('data')

run PlaylisterApp.new