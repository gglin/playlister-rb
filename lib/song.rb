# require_relative 'genre'
require_relative 'memorable'

class Song

  extend Memorable
  attr_accessor :name, :artist, :genre
  All = []

  def self.all
    All
  end

  def self.reset_songs
    reset_all
  end
  reset_songs

  def initialize(name = nil)
    All << self
    @name = name
  end

  def genre=(genre)
    genre.songs ||= []
    genre.songs << self
    @genre = genre
  end

  def inspect
    "\"#{@name}\""
  end

  def to_s
    "#{@artist.name} - #{@name} [#{@genre.name}]"
  end

end

# in_da_club = Song.new
# in_da_club.genre=( Genre("rap") )
# object.method(argument)

# Genre("rap").songs << in_da_club