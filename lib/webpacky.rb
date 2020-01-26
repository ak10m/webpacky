# frozen_string_literal: true

module Webpacky
  class << self
    def configure
      yield config
    end

    def config
      @config ||= Configuration.new
    end
  end
end

require "webpacky/configuration"
require "webpacky/railtie" if defined? Rails
