require_relative '../concerns/memorable'

class Genre

  extend Memorable
  attr_accessor :name
  attr_reader :songs, :artists
  All = []

  def self.all
    All
  end

  def self.reset_genres
    reset_all
  end
  reset_genres

  def initialize(name = nil)
    All << self
    @songs = []
    @artists = []
    @name = name
  end

  def songs_count
    @songs.size
  end

  def artists_count
    @artists.size
  end

  def inspect
    "\"#{@name}\""
  end

  def to_s
    "#{@name}"
  end

end


# rap = Genre.new
# jayz = "Jay-Z"
# rap.artists << jayz