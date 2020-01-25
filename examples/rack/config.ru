# frozen_string_literal: true

require "rack"
require "webpack/dev_server/proxy"
require "webpacky/helper"

# Webpacky.configure do |config|
#   config.dev_server.url = ENV.fetch("WEBPACK_DEV_SERVER_URL") { "http://webpack:8080" }
#   config.dev_server.connect_timeout = ENV.fetch("WEBPACK_DEV_SERVER_CONNECT_TIMEOUT") { 0.1 }
#   config.dev_server.proxy_path = ENV.fetch("WEBPACK_PROXY_PATH") { "/webpack/" }
#   config.manifest.url = ENV.fetch("WEBPACK_MANIFEST_URL") { "http://webpack:8080/manifest.json" }
#   config.manifest.cache = false
# end

class Application
  include Webpacky::Helper

  def call(env)
    case env["PATH_INFO"]
    when "/"
      [200, { "Content-Type" => "text/html" }, [body.strip]]
    when "/favicon.ico"
      [200, { "Content-Type" => "image/vnd.microsoft.icon" }, []]
    else
      [404, { "Content-Type" => "text/plain" }, []]
    end
  end

  private

  def body
    <<~HTML
      <!DOCTYPE html>
      <html>
        <head>
          <title>Example</title>
        </head>
        <body>
          <h1>Webpacky on Rack Application Example</h1>
          <div id="hello"></div>
        </body>
        <script src="#{webpack_bundle_path('main.js')}"></script>
      </html>
    HTML
  end
end

use Webpack::DevServer::Proxy, ssl_verify_none: true

run Application.new
