
class PlaylisterApp < Sinatra::Base

  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    # @artists = Artist.all
    # @songs = Song.all
    # @genres = Genre.all
    erb :'index.html'
  end

  get '/artists' do
    @artists = Artist.all
    erb :'artist/artists'
  end

  get '/artists/new' do
    erb :'artist/new'
  end

  post '/artists' do
    empty_keys = params.values.include?("") || !params.values.grep(/^\s+$/).empty?

    empty_song_keys = false
    params[:songs].each do |song_hash|
      song_hash.values.each do |value|
        empty_song_keys = true if value == "" || value =~ /^\s+$/
      end
    end

    if empty_keys || empty_song_keys
      redirect "/artists/new"
    else
      artist = Artist.new
      artist.name = params[:artist_name].strip
      artist.add_songs(params[:songs])
      redirect "/artists/#{artist.to_param}"
    end
  end

  get '/genres' do
    @genres = Genre.all
    erb :'genre/genres'
  end

  get '/songs' do
    @songs = Song.all
    erb :'song/songs'
  end

  get '/songs/new' do
    erb :'song/new'
  end

  post '/songs' do
    empty_keys = params.values.include?("") || !params.values.grep(/^\s+$/).empty?
    if empty_keys
      redirect "/songs/new"
    else
      song = Song.new_from_params(params)
      redirect "/songs/#{song.to_param}"
    end
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