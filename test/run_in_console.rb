class LibraryParser

  def initialize(dir_name = '.')
    @dir_name = dir_name
  end

  def call(dir_name)
    artist_list = []
    song_list = []
    genre_list = []

    files = [
"../../data/A$AP Rocky - Peso [dance].mp3", 
"../../data/Action Bronson - Larry Csonka [indie].mp3", 
"../../data/Adele - Rolling In the Deep [folk].mp3", 
"../../data/Adele - Someone Like You [country].mp3", 
"../../data/AraabMuzik - Streetz Tonight [folk].mp3", 
"../../data/Atlas Sound - Mona Lisa [pop].mp3", 
"../../data/Azealia Banks - 212 [hip-hop].mp3", 
"../../data/Battles - Ice Cream (Feat. Matias Aguayo) [rock].mp3", 
"../../data/Beyonce - 1+1 [house].mp3", 
"../../data/Beyonce - Countdown [pop].mp3", 
"../../data/Bill Callahan - Riding for the Feeling [indie].mp3", 
"../../data/Blawan - Getting Me Down [hip-hop].mp3", 
"../../data/Bon Iver - Holocene [house].mp3", 
"../../data/Bon Iver - Perth [pop].mp3", 
"../../data/Britney Spears - Till the World Ends (The Femme Fatale Remix) (feat.Kesha & Nicki Minaj) [pop].mp3", 
"../../data/Burial - Street Halo [rock].mp3", 
"../../data/Cass McCombs - County Line [country].mp3", 
"../../data/Charli XCX - Stay Away [rock].mp3", 
"../../data/Cities Aviv - Coastin' [dance].mp3", 
"../../data/Clams Casino - Motivation [hip-hop].mp3", 
"../../data/Cold Cave - The Great Pan is Dead [house].mp3", 
"../../data/Cults - Abducted [rock].mp3", 
"../../data/Cut Copy - Need You Now [rap].mp3", 
"../../data/Danny Brown - Monopoly [electro].mp3", 
"../../data/Destroyer - Chinatown [country].mp3", 
"../../data/DJ Khaled - I'm On One (ft. Drake, Rick Ross & Lil Wayne) [pop].mp3", 
"../../data/DJ Quik - Killer Dope [country].mp3", 
"../../data/Drake - Buried Alive (Interlude) (Feat. Kendrick Lamar) [dance].mp3", 
"../../data/Drake - Headlines [folk].mp3", 
"../../data/Dum Dum Girls - Wrong Feels Right [folk].mp3", 
"../../data/Eleanor Friedberger - My Mistakes [country].mp3", 
"../../data/EMA - California [hip-hop].mp3", 
"../../data/Fever Ray - The Wolf [electro].mp3", 
"../../data/Fleet Foxes - Grown Ocean [folk].mp3", 
"../../data/Frank Ocean - Novacane [dance].mp3", 
"../../data/Fucked Up - Queen of Hearts [folk].mp3", 
"../../data/Gang Gang Dance - Glass Jar [electro].mp3", 
"../../data/Girls - Vomit [house].mp3", 
"../../data/Grimes - Vanessa [rock].mp3", 
"../../data/Holy Ghost - Jam For Jerry [house].mp3", 
"../../data/Iceage - You're Blessed [rap].mp3", 
"../../data/Ill Blu - Meltdown [house].mp3", 
"../../data/Jacques Greene - Another Girl [rock].mp3", 
"../../data/Jai Paul - BTSTU [electro].mp3", 
"../../data/James Blake - The Wilhelm Scream [electro].mp3", 
"../../data/Jamie xx & Gill Scott-Heron - I'll Take Care Of You [pop].mp3", 
"../../data/Jamie xx - Far Nearer [rock].mp3", 
"../../data/Jay-Z & Kanye West - Niggas In Paris [dance].mp3", 
"../../data/Jay-Z & Kanye West - Otis (ft. Otis Redding) [folk].mp3", 
"../../data/John Maus - Believer [indie].mp3", 
"../../data/Julianna Barwick - Prizewinning [pop].mp3", 
"../../data/Junior Boys - Banana Ripple [indie].mp3", 
"../../data/Katy B - Broken Record [pop].mp3", 
"../../data/Kelly Rowland - Motivation (ft. Lil Wayne) [house].mp3", 
"../../data/Kendrick Lamar - A.D.H.D [rap].mp3", 
"../../data/Kreayshawn - Gucci Gucci [house].mp3", 
"../../data/Kurt Vile - Jesus Fever [rock].mp3", 
"../../data/Lana Del Rey - Video Games [hip-hop].mp3", 
"../../data/Liturgy - Generation [rap].mp3", 
"../../data/M83 - Intro (ft. Zola Jesus) [indie].mp3", 
"../../data/M83 - Midnight City [house].mp3", 
"../../data/Mr. Muthafuckin eXquire - Huzzah (Remix ft. Despot, Das Racist, Danny Brown and El-P) [rock].mp3", 
"../../data/Neon Indian - Polish Girl [rock].mp3", 
"../../data/Nicholas Jaar - Space Is Only Noise If You Can See [house].mp3", 
"../../data/Nicki Minaj - Super Bass [rap].mp3", 
"../../data/Oneohtrix Point Never - Replica [country].mp3", 
"../../data/Panda Bear - Last Night At The Jetty [indie].mp3", 
"../../data/Peaking Lights - All the Sun That Shines [indie].mp3", 
"../../data/PJ Harvey - The Words That Maketh Murder [folk].mp3", 
"../../data/Purity Ring - Ungirthed [rap].mp3", 
"../../data/Real Estate - Green Aisles [country].mp3", 
"../../data/Real Estate - It's Real [hip-hop].mp3", 
"../../data/Rihanna - We Found Love (ft. Calvin Harris) [indie].mp3", 
"../../data/Sandro Perri - Changes [pop].mp3", 
"../../data/SBTRKT - Wildfire [country].mp3", 
"../../data/Sepalcure - Pencil Pimp [rap].mp3", 
"../../data/Shabazz Palaces - Swerve... The Reeping of All That Is Worthwhile (Noir Not Withstanding) [indie].mp3", 
"../../data/Soulja Boy - Zan With That Lean [hip-hop].mp3", 
"../../data/St. Vincent - Cruel [electro].mp3", 
"../../data/The Field - Then It's White [rock].mp3", 
"../../data/The Joy Formidable - Whirring [rock].mp3", 
"../../data/The Men - Bataille [hip-hop].mp3", 
"../../data/The Rapture - How Deep Is Your Love [folk].mp3", 
"../../data/The Weeknd - House of Balloons [hip-hop].mp3", 
"../../data/The Weeknd - The Morning [dance].mp3", 
"../../data/Thee Oh Sees - The Dream [pop].mp3", 
"../../data/Thundercat - For Love I Come [dance].mp3", 
"../../data/Tiger & Woods - Gin Nation [hip-hop].mp3", 
"../../data/Todd Terje - Snooze 4 Love [hip-hop].mp3", 
"../../data/Toro Y Moi - New Beat [dance].mp3", 
"../../data/tUnE-yArDs - Bizness [dance].mp3", 
"../../data/tUnE-yArDs - Powa [country].mp3", 
"../../data/Ty Segall - Goodbye Bread [dance].mp3", 
"../../data/Tyler the Creator - Yonkers [folk].mp3", 
"../../data/Unknown Mortal Orchestra - Ffunny Ffrends [hip-hop].mp3", 
"../../data/Washed Out - Amor Fati [folk].mp3", 
"../../data/Wild Flag - Romance [hip-hop].mp3", 
"../../data/Yuck - Get Away [indie].mp3", 
"../../data/Zoo Kid - Out Getting Ribs [hip-hop].mp3", 
    ]

    files.each do |filename|
      # Parse mp3 filenames
      artist_name = filename.split("#{dir_name}/").last.split(" - ").first
      song_name   = filename.split(" - ").last.split(" [").first
      genre_name  = filename.split(" - ").last.split(" [").last.split("].").first

      # Instantiate new artist, song, and genre if they don't exist
      artist = add_object_to_class(Artist, artist_name, artist_list)
      song   = add_object_to_class(Song,   song_name,   song_list)
      genre  = add_object_to_class(Genre,  genre_name,  genre_list)

      # Assign relationships
      song.genre = genre
      artist.add_song(song)
    end

    [song_list, artist_list, genre_list]
  end


  # Either instantiate a new object of class "klass" & name "name"
  #   or find an object with that "name" if it already exists in the "list"
  def add_object_to_class(klass, name, list = [])
    if list.include? name
      return klass.all.select{|element| element.name == name}.first
    else
      list << name
      return klass.new(name)
    end
  end

