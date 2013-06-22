require_relative 'parser.rb'
require_relative 'lib/artist.rb'
require_relative 'lib/song.rb'
require_relative 'lib/genre.rb'
 

class Jukebox

  VALID_COMMANDS = %w{artist genre stop help exit}
 
  attr_accessor :songs, :artists, :genres
  attr_reader   :power, :now_playing, :command
 
  def initialize(songs)
    #from songs, get and sort artists and genres
    @songs = songs
    sort_by_name!(@songs)
    
    @genres = set_categories(@songs, :genre)
    sort_by_song_count!(@genres)

    @artists = set_categories(@songs, :artist)
    sort_by_name!(@artists)

    @power = false

    puts "\nNew jukebox created with #{@songs.size} songs, #{@artists.size} artists, and #{@genres.size} genres"
  end


  def set_categories(songs, category)
    categories = []
    songs.each {|song| categories << song.send(category) if !categories.include? song.send(category)}
    categories
  end


  def sort_by_song_count!(categories)
    categories.sort! do |cat1, cat2| 
      if cat1.songs_count != cat2.songs_count
        cat2.songs_count <=> cat1.songs_count
      else
        cat1.name <=> cat2.name
      end
    end
  end


  def sort_by_name!(categories)
    categories.sort! {|cat1, cat2| cat1.name <=> cat2.name}
  end


  def objects_to_names(object_array) # returns an array of downcased names (string), given an array of objects
    object_array.collect{|object| object.name.downcase}
  end


  def names_to_objects(name_array, categories) # returns (filters) an array of objects from the categories list, given an array of downcased names (strings)
    name_array.collect do |name|
      categories.detect{|object| object.name.downcase == name} 
      # doesn't work properly if there are two of the same name, as this will always return the first result
    end
  end


  def start
    @power = true 
    welcome

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
    when "artist"
      browse_artists(@artists)
      prompt_artists(@artists)
    when "genre"
      browse_genres(@genres)
      prompt_genres(@genres)
    when "stop" then stop
    when "help" then help
    when "exit" then exit
    else
      puts "\n>> Command not recognized. Available commands are 'Artist', 'Genre', 'Stop', Help', and 'Exit'"
      # puts ">>   You can also type in the name of a specific artist or genre to view available songs"
    end
  end


  def browse_artists(artists)
    puts "\n  There are #{artists.size} artists:\n"
    artists.each_with_index do |artist, index|
      puts "\t#{index+1}.    "[0,5] + " #{print_artist(artist, longest_name_length(artists))}"
    end

    puts "\n>> Select an artist (enter either the artist name or number):"
  end


  def browse_genres(genres)
    puts "\n  There are #{genres.size} genres:\n"
    genres.each_with_index do |genre, index|
      puts "\t#{index+1}.    "[0,5] + " #{print_genre(genre, longest_name_length(genres))}"
    end

    puts "\n>> Select a genre (enter either the genre name or number):"
  end


  def browse_songs(songs)
    puts "\n  There are #{songs.size} songs:\n"
    songs.each_with_index do |song, index|
      puts "\t#{index+1}.    "[0,5] + " #{print_song(song, longest_name_length(songs))}"
    end

    puts "\n>> Select a song (enter either the song name or number):"
  end


  def browse_categories(categories)
    case categories[0].class.to_s
    when "Artist"
      browse_artists(categories)
    when "Genre"
      browse_genres(categories)
    when "Song"
      browse_songs(categories)
    end
  end


  def prompt(categories)
    # block executes only when unambiguous match found

    # initial user prompt
    @command = gets.chomp.strip.downcase
    valid_command_entered = VALID_COMMANDS.include?(@command)
    filtered_category_names = objects_to_names(categories).grep(/^#{@command}/)
    
    # loop until an understood command is entered 
    until !filtered_category_names.empty? || @command.to_i.between?(1,categories.size) || valid_command_entered
      puts "\n>> Error: please enter a valid #{categories[0].class.to_s.downcase} name or number"
      @command = gets.chomp.strip.downcase
      valid_command_entered = VALID_COMMANDS.include?(@command)
      filtered_category_names = objects_to_names(categories).grep(/^#{@command}/)
    end

    # process the understood command
    if valid_command_entered                          # home valid command entered
      process_input
    elsif @command.to_i.between?(1,categories.size)   # number entered
      category = categories[@command.to_i - 1]
      yield category  
    elsif filtered_category_names.size == 1           # a single string match found 
      @command = filtered_category_names[0]
      category = categories.detect{|category| category.name.downcase == @command}
      yield category
    else                                              # multiple matches found - filter
      new_categories = names_to_objects(filtered_category_names, categories)
      browse_categories(new_categories)
      prompt_categories(new_categories)
    end
  end


  def prompt_categories(categories)
    case categories[0].class.to_s
    when "Artist"
      prompt_artists(categories)
    when "Genre"
      prompt_genres(categories)
    when "Song"
      prompt_songs(categories)
    end    
  end


  def prompt_artists(artists)
    prompt(artists) do |artist|
      puts "\n #{print_artist(artist)}:"
      artist.songs.each_with_index do |song, index|
        puts "\t#{index+1}.    "[0,5] + " #{print_song(song)}"
      end
      puts "\n>> Select a song to play (enter either the song name or number):"
      prompt_songs(artist.songs)
    end
  end


  def prompt_songs(songs)
    prompt(songs) do |song|
      play(song)
    end
  end


  def prompt_genres(genres)
    prompt(genres) do |genre|
      puts "\n #{print_genre(genre)}:"
      genre.songs.each_with_index do |song, index|
        puts "\t#{index+1}.    "[0,5] + " #{spacer(song.artist.name, longest_name_length(genre.artists))} - #{song.name}"
      end
      puts "\n>> Select a song to play (enter either the song name or number):"
      prompt_songs(genre.songs)
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
    puts ">> Type 'Artist' to display the list of artists (and then pick a song for that artist)" 
    puts ">> Type 'Genre' to display the list of genres (and then pick a song for that genre)"
    puts "   Within artists and genres, you can type part of a name to filter results"
    puts ">> Type 'Stop' to stop playing the current song" if @now_playing
    puts ">> Type 'Exit' to leave the program."
  end


  def exit
    puts "\n  Thanks for playing our CLI Jukebox! Have a great day."
    @power = false
  end


  private


  def show_song_playing
    if @now_playing
      puts "\n  Now playing: #{@now_playing.artist.name} - #{print_song(@now_playing)}"
    else
      puts "\n  No song currently playing."
    end
  end


  def prompt_new_song
    puts "\n>> Type 'Artist' or 'Genre' to browse and pick a new song. Type 'Exit' to take a break."
  end


  def spacer(name, width=nil)
    width = name.length + 1 if width.nil?
    "#{name}                                "[0,width]
  end


  def print_artist(artist, width=nil)
    song_word = artist.songs_count == 1 ? "Song" : "Songs"
    "#{spacer(artist.name,width)} - #{artist.songs_count} #{song_word}"
  end


  def print_song(song, width=nil)
    "#{spacer(song.name,width)} [#{song.genre.name}]"
  end


  def print_genre(genre, width=nil)
    song_word   = genre.songs_count   == 1 ? "Song" : "Songs"
    artist_word = genre.artists_count == 1 ? "Artist" : "Artists"
    "#{spacer(genre.name+':',width)} #{genre.artists_count} #{artist_word}, #{genre.songs_count} #{song_word}"
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
    puts ">> Would you like to browse by 'Artist' or 'Genre'?"
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

  def add_song(song)
    # this should replace the attr_accessor
    # so that whenever a song is added to the jukebox (@songs inserted into),
    # @genres and @artists is also updated
  end

end
 

# Parse the data folder and create a new local variable which holds all the songs
parser = Parser.new
parser.create_playlist

songs = Song.all


# start a jukebox CLI
cli = Jukebox.new(songs)

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

