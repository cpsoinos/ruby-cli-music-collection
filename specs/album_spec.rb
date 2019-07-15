require "./models/album"
require "./tests/spec_helpers"

include SpecHelpers

album = Album.new(title: "Foo", artist: "Bar")

it "has 'title', 'artist', and 'played' properties" do
  assert(album.title, "Foo")
  assert(album.artist, "Bar")
  assert(album.played, false)
end

it "played?" do
  assert(album.played?, false)
end

it "returns the correct status" do
  assert(album.status, "unplayed")
end

it "plays an album" do
  album.play!

  assert(album.played, true)
  assert(album.played?, true)
end

it "returns display text without status" do
  assert(album.display_text, "\"Foo\" by Bar")
end

it "returns display text with status" do
  assert(album.display_text(true), "\"Foo\" by Bar (played)")
end

it "finds an album by title" do
  album = Album.create(title: "Foo", artist: "Bar")

  assert(Album.find("Foo"), album)
end

it "filters by criteria" do
  albums = [
    Album.create(title: "Abc", artist: "Def"),
    Album.create(title: "Ghi", artist: "Jkl")
  ]
  by_foo = [
    Album.create(title: "Mno", artist: "Foo"),
    Album.create(title: "Pqr", artist: "Foo")
  ]

  assert(Album.unplayed.count, 5)

  albums.map(&:play!)

  assert(Album.played.count, 2)
  assert(Album.played, albums)
  assert(Album.where(artist: "Foo"), by_foo)
end

it "validates presence of title" do
  album = Album.new(title: nil, artist: "Bar")

  assert(album.valid?, false)
  assert(album.errors, { title: "should not be blank!" })
end

it "validates presence of artist" do
  album = Album.new(title: "Pupper Doggo", artist: nil)

  assert(album.valid?, false)
  assert(album.errors, { artist: "should not be blank!" })
end

it "validates uniqueness of title" do
  album = Album.new(title: "Foo", artist: "Bar")

  assert(album.valid?, false)
  assert(album.errors, { title: "already taken!" })
end
