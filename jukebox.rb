require_relative 'parser.rb'
require_relative 'lib/artist.rb'
require_relative 'lib/song.rb'
require_relative 'lib/genre.rb'
 

class Jukebox

  VALID_COMMANDS = %w{list play stop help exit}
 
  attr_accessor :songs
  attr_reader   :power, :now_playing, :command
 
  def initialize(songs)
    @songs = songs
    @power = false
  end


  def start
    @power = true 
    welcome

    while on?
      @command = gets.chomp.downcase.strip
      process_input
    end
  end


  def on?
    @power
  end


  def process_input
    case @command
    when "list" then list
    when "play" then play
    when "stop" then stop
    when "help" then help
    when "exit" then exit

    # self.send(command.to_sym, argument) if command is to_sym
    else
      puts ">> Command not recognized. Available commands are 'List', 'Play', 'Stop', Help', and 'Exit'"
    end
  end


  def browse_artists
  end

  def browse_genres
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


  def stop
    if @now_playing
      puts "\nStopped playing '#{@now_playing}'."
      @now_playing = nil
    else
      puts "\nThere is no song playing!"
    end
    prompt_new_song
  end


  def help
    show_song_playing
    puts "\n>> HELP SCREEN"
    puts ">> Type 'List' to display the songs." 
    puts ">> Type 'Play' to play a song."
    puts ">> Type 'Stop' to stop playing the current song" if @now_playing
    puts ">> Type 'Exit' to leave the program."
  end


  def exit
    puts "\nThanks for playing our Jukebox! Have a great day."
    @power = false
  end


  def welcome
    # First thing - ask user what they would like to do
    puts "\nWelcome to the CLI!"
    puts ">> Type 'Help' for more info. Type 'Exit' to leave the program."
    puts ">> Would you like to browse by 'Artist' or 'Genre'?"
  end
 

  def prompt_new_song
    puts "\n>> Type 'List' to pick a new song. Type 'Exit' to take a break."
  end


  def show_song_playing
    if @now_playing
      puts "\nNow playing: #{@now_playing}."
    else
      puts "\nNo song currently playing."
    end
  end
 
end
 

# Parse the data folder and create a new local variable which holds all the songs
parser = Parser.new
parser.create_playlist

songs = Song.all


# start a jukebox CLI
cli = Jukebox.new(songs)
cli.start