end

module Findable

  def find_by_name(name)
    all.detect{|a| a.name == name}
  end

  def find_by_id(id)
    all[id.to_i-1]
  end

  def find_or_create_by_name(name)
    self.find_by_name(name) || self.new.tap{|g| g.name = name}
  end
  
end

module Listable

  def list
    all.each_with_index do |o, index|
      puts "#{index+1}. #{o.name}"
    end
  end
  
end


module Memorable
  module InstanceMethods

    def initialize(name = nil)
      @id = self.class.count + 1
      self.class.all << self
      @name = name
    end
    
  end

  module ClassMethods

    def reset_all
      @all = []
    end

    def count
      @all.size
    end

    def all
      @all ||= []
    end

  end
end





class Song

  attr_accessor :id, :name, :artist, :genre

  extend  Memorable::ClassMethods
  include Memorable::InstanceMethods

  extend  Listable
  extend  Findable
 
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

  def title
    "#{self.artist.name} - #{self.name} [#{self.genre.name}]"
  end

  def print(width = nil, include_artist = false, artist_width = nil, include_genre = true)
    artist_word = include_artist ? "#{spacer(self.artist.name,artist_width)} - " : ""
    genre_word  = include_genre  ? "[#{self.genre.name}]" : ""
    artist_word + "#{spacer(self.name,width)}" + genre_word
  end

