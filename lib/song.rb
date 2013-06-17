# require_relative 'genre.rb'

class Song

  attr_reader :genre

  def genre=(genre)
    genre.songs << self
    @genre = genre
  end

end

# in_da_club = Song.new
# in_da_club.genre=( Genre("rap") )
# object.method(argument)

# Genre("rap").songs << in_da_club