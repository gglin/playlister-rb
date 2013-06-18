class Genre

  attr_accessor :name
  attr_reader :songs, :artists
  All = []

  def initialize
    All << self
    @songs = []
    @artists = []
  end

  def self.reset_genres
    All.clear
  end

  def self.all
    All
  end

end


# rap = Genre.new
# jayz = "Jay-Z"
# rap.artists << jayz