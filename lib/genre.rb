class Genre

  attr_accessor :name
  attr_reader :songs, :artists
  @@all = []

  def initialize
    @@all << self
    @songs = []
    @artists = []
  end

  def self.reset_genres
    @@all = []
  end

  def self.all
    @@all
  end

end


# rap = Genre.new
# jayz = "Jay-Z"
# rap.artists << jayz