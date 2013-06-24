require_relative 'artist'
require_relative 'song'
require_relative 'genre'


class LibraryParser

  def call(folder = '.')
    artist_list = []
    song_list = []
    genre_list = []

    files = Dir["#{folder}/*.mp3"]

    files.each do |filename|
      # Parse mp3 filenames
      artist_name = filename.split("#{folder}/").last.split(" - ").first
      song_name   = filename.split(" - ").last.split(" [").first
      genre_name  = filename.split(" - ").last.split(" [").last.split("].").first

      # Instantiate new artist, song, and genre if they don't exist
      artist = add_object_to_class(Artist, artist_name, artist_list)
      song   = add_object_to_class(Song,   song_name,   song_list)
      genre  = add_object_to_class(Genre,  genre_name,  genre_list)

      # Assign relationships
      song.genre = genre
      artist.add_song(song)
    end

    [song_list, artist_list, genre_list]
  end


  # Either instantiate a new object of class "klass" & name "name"
  #   or find an object with that "name" if it already exists in the "list"
  def add_object_to_class(klass, name, list = [])
    if list.include? name
      return klass.all.select{|element| element.name == name}.first
    else
      list << name
      return klass.new(name)
    end
  end

end

## TEST OUTPUTS

# parser = Parser.new
# playlist = parser.create_playlist
# p playlist

# check to see if array of objects successfully created
#   also checks that songs have one artist & genre and artists have songs
# [Artist, Song, Genre].each do |klass|
#   puts "\n\n"
#   puts "There are #{klass.all.size} #{klass}s:"
#   puts
#   puts klass.all
# end

# # check that artists have genres
# puts "\n\nArtist's genres:\n"
# Artist.all.each do |artist|
#   puts "#{artist.inspect} - *#{artist.genres}*"
# end

# # check that genres have artists
# puts "\n\nGenre's artists:\n"
# Genre.all.each do |genre|
#   puts "#{genre.inspect} - *#{genre.artists}*"
# end

# # check that genres have songs
# puts "\n\nGenre's songs:\n"
# Genre.all.each do |genre|
#   puts "#{genre.inspect} - *#{genre.songs}*"
# end

