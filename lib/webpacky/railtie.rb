# frozen_string_literal: true

require "rails/railtie"
require "webpack/dev_server"

module Webpack
  class Railtie < ::Rails::Railtie
    initializer "webpack.dev_server.proxy" do |app|
      if Webpack::DevServer.config.proxy_path
        require "webpack/dev_server/proxy"
        middleware = ::Rails::VERSION::MAJOR >= 5 ? Webpack::DevServer::Proxy : "Webpack::DevServer::Proxy"
        app.middleware.insert_before 0, middleware, ssl_verify_none: true
      end
    end

    config.after_initialize do
      require "webpacky/rails/helpers"
      ActiveSupport.on_load :action_view do
        ::ActionView::Base.include Webpacky::Rails::Helpers
      end
    end

    generators do
      require "webpacky/rails/generators/config_generator"
    end
  end
end
