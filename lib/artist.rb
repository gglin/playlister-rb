# require_relative 'song.rb'
# require_relative 'genre.rb'

class Artist

  attr_accessor :name, :songs
  @@all = []

  def initialize
    @@all << self
    @songs = []
  end

  def self.reset_artists
    @@all = []
  end

  def self.count
    @@all.size
  end

  def self.all
    @@all
  end

  def songs_count
    @songs.size
  end

  def add_song(song)
    @songs << song

    # puts "Songs: #{songs.inspect}"
    # puts "Genre: #{genres.inspect}"

    genres.each do |genre|
      if !genre.nil?
        if !genre.artists.include? self 
          genre.artists << self
        end
      end
    end 
  end

  def genres # returns an array of genres
    return_genres = @songs.collect do |song|
                      song.genre
                    end
  end

end

  
# jayz = Artist.new
# empirestate = Song.new
# rap = Genre.new
# rap.name = "Rap"

# puts jayz.inspect
# puts empirestate.inspect
# puts rap.inspect

# empirestate.genre = rap
# puts empirestate.inspect

# jayz.add_song(empirestate)

# puts jayz.inspect
# puts jayz.songs.inspect
# puts jayz.genres.inspect