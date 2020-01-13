# frozen_string_literal: true

require "open-uri"
require "json"

module Webpack::Manifest
  class Entries
    class MissingEntryError < StandardError; end

    attr_reader :entries

    def initialize(entries)
      @entries = entries
    end

    def lookup(entry)
      entries.fetch(entry) { nil }
    end

    def lookup!(entry)
      lookup(entry) || raise(MissingEntryError, "missing entry: #{entry}")
    end

    class << self
      def load(path)
        # read file
        uri = URI.parse(path.to_s)
        str = case uri
              when URI::HTTP, URI::HTTPS
                OpenURI.open_uri(uri.to_s).read
              else # default read file
                File.read(uri.path)
              end

        # to json
        entries = JSON.parse str

        # return Manifest instance
        new entries
      end
    end
  end
end
