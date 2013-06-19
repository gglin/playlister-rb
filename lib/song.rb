# require_relative 'genre.rb'

class Song

  attr_accessor :name, :artist
  attr_reader :genre
  All = []

  def initialize(name = nil)
    All << self
    @name = name
  end

  def self.reset_songs
    All.clear
  end

  def self.count
    All.size
  end

  def self.all
    All
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