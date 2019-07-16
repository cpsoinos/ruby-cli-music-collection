require "pty"
require "./specs/spec_helpers"

include SpecHelpers

def send_command(pty, command)
  wait_for_prompt(pty[0])
  pty[1].puts command
  pty[0].gets
  pty[0].gets
end

def wait_for_prompt(stdout)
  start = Time.now
  try_for = 1

  loop do
    prompt = stdout.getc
    break if prompt == ">" || Time.now > start + try_for

    sleep 0.1
  end
end

def expect(pty, command:, result:)
  send_command(pty, command)
  assert(result, pty[0].gets)
end

PTY.spawn('./music') do |stdout, stdin, pid|
  pty = stdout, stdin, pid

  assert("Welcome to your music collection!\r\n", stdout.gets)

  it "adds an album by title and artist" do
    expect(
      pty,
      command: 'add "Ride the Lightning" "Metallica"',
      result: "Added \"Ride the Lightning\" by Metallica\r\n"
    )
  end

  it "plays an album by title" do
    expect(
      pty,
      command: 'play "Ride the Lightning"',
      result: "You're listening to \"Ride the Lightning\"\r\n"
    )
  end

  it "adds another album by title and artist" do
    expect(
      pty,
      command: 'add "Licensed to Ill" "Beastie Boys"',
      result: "Added \"Licensed to Ill\" by Beastie Boys\r\n"
    )
  end

  it "plays another album by title" do
    expect(
      pty,
      command: 'play "Licensed to Ill"',
      result: "You're listening to \"Licensed to Ill\"\r\n"
    )
  end

  stdin.puts("quit")
ensure
  stdin.puts "quit"
  assert(PTY.check(pid), nil)
end
