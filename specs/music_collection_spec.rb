require "./specs/spec_helpers"
require "./models/music_collection"

include SpecHelpers

music_collection = MusicCollection.new

it "adds an album" do
  music_collection.add("Foo", "Bar")

  assert(Album.all.length, 1)
end

it "cannot add an album twice" do
  music_collection.add("Foo", "Bar")
  music_collection.add("Foo", "Bing")

  assert(Album.all.length, 1)
end

it "plays an album by title" do
  music_collection.play("Foo")
  album = Album.find("Foo")

  assert(album.played, true)
end
