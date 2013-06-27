
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

  get '/artists/' do
    @artists = Artist.all
    erb :'artist/artists'
  end

  get '/songs/' do
    @songs = Song.all
    erb :'song/songs'
  end

  get '/genres/' do
    @genres = Genre.all
    erb :'genre/genres'
  end

  get '/artists/:id' do
    @artist = Artist.find_by_id(params[:id])
    erb :'artist/artist'
  end

  get '/songs/:id' do
    @song = Song.find_by_id(params[:id])
    id = YoutubeSearch.search("#{@song.artist.name} #{@song.name}").first["video_id"]
    url = "http://www.youtube.com/watch?v=#{id}"
    @embedcode = OEmbed::Providers::Youtube.get(url).html
    erb :'song/song'
  end

  get '/genres/:id' do
    @genre = Genre.find_by_id(params[:id])
    erb :'genre/genre'
  end

end