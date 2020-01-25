# frozen_string_literal: true

require "webpack/dev_server"
require "webpack/manifest"

module Webpacky
  module Helper
    def webpack_bundle_path(entry)
      lookuped = URI.parse Webpack::Manifest.entries.lookup!(entry)
      prefix = Webpack::DevServer.config.proxy_path

      return lookuped.to_s unless lookuped.host.nil? && prefix

      Pathname.new("/#{prefix}/#{lookuped}").cleanpath.to_s
    end
  end
end
