class Genre

  attr_accessor :name
  attr_reader :songs, :artists
  All = []

  def initialize(name = nil)
    All << self
    @songs = []
    @artists = []
    @name = name
  end

  def self.reset_genres
    All.clear
  end

  def self.count
    All.size
  end

  def self.all
    All
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