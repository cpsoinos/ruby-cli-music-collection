require './models/album'

class MusicCollection

  def add(title, artist)
    album = Album.create(title: title, artist: artist)
    if album.errors.empty?
      print "Added "
      show([album])
    else
      puts "Uh-oh! Looks like we have a problem."
      album.errors.each do |key, value|
        puts "  #{key}: #{value}"
      end
    end
  end

  def play(title)
    album = Album.find(title)
    album.play!
    puts "You're listening to \"#{title}\""
  end

  def show(albums=[], with_status = false)
    display_text = albums.map do |album|
      album.display_text(with_status)
    end.join("\n")
    puts display_text
  end

  def show_all
    show(Album.all, true)
  end

  def show_played
    show(Album.played)
  end

  def show_unplayed
    show(Album.unplayed)
  end

  def show_all_by(artist)
    albums = Album.where(artist: artist)
    show(albums, true)
  end

  def show_played_by(artist)
    albums = Album.where(artist: artist, played: true)
    show(albums)
  end

  def show_unplayed_by(artist)
    albums = Album.where(artist: artist, played: false)
    show(albums)
  end

  def quit
    puts "Bye!"
    exit(true)
  end

end
