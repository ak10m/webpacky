# frozen_string_literal: true

require "webpacky/helper"

module Webpacky
  module Rails
    module Helpers
      include Webpacky::Helper

      def javascript_bundle_tag(*entries, **options)
        javascript_include_tag(*entries.map { |entry| webpack_bundle_path "#{entry}.js" }, **options)
      end

      def stylesheet_bundle_tag(*entries, **options)
        stylesheet_link_tag(*entries.map { |entry| webpack_bundle_path "#{entry}.css" }, **options)
      end

      def image_bundle_tag(entry, **options)
        image_tag webpack_bundle_path(entry), **options
      end
    end
  end
end
