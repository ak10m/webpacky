# frozen_string_literal: true

require "test_helper"
require "webpacky/helper"

class Webpacky::HelperTest < Minitest::Test
  class Helper
    include Webpacky::Helper
  end

  def setup
    @helper = Helper.new
    @manifest = Webpack::Manifest::Entries.new(
      "script.js" => "script-digest.js",
      "style.css" => "/bundles/style-digest.css",
      "logo.svg" => "https://cdn/images/logo-digest.svg"
    )
  end

  def test_webpack_bundle_path
    Webpack::DevServer.stub :config, Webpack::DevServer::Configuration.new do
      Webpack::DevServer.configure do |c|
        c.proxy_path = "/web/pack/"
      end

      Webpack::Manifest.stub :entries, @manifest do
        assert_equal "/web/pack/script-digest.js", @helper.webpack_bundle_path("script.js")
        assert_equal "/web/pack/bundles/style-digest.css", @helper.webpack_bundle_path("style.css")
        assert_equal "https://cdn/images/logo-digest.svg", @helper.webpack_bundle_path("logo.svg")
      end
    end
  end

  def test_webpack_bundle_path_when_no_proxy_path
    Webpack::DevServer.stub :config, Webpack::DevServer::Configuration.new do
      Webpack::DevServer.configure do |c|
        c.proxy_path = false
      end

      Webpack::Manifest.stub :entries, @manifest do
        assert_equal "script-digest.js", @helper.webpack_bundle_path("script.js")
        assert_equal "/bundles/style-digest.css", @helper.webpack_bundle_path("style.css")
        assert_equal "https://cdn/images/logo-digest.svg", @helper.webpack_bundle_path("logo.svg")
      end
    end
  end
end