end




class Genre

  attr_accessor :id, :name, :songs, :artists

  extend  Memorable::ClassMethods
  include Memorable::InstanceMethods

  extend  Listable
  extend  Findable

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

  def print(width = nil, *args)
    song_word   = self.songs_count   == 1 ? "Song" : "Songs"
    artist_word = self.artists_count == 1 ? "Artist" : "Artists"
    "#{spacer(self.name+':',width)} #{self.artists_count} #{artist_word}, #{self.songs_count} #{song_word}"
  end

end


class Artist

  attr_accessor :id, :name, :songs

  extend  Memorable::ClassMethods
  include Memorable::InstanceMethods

  extend  Listable
  extend  Findable

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

end






# reopen Array class
class Array

  # Enumerable.grep(pattern) only matches when pattern === element
  # Enhance functionality so that it also matches when element =~ pattern
  #    /abc/ === "abc" returns true
  #    However, "abc" === /abc/ returns false
  #    /abc/ =~ "abc"  &  "abc" =~ /abc/ will both find a match
  def grep2(pattern)
    self.select do |element|
      if pattern.class == element.class
        element == pattern
      else
        element =~ pattern
      end
    end
  end

  # returns an array of downcased names (string), given an array of objects
  def objects_to_names 
    self.collect{ |object| object.name.downcase }
  end

  # returns (filters) an array of objects from the original objects list, given an array of downcased names (strings)
  def names_to_objects(objects) 
    self.collect do |name|
      objects.detect{ |object| object.name.downcase == name } 
      # doesn't work properly if there are two of the same name, as this will always return the first result
    end
  end

  # returns an array of new objects, based on each element of the original array having that new object as a method name
  def objects_to_objects(new_object)
    self.collect{ |object| object.send(new_object) }
  end

end



