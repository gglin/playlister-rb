

require_relative '../concerns/memorable'
require_relative '../concerns/findable'
require_relative '../concerns/listable'
require_relative '../concerns/sluggable'

class Genre

  attr_accessor :id, :name, :songs, :artists

  extend  Memorable::ClassMethods
  include Memorable::InstanceMethods

  extend  Sluggable::ClassMethods
  include Sluggable::InstanceMethods

  extend  Listable
  extend  Findable

  extend  Prettifiable::ClassMethods
  include Prettifiable::InstanceMethods

  def self.reset_genres
    reset_all
  end
  reset_genres

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

  def url
    "#{@name.downcase.strip}.html"
  end

  def print(width = nil, *args)
    song_word   = self.songs_count   == 1 ? "Song" : "Songs"
    artist_word = self.artists_count == 1 ? "Artist" : "Artists"
    "#{spacer(self.name+':',width)} #{self.artists_count} #{artist_word}, #{self.songs_count} #{song_word}"
  end

end


# rap = Genre.new
# jayz = "Jay-Z"
# rap.artists << jayz