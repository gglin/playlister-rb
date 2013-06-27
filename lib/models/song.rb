
# require 'genre'
require_relative '../concerns/memorable'
require_relative '../concerns/findable'
require_relative '../concerns/listable'
require_relative '../concerns/sluggable'

class Song

  attr_accessor :id, :name, :artist, :genre

  extend  Memorable::ClassMethods
  include Memorable::InstanceMethods

  extend  Sluggable::ClassMethods
  include Sluggable::InstanceMethods

  extend  Listable
  extend  Findable

  extend  Prettifiable::ClassMethods
  include Prettifiable::InstanceMethods
 
  def self.reset_songs
    reset_all
  end
  reset_songs

  def self.action(index)
    self.all[index-1].play
  end

  def play
    puts "Playing #{self.title}, enjoy!"
  end

  def initialize(name = nil)
    super
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

  def url
    "#{self.name}.html"
  end

  def title
    "#{self.artist.name} - #{self.name} [#{self.genre.name}]"
  end

  def print(width = nil, include_artist = false, artist_width = nil, include_genre = true)
    artist_word = include_artist ? "#{spacer(self.artist.name,artist_width)} - " : ""
    genre_word  = include_genre  ? "[#{self.genre.name}]" : ""
    artist_word + "#{spacer(self.name,width)}" + genre_word
  end

  def print_with_links(width = nil, include_artist = false, artist_width = nil, include_genre = true)
    artist_word = include_artist ? "<a href=\"/artists/#{self.artist.id}\">#{spacer(self.artist.name, artist_width)}</a> - " : ""
    genre_word  = include_genre  ? "<a href=\"/genres/#{self.genre.id}\">[#{self.genre.name}]</a>" : ""
    artist_word + "<a href=\"/songs/#{self.id}\">#{spacer(self.name,width)}</a>" + genre_word
  end

end

# in_da_club = Song.new
# in_da_club.genre=( Genre("rap") )
# object.method(argument)

# Genre("rap").songs << in_da_club