class Jukebox

  VALID_COMMANDS = [/^(artist|song|genre)s?$/, /^(artist|song|genre)\s+\S+/, "stop", "help", "exit"]
 
  attr_reader   :songs, :artists, :genres
  attr_reader   :power, :now_playing
 
  def initialize(songs = [])
    @songs = songs
    setup
    @power = false
    puts "\nNew jukebox created with #{print_contents}"
  end


  def add_songs(songs)
    # input must be an array of songs
    songs.each {|song| @songs << song}
    setup
    puts "\nJukebox updated to have #{print_contents}"
  end


  def setup
    sort_by!(@songs)

    # this currently has to refresh the entire list of @genres and @artists from @songs
    # a faster way would be only to update this list based on added songs
    @genres = set_categories(@songs, :genre)
    sort_by!(@genres, :desc, :songs_count)

    @artists = set_categories(@songs, :artist)
    sort_by!(@artists)
  end


  def set_categories(songs, category)
    categories = []
    songs.each {|song| categories << song.send(category) if !categories.include? song.send(category)}
    categories
  end


  def sort_by!(categories, order = :asc, category = :name)
    categories.sort! do |cat1, cat2| 
      if    cat1.send(category) !=  cat2.send(category) && order == :desc
            cat2.send(category) <=> cat1.send(category)
      elsif cat1.send(category) !=  cat2.send(category)
            cat1.send(category) <=> cat2.send(category)
      else
            cat1.name <=> cat2.name
      end
    end
  end


  def start
    @power = true 
    welcome
    prompt_loop
  end


  def prompt_loop
    while on?
      @command = gets.chomp.strip.downcase
      process_input
    end
  end


  def on?
    @power
  end


  def process_input
    case @command
    when /^(artist|song|genre)s?$/
      @command << "s" if @command[-1] != "s"
      browse_categories(self.send(@command.to_sym))
      prompt_categories(self.send(@command.to_sym))
    when /^(artist|song|genre)\s+\S+/
      category   = @command.split(/\s+/)[0]
      categories = (category + "s").to_sym
      @command   = @command.sub(/^#{category}\s+/,"")
      process_by_command(self.send(categories))
    when "stop" then stop
    when "help" then help
    when "exit" then exit
    else
      puts "\n>> Command not recognized. Available commands are 'Artist', 'Song', 'Genre', 'Stop', Help', and 'Exit'"
      puts ">> You can also type in the name or # of a specific artist, song, or genre, e.g. 'Artist 1' or 'Genre Rap'"
    end
  end


  # find all valid objects of the given category based on pattern matching the command
  def process_by_command(categories)
    filtered_category_names = filter_by_command(categories)

    if @command.to_i.between?(1,categories.size)      # number entered
      category = categories[@command.to_i - 1]
      prompt_songs_from_category(category)
    elsif filtered_category_names.size == 1           # a single string match found 
      @command = filtered_category_names[0]
      category = categories.detect{|category| category.name.downcase == @command}
      prompt_songs_from_category(category)
    elsif filtered_category_names.size > 1            # multiple matches found - filter
      new_categories = filtered_category_names.names_to_objects(categories)
      browse_categories(new_categories, @command)
      prompt_categories(new_categories)
    else 
      prompt_error(categories)
      prompt_loop
    end
  end


  def browse_categories(categories, string_match = nil)
    starting_filter = string_match.nil? ? "" : " starting with '#{string_match}'"

    category_name = categories[0].class.to_s.downcase
    include_artist   = category_name == "song" ? true : false
    artist_max_width = category_name == "song" ? longest_name_length( categories.objects_to_objects(:artist) ) : nil

    puts "\n  There are #{categories.size} #{category_name}s#{starting_filter}:\n"
    categories.each_with_index do |category, index|
      puts "\t#{index+1}.    "[0,5] + " #{print_category(category, longest_name_length(categories), include_artist, artist_max_width)}"
    end

    puts "\n>> Select a #{category_name} (enter either the #{category_name} name or number):"
  end


  def filter_by_command(categories)
    @valid_command_entered = false
    @valid_command_entered = !VALID_COMMANDS.grep2(@command).empty?
    categories.objects_to_names.grep(/^#{@command}/)
  end


  def prompt(categories)
    # initial user prompt
    @command = gets.chomp.strip.downcase
    filtered_category_names = filter_by_command(categories)
    
    # loop until an understood command is entered 
    until !filtered_category_names.empty? || @command.to_i.between?(1,categories.size) || @valid_command_entered
      prompt_error(categories)
      @command = gets.chomp.strip.downcase
      filtered_category_names = filter_by_command(categories)
    end

    # process the understood command
    # block (yield) executes only when an unambiguous match is found
    if @valid_command_entered                         # valid command entered - go to main prompt
      process_input
    elsif @command.to_i.between?(1,categories.size)   # number entered
      category = categories[@command.to_i - 1]
      yield category  
    elsif filtered_category_names.size == 1           # a single string match found 
      @command = filtered_category_names[0]
      category = categories.detect{|category| category.name.downcase == @command}
      yield category
    else                                              # multiple matches found - filter
      new_categories = filtered_category_names.names_to_objects(categories)
      browse_categories(new_categories, @command)
      prompt_categories(new_categories)
    end
  end


  def prompt_categories(categories)
    category_name = categories[0].class.to_s.downcase
    self.send("prompt_#{category_name}s".to_sym, categories)   
  end


  def prompt_artists(artists)
    prompt(artists) do |artist|
      prompt_songs_from_category(artist)
    end
  end


  def prompt_songs(songs)
    prompt(songs) do |song|
      play(song)
    end
  end


  def prompt_genres(genres)
    prompt(genres) do |genre|
      prompt_songs_from_category(genre)
    end
  end


  def prompt_songs_from_category(category)
    if category.class.to_s == "Song"
      play(category)
    else
      puts "\n #{print_category(category)}:"
      category.songs.each_with_index do |song, index|
        if    category.class.to_s == "Genre"
          puts "\t#{index+1}.    "[0,5] + " #{spacer(song.artist.name, longest_name_length(category.artists))} - #{song.name}"
        elsif category.class.to_s == "Artist"
          puts "\t#{index+1}.    "[0,5] + " #{print_song(song)}"
        else
          puts "ERROR - Category not recognized!"
        end
      end
      puts "\n>> Select a song to play (enter either the song name or number):"
      prompt_songs(category.songs)
    end
  end


  def play(song)
    @now_playing = song
    show_song_playing
    prompt_new_song
  end


  def stop
    if @now_playing
      puts "\n  Stopped playing '#{@now_playing.artist.name} - #{print_song(@now_playing)}'"
      @now_playing = nil
    else
      puts "\n  There is no song playing!"
    end
    prompt_new_song
  end


  def help
    show_song_playing
    puts "\n>> HELP SCREEN"
    puts ">> Type 'Artist(s)', 'Genre(s)', or 'Song(s)' to browse by that category"
    puts "   - Within that category, you can type part of the name to filter results"
    puts "   - Within that category, you can also type its number to select a specific artist, song, or genre"
    puts ">> Type '<Artist, Song, or Genre> <number or part of name>' to choose a specific artist, song, or genre. e.g.:"
    puts "   - 'Artist 1' will display the first artist in the library"
    puts "   - 'Song the' will display all songs starting with 'the' if there is >1 such song"
    puts "   - 'Song ruby' will play the song 'Ruby' if it is the only song to start with 'ruby'"
    puts ">> Type 'Stop' to stop playing the current song" if @now_playing
    puts ">> Type 'Exit' to leave the program"
  end


  def exit
    puts "\n  Thanks for playing our CLI Jukebox! Have a great day."
    @power = false
  end


  def show_song_playing
    if @now_playing
      puts "\n  Now playing: #{@now_playing.artist.name} - #{print_song(@now_playing)}"
    else
      puts "\n  No song currently playing."
    end
  end


  private


  def prompt_new_song
    puts "\n>> Would you like to choose a new song?"
    puts ">> Type '<Artist, Song, or Genre> <number or part of name>' to choose a specific artist, song, or genre"
    puts ">> Type 'Artist(s)', 'Song(s)', or 'Genre(s)' to browse by category"
    puts ">> Type 'Stop' to stop playing the current song" if @now_playing
  end


  def prompt_error(categories)
    puts "\n>> Error: please enter a valid #{categories[0].class.to_s.downcase} name or number"
  end


  def spacer(name, width = nil)
    width = name.length + 1 if width.nil?
    "#{name}                                                                                   "[0,width]
  end


  def print_category(category, width = nil, include_artist = false, artist_width = nil)
    category_name = category.class.to_s.downcase
    self.send("print_#{category_name}".to_sym, category, width, include_artist, artist_width)
  end


  def print_artist(artist, width = nil, *args)
    song_word = artist.songs_count == 1 ? "Song" : "Songs"
    "#{spacer(artist.name,width)} - #{artist.songs_count} #{song_word}"
  end


  def print_song(song, width = nil, include_artist = false, artist_width = nil)
    artist_word = include_artist ? "#{spacer(song.artist.name,artist_width)} - " : ""
    artist_word + "#{spacer(song.name,width)} [#{song.genre.name}]"
  end


  def print_genre(genre, width = nil, *args)
    song_word   = genre.songs_count   == 1 ? "Song" : "Songs"
    artist_word = genre.artists_count == 1 ? "Artist" : "Artists"
    "#{spacer(genre.name+':',width)} #{genre.artists_count} #{artist_word}, #{genre.songs_count} #{song_word}"
  end


  def print_contents
    "#{@songs.size} songs, #{@artists.size} artists, & #{@genres.size} genres"
  end


  def longest_name_length(categories)
    max = 0
    categories.each do |category|
      max = category.name.length if category.name.length > max
    end
    max + 1
  end


  def welcome
    puts jukebox_ascii
    puts "\nWelcome to the CLI Jukebox!"
    puts ">> Type 'Help' for more info. Type 'Exit' to leave the program"
    puts ">> Would you like to browse by 'Artist', 'Song', or 'Genre'?"
    puts ">> You can also choose a specific artist, song, or genre, e.g. 'Artist 1' or 'Genre rap'"
  end
 

  def jukebox_ascii
    # from http://ascii.co.uk/art/jukebox
    %q{
                       _______                    
                  _.-'\       /'-._                  
              _.-'    _\ .-. /_    '-._                  
           .-'    _.-' |/.-.\| '-._    '-.                  
         .'    .-'    _||   ||_    '-.    '.                  
        /    .'    .-' ||___|| '-.    '.    \     
       /   .'   .-' _.-'-----'-._ '-.   '.   \      
      /   /   .' .-' ~       ~   '-. '.   \   \   
     /   /   / .' ~   *   ~     ~   '. \   \   \   
    /   /   /.'........    *  ~   *  ~'.\   \   \ 
    |  /   //:::::::::: ~   _____._____  \   \  |
    |  |  |/:::::::::::  * '-----------' \|  |  |
   .--.|__||_____________________________||__|.--.
  .'   '----. .-----------------------. .----'   '.
  '.________' |o|==|o|====:====|o|==|o| '________.'
  .'--------. |o|==|o|====:====|o|==|o| .--------'.
  '.________' |o|==|o|====:====|o|==|o| '________.'
  .'--------. |o|==|o|====:====|o|==|o| .--------'.
  '.________' |o|==|o|====:====|o|==|o| '________.'
    |  |  ||  ____ |:| | | | | |:| ____  ||  |  |
    |  |  || |    ||:| | | | | |:||    | ||  |  |
    |  |  || |____||: Wurlitzer :||____| ||  |  |
    |  |  ||  |   /|:| | | | | |:|\   |  ||  |  |
    |  |  ||  |_.` |:| | | | | |:| `._|  ||  |  |
    |  |  || .---.-'-'-'-'-'-'-'-'-.---. ||  |  |
    |  |  || |   |\  /\  / \  /\  /|   | ||  |  |
    |  |  || |   |~\/  \/ ~ \/  \/ |   | ||  |  |
    |  |  || |   | /\ ~/\ ~ /\ ~/\ |   | ||  |  |
    |  |  || |   |/  \/  \ /  \/ ~\|   | ||  |  |
    |  |  || |   |\~ /\~ / \~ /\  /|   | ||  |  |
    |  |  || |   | \/  \/ ~ \/  \/ |   | ||  |  |
    |  |  || |   | /\~ /\ ~ /\ ~/\ |   | ||  |  |
    |  |  || |===|/  \/  .-.  \/  \|===| ||  |  |
    |  |  || |   | ~ /\ ( * ) /\ ~ |   | ||  |  |
    |  |  || |    \ /  \/'-'\/  \ /    | ||  |  |
   /-._|__||  \    \ ~ /\ ~ /\~  /    /  ||__|_.-\
   |-._/__/|   \    './  .-.  \.'    /   |\__\_.-|
   | | |  ||    '._    '-| |-'    _.'    ||  | | |
   | | |  ||      '._    | |    _.'      ||  | | |
   | | |  ||         '-._| |_.-'         ||  | | |
   | | |  ||  __         | |             ||  | | |
   | | |  || O__O        |_|             ||  | | |
   '.|_|__||_____________________________||__|_|.'
    |  |   |-----------------------------|   |  |
    |  |   [_____________________________]   |  |
    |  |   |/  LGB                      \|   |  |
    '._|__.'                             '.__|_.'
    }
  end

end
 

# Parse the data folder and create a new local variable which holds all the songs
parser = LibraryParser.new
parser.call('../../data')

songs = Song.all


# start a jukebox CLI
cli = Jukebox.new
cli.add_songs(songs)
cli.start

