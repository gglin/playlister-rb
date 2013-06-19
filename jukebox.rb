require_relative 'parser.rb'
require_relative 'lib/artist.rb'
require_relative 'lib/song.rb'
require_relative 'lib/genre.rb'
 

class Jukebox

  VALID_COMMANDS = %w{artist genre list play stop help exit}
 
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

    # get list of artist, song, and genre names
    @song_list   = @songs.collect{|song| song.name}
    @artist_list = @artists.collect{|artist| artist.name}
    @genre_list  = @genres.collect{|genre| genre.name}

    # by default the power is off
    @power = false

    puts @songs.size
    puts @genres.size
    puts @artists.size
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
      prompt_artist
    when "genre" then browse_genres
    when "stop" then stop
    when "help" then help
    when "exit" then exit
    else
      puts "\n>> Command not recognized. Available commands are 'Artist', 'Genre', 'Stop', Help', and 'Exit'"
      puts ">>   You can also type in the name of a specific artist or genre to view available songs"
    end
  end


  def browse_artists
    puts "\nThere are #{@artists.size} artists:\n"
    @artists.each_with_index do |artist, index|
      puts "\t#{index+1}. #{print_artist(artist)}"
    end

    puts "\n>> Select an artist:"
  end





  def prompt_artist
    @command = gets.chomp.strip
    valid_command_entered = VALID_COMMANDS.include?(@command.downcase)
 
    until @artist_list.include?(@command) || valid_command_entered
      puts "\n>> Error: please enter a valid artist (punctuation and case matter!)"
      @command = gets.chomp.strip
      valid_command_entered = VALID_COMMANDS.include?(@command.downcase)
    end

    if valid_command_entered
      @command = @command.downcase
      process_input
    else
      artist = @artists.select{|artist| artist.name == @command}.first
      puts "\n#{print_artist(artist)}:"
      artist.songs.each_with_index do |song, index|
        puts "\t#{index+1}. #{print_song(song)}"
      end
    end
  end


  def browse_genres
    puts "\nThere are #{@genres.size} genres:\n"
    @genres.each_with_index do |genre, index|
      puts "\t#{index+1}. #{print_genre(genre)}"
    end

    puts "\n>> Select a genre:"
  end
 

  def list
    show_song_playing

    @songs.each_with_index do |song, index|
      puts "Song #{index+1}: #{song}"
    end
    puts "\n>> Would you like to play a song in this list? if so, type 'play'"
  end
 

  def play
    index = @command.split.last.to_i

    puts "\n>> Enter song number:"
    @command = gets.chomp.downcase.strip
    valid_command_entered = VALID_COMMANDS.include?(@command)
 
    until (@command.to_i >= 1 && @command.to_i <= @songs.size) || valid_command_entered
      puts ">> Error: please enter an integer from 1 - #{@songs.size}."
      @command = gets.chomp.downcase.strip
      valid_command_entered = VALID_COMMANDS.include?(@command)
    end

    if valid_command_entered
      process_input
    else
      @now_playing = @songs[@command.to_i - 1]
      show_song_playing
      prompt_new_song
    end
  end


  def play_song(song)
    @now_playing = song
    show_song_playing
    prompt_new_song
  end


  def stop
    if @now_playing
      puts "\nStopped playing '#{print_song(@now_playing)}'."
      @now_playing = nil
    else
      puts "\nThere is no song playing!"
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
    puts "\nThanks for playing our CLI Jukebox! Have a great day."
    @power = false
  end



  def prompt_new_song
    puts "\n>> Type 'Artist' or 'Genre' to browse and pick a new song. Type 'Exit' to take a break."
  end


  def show_song_playing
    if @now_playing
      puts "\nNow playing: #{print_song(@now_playing)}."
    else
      puts "\nNo song currently playing."
    end
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

