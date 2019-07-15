class Album

  attr_reader :title, :artist, :played, :errors

  def initialize(title:, artist:)
    @title = title
    @artist = artist
    @played = false
    @errors = {}
  end

  def valid?
    errors[:artist] = "should not be blank!" if artist.nil?
    errors[:title] = "should not be blank!" if title.nil?
    errors[:title] = "already taken!" if title && Album.where(title: title).length > 0

    errors.empty?
  end

  def played?
    played
  end

  def unplayed?
    !played
  end

  def status
    played ? "played" : "unplayed"
  end

  def play!
    @played = true
  end
  alias play play!

  def display_text(with_status = false)
    txt = "\"#{title}\" by #{artist}"
    txt += " (#{status})" if with_status
    txt
  end

  class << self
    @@registry = []

    def all
      @@registry
    end

    def create(title:, artist:)
      album = new(title: title, artist: artist)
      if album.valid?
        @@registry << album
      end
      album
    end
    alias add create

    def artists
      @@registry.lazy.map(&:artist).force.uniq
    end

    def titles
      @@registry.lazy.map(&:title).force
    end

    def unplayed
      where(played: false)
    end

    def played
      where(played: true)
    end

    def where(criteria = {})
      @@registry.lazy.select do |album|
        criteria.all? { |k, v| album.send(k) == v }
      end.force
    end

    def find(title)
      @@registry.detect { |album| album.title == title }
    end
  end

end
