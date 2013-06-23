require_relative 'parser.rb'
require_relative 'lib/artist.rb'
require_relative 'lib/song.rb'
require_relative 'lib/genre.rb'
 

# refactor: move some of code to another module
#           move process command if block in prompt() to own method
# add: sort while browsing
# known bug: when arrow keys entered while rexep matching, `filter_by_command': premature end of char-class:


# reopen Array class
class Array

  # Enumerable.grep(pattern) only matches when element === pattern
  # Enhance functionality so that it also matches when element =~ pattern
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

  # returns (filters) an array of objects from the categories list, given an array of downcased names (strings)
  def names_to_objects(categories) 
    self.collect do |name|
      categories.detect{|object| object.name.downcase == name} 
      # doesn't work properly if there are two of the same name, as this will always return the first result
    end
  end

  # returns an array of new objects, based on each element of the original array having that object as a method
  def objects_to_objects(category)
    self.collect{ |object| object.send(category) }
  end

end


class Jukebox

  VALID_COMMANDS = [/^artists?$/, /^artist\s+\S+/, /^genres?$/, /^songs?$/, "stop", "help", "exit"]
 
  attr_reader   :songs, :artists, :genres
  attr_reader   :power, :now_playing, :command
 
  def initialize(songs = [])
    @songs = songs
    setup
    @power = false
    puts "\nNew jukebox created with #{print_contents}"
  end


  def add_songs(songs)
    # add in an array of songs
    songs.each {|song| @songs << song}
    setup
    puts "\nJukebox updated to have #{print_contents}"
  end


  def setup
    sort_by!(@songs)

    # this currently has to refresh the entire list of genres and artists from @songs
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
    when /^artists?$/
      browse_categories(@artists)
      prompt_artists(@artists)
    when /^artist\s+\S+/
      @command = @command.split(/^artist\s+/)[1]
      process_by_command(@artists)
    when /^genres?$/
      browse_categories(@genres)
      prompt_genres(@genres)
    when /^songs?$/
      browse_categories(@songs)
      prompt_songs(@songs)
    when "stop" then stop
    when "help" then help
    when "exit" then exit
    else
      puts "\n>> Command not recognized. Available commands are 'Artist', 'Song', 'Genre', 'Stop', Help', and 'Exit'"
      # puts ">>   You can also type in the name of a specific artist or genre to view available songs"
    end
  end


  # find all valid objects of the given category based on pattern matching the command
  def process_by_command(categories)
    filtered_category_names = filter_by_command(categories)

    if    @command.to_i.between?(1,categories.size)   # number entered
      category = categories[@command.to_i - 1]
      ## prompt 
      p @command
      p category
    elsif filtered_category_names.size == 1           # a single string match found 
      @command = filtered_category_names[0]
      category = categories.detect{|category| category.name.downcase == @command}
      p @command
      p category
    elsif filtered_category_names.size > 1             # multiple matches found - filter
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


  def prompt(categories, skip_prompt = false)
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


  def prompt_categories(categories, skip_prompt = false)
    category_name = categories[0].class.to_s.downcase
    self.send("prompt_#{category_name}s".to_sym, categories, skip_prompt)   
  end


  def prompt_artists(artists, skip_prompt = false)
    prompt(artists, skip_prompt) do |artist|
      prompt_songs_from_category(artist) do |song, index|
        puts "\t#{index+1}.    "[0,5] + " #{print_song(song)}"
      end
    end
  end


  def prompt_songs(songs, skip_prompt = false)
    prompt(songs, skip_prompt) do |song|
      play(song)
    end
  end


  def prompt_genres(genres, skip_prompt = false)
    prompt(genres, skip_prompt) do |genre|
      prompt_songs_from_category(genre) do |song, index|
        puts "\t#{index+1}.    "[0,5] + " #{spacer(song.artist.name, longest_name_length(genre.artists))} - #{song.name}"
      end
    end
  end


  def prompt_songs_from_category(category)
    puts "\n #{print_category(category)}:"
    category.songs.each_with_index do |song, index|
      yield song, index
    end
    puts "\n>> Select a song to play (enter either the song name or number):"
    prompt_songs(category.songs)
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
    puts ">> Type 'Artist' to display the list of artists (& then pick a song for that artist)" 
    puts ">> Type 'Genre' to display the list of genres (& then pick a song of that genre)"
    puts ">> Type 'Song' to display the list of songs (& then pick a song)"
    puts "   - Within artists, songs, and genres, you can type part of the name to filter results"
    puts ">> Type 'Stop' to stop playing the current song" if @now_playing
    puts ">> Type 'Exit' to leave the program."
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
    puts "\n>> Type 'Artist', 'Song', or 'Genre' to browse by category. Type 'Exit' to take a break."
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
    puts ">> Type 'Help' for more info. Type 'Exit' to leave the program."
    puts ">> Would you like to browse by 'Artist', 'Song', or 'Genre'?"
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
parser = Parser.new
parser.create_playlist

songs = Song.all


# start a jukebox CLI
cli = Jukebox.new
cli.add_songs(songs)

# puts cli.songs
# puts
# puts cli.genres
# puts
# puts cli.artists
# 
# genres = cli.genres
# artists = cli.artists

# names_list = cli.objects_to_names(artists)
# p names_list
# puts "-------"
# objects_list = cli.names_to_objects(names_list[0..10], artists)
# p objects_list
cli.start

