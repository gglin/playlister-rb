
class PlaylisterApp < Sinatra::Base

  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    @artists = Artist.all
    @songs = Song.all
    @genres = Genre.all
    erb :'index.html'
  end

  get '/artists' do
    @artists = Artist.all
    erb :'artist/artists'
  end

  get '/songs' do
    @songs = Song.all
    erb :'song/songs'
  end

  get '/genres' do
    @genres = Genre.all
    erb :'genre/genres'
  end

  get '/songs/new' do
    erb :'song/new'
  end

  post '/songs' do
    song = Song.new_from_params(params)
    redirect "/songs/#{song.to_param}"
  end

  get '/artists/:slug' do
    @artist = Artist.find_by_slug(params[:slug])
    erb :'artist/artist'
  end

  get '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])
    @embedcode = @song.youtube
    erb :'song/song'
  end

  get '/genres/:slug' do
    @genre = Genre.find_by_slug(params[:slug])
    erb :'genre/genre'
  end

end