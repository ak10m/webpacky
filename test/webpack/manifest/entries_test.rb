# frozen_string_literal: true

require "test_helper"
require "webpack/manifest/entries"

class Webpack::Manifest::EntriesTest < Minitest::Test
  def setup
    @manifest = Webpack::Manifest::Entries.new(
      "bundle.js" => "/packs/bundle-digest.js"
    )
  end

  def test_lookup
    assert_equal "/packs/bundle-digest.js", @manifest.lookup("bundle.js")
    assert_nil @manifest.lookup("unknown.js")
  end

  def test_lookup!
    assert_equal "/packs/bundle-digest.js", @manifest.lookup!("bundle.js")

    # errors
    assert_raises Webpack::Manifest::Entries::MissingEntryError do
      @manifest.lookup!("unknown.js")
    end
  end

  def test_load_from_local_file
    # load file
    file_path = fixture_path "files/manifest.json"
    assert_instance_of Webpack::Manifest::Entries, Webpack::Manifest::Entries.load(file_path)
  end

  def test_load_from_remote_file
    remote_server = RackServerProcess.new(config: fixture_path("files.ru"))
    remote_server.run do |rs|
      remote_url = "http://#{rs.host_with_port}/manifest.json"
      assert_instance_of Webpack::Manifest::Entries, Webpack::Manifest::Entries.load(remote_url)
    end
  end

  def test_load_when_given_invalid_uri
    assert_raises URI::InvalidURIError do
      Webpack::Manifest::Entries.load "invalid uri"
    end
  end
end
