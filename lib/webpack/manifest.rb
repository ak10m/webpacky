# frozen_string_literal: true

module Webpack
  module Manifest
    class << self
      def configure
        yield config
      end

      def config
        @config ||= Configuration.new
      end

      def entries
        return @entries if config.cache && defined?(@entries)

        @entries = Entries.load config.url
      end
    end
  end
end

require "webpack/manifest/configuration"
require "webpack/manifest/entries"
