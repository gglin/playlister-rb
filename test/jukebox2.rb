require_relative '../environment'


class Jukebox2

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
          puts "\t#{index+1}.    "[0,5] + " #{song.spacer(song.artist.name, longest_name_length(category.artists))} - #{song.name}"
        elsif category.class.to_s == "Artist"
          puts "\t#{index+1}.    "[0,5] + " #{song.print}"
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
      puts "\n  Stopped playing '#{@now_playing.artist.name} - #{@now_playing.print}'"
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
      puts "\n  Now playing: #{@now_playing.artist.name} - #{@now_playing.print}"
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


  def print_category(category, width = nil, include_artist = false, artist_width = nil)
    category.print(width, include_artist, artist_width)
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
parser.call('data')

songs = Song.all


# start a jukebox CLI
cli = Jukebox2.new
cli.add_songs(songs)
cli.start
