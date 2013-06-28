# require_relative 'song'
# require_relative 'genre'
require_relative '../concerns/memorable'
require_relative '../concerns/findable'
require_relative '../concerns/listable'
require_relative '../concerns/sluggable'

class Artist

  attr_accessor :id, :name, :songs

  extend  Memorable::ClassMethods
  include Memorable::InstanceMethods

  extend  Sluggable::ClassMethods
  include Sluggable::InstanceMethods

  extend  Listable
  extend  Findable

  extend  Prettifiable::ClassMethods
  include Prettifiable::InstanceMethods

  def self.reset_artists
    reset_all
  end
  reset_artists

  def self.action(index)
    self.all[index-1].list_songs
  end

  def list_songs
    Song.all.each_with_index do |s, index|
      puts "#{index+1}. #{s.name}" if s.genre == self
    end
  end

  def initialize(name = nil)
    super
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
    @songs.collect { |song| song.genre }.flatten.compact.uniq
  end

  def inspect
    "\"#{@name}\""
  end

  def to_s
    "#{@name} - #{@songs}"
  end

  def print(width = nil, *args)
    song_word = self.songs_count == 1 ? "Song" : "Songs"
    "#{spacer(self.name,width)} - #{self.songs_count} #{song_word}"
  end

  def add_songs(params)
    params.each do |song_hash|
      s = Song.new
      s.genre = Genre.find_or_create_by_name(song_hash[:genre].strip)
      s.name = song_hash[:name].strip
      self.add_song(s)
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