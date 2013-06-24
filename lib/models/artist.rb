# require_relative 'song'
# require_relative 'genre'
require_relative '../concerns/memorable'

class Artist

  extend Memorable
  attr_accessor :name, :songs
  All = []

  def self.all
    All
  end

  def self.reset_artists
    reset_all
  end
  reset_artists

  def initialize(name = nil)
    All << self
    @songs = []
    @name = name
  end

  def songs_count
    @songs.size
  end

  def add_song(song)
    
    # Add song into the artist's catalog
    @songs ||= []
    @songs << song

    # Assign this artist to that song
    song.artist = self

    # For each of this artist's genres, insert this artist into that genre
    genres.each do |genre|
      if !genre.nil?
        if !genre.artists.include? self 
          genre.artists << self
        end
      end
    end 

  end

  def genres # returns an array of genres
    @songs.collect { |song| song.genre }
  end

  def inspect
    "\"#{@name}\""
  end

  def to_s
    "#{@name} - #{@songs}"
  end

  def url
    "#{@name.downcase.strip}.html"
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