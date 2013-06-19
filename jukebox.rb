require_relative 'parser.rb'
require_relative 'lib/artist.rb'
require_relative 'lib/song.rb'
require_relative 'lib/genre.rb'
 

class Jukebox

  VALID_COMMANDS = %w{artist genre stop help exit}
 
  attr_accessor :songs, :artists, :genres
  attr_reader   :power, :now_playing, :command
 
  def initialize(songs)
    # sort songs
    @songs = songs
    @songs.sort! {|song1, song2| song1.name <=> song2.name}
    
    # from the inputted songs, create a genres array
    @genres = []
    @songs.each {|song| @genres << song.genre if !@genres.include? song.genre}
    @genres.sort! do |genre1, genre2| 
      if genre1.songs_count != genre2.songs_count
        genre2.songs_count <=> genre1.songs_count
      else
        genre1.name <=> genre2.name
      end
    end

    # from the inputted songs, create an artists array
    @artists = []
    @songs.each {|song| @artists << song.artist if !@artists.include? song.artist}
    @artists.sort! {|artist1, artist2| artist1.name <=> artist2.name}

    # by default the power is off
    @power = false

    puts "\nNew jukebox created with #{@songs.size} songs, #{@artists.size} artists, and #{@genres.size} genres"
  end


  def name_list(object_array) # returns an array of names (string), given an array of objects
    object_array.collect{|object| object.name.downcase}
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
      browse_artists
      prompt_artist(@artists)
    when "genre"
      browse_genres
      prompt_genre(@genres)
    when "stop" then stop
    when "help" then help
    when "exit" then exit
    else
      puts "\n>> Command not recognized. Available commands are 'Artist', 'Genre', 'Stop', Help', and 'Exit'"
      # puts ">>   You can also type in the name of a specific artist or genre to view available songs"
    end
  end


  def browse_artists
    puts "\n  There are #{@artists.size} artists:\n"
    @artists.each_with_index do |artist, index|
      puts "\t#{index+1}. #{print_artist(artist)}"
    end

    puts "\n>> Select an artist (enter either the artist name or number):"
  end


  def browse_genres
    puts "\n  There are #{@genres.size} genres:\n"
    @genres.each_with_index do |genre, index|
      puts "\t#{index+1}. #{print_genre(genre)}"
    end

    puts "\n>> Select a genre (enter either the genre name or number):"
  end


  def prompt_category(categories)
    @command = gets.chomp.strip.downcase
    valid_command_entered = VALID_COMMANDS.include?(@command)
 
    until name_list(categories).include?(@command) || @command.to_i.between?(1,categories.size) || valid_command_entered
      puts "\n>> Error: please enter a valid category or number"
      @command = gets.chomp.strip.downcase
      valid_command_entered = VALID_COMMANDS.include?(@command)
    end

    if valid_command_entered
      process_input
    else
      if @command.to_i.between?(1,categories.size)
        category = categories[@command.to_i - 1]
      else
        category = categories.detect{|category| category.name.downcase == @command}
      end
      yield category
    end
  end


  def prompt_artist(artists)
    prompt_category(artists) do |artist|
      puts "\n #{print_artist(artist)}:"
      artist.songs.each_with_index do |song, index|
        puts "\t#{index+1}. #{print_song(song)}"
      end
      puts "\n>> Select a song to play (enter either the song name or number):"
      prompt_song(artist.songs)
    end
  end


  def prompt_song(songs)
    prompt_category(songs) do |song|
      play_song(song)
    end
  end


  def prompt_genre(genres)
    prompt_category(genres) do |genre|
      puts "\n #{print_genre(genre)}:"
      genre.songs.each_with_index do |song, index|
        puts "\t#{index+1}. #{song.artist.name} - #{print_song(song)}"
      end
      puts "\n>> Select a song to play (enter either the song name or number):"
      prompt_song(genre.songs)
    end
  end


  def play_song(song)
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


  def prompt_new_song
    puts "\n>> Type 'Artist' or 'Genre' to browse and pick a new song. Type 'Exit' to take a break."
  end


  def print_artist(artist)
    song_word = artist.songs_count == 1 ? "Song" : "Songs"
    "#{artist.name} - #{artist.songs_count} #{song_word}"
  end


  def print_song(song)
    "#{song.name} [#{song.genre.name}]"
  end


  def print_genre(genre)
    song_word   = genre.songs_count   == 1 ? "Song" : "Songs"
    artist_word = genre.artists_count == 1 ? "Artist" : "Artists"
    "#{genre.name}: #{genre.songs_count} #{song_word}, #{genre.artists_count} #{artist_word}"
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

cli.start

