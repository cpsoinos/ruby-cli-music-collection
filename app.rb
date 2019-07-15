require "readline"
require "./models/music_collection"

puts "Welcome to your music collection!"

collection = MusicCollection.new

command_regexp = /\A(quit|show\splayed\sby|show\sunplayed\sby|show\sall\sby|show\sunplayed|show\splayed|show\sall|play|add)/
find_command = ->(input) {
  command_regexp.match(input.strip)&.captures&.first&.gsub(" ", "_")
}

args_regexp = %r("([^"]*)")
find_args = ->(input) { input.scan(args_regexp).flatten }

valid_commands = [
  "add",
  "play",
  "show_all",
  "show_played",
  "show_unplayed",
  "show_all_by",
  "show_played_by",
  "show_unplayed_by",
  "quit"
]

while buf = Readline.readline("> ", true)
  command = find_command.call(buf)
  args = find_args.call(buf.to_s)
  puts
  if valid_commands.include?(command)
    begin
      collection.send(command, *args)
    rescue StandardError => e
      puts e
    end
  else
    puts "Uh-oh! `#{buf}` is not a valid command."
  end
  puts
end
