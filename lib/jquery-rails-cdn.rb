require 'jquery-rails'
require 'jquery-rails-cdn/version'

module Jquery::Rails::Cdn
  module ActionViewExtensions
    OFFLINE = (Rails.env.development? or Rails.env.test?)

    def jquery_include_tag(name, options = {})
      use_v1 = options.delete(:use_v1)

      return javascript_include_tag(jquery_asset(use_v1), options) if !options.delete(:force) and OFFLINE
      serve_cdn_version(name, options, use_v1)
    end

    def jquery_url(name, use_v1 = false)
      version = jquery_version(use_v1)
      cdn_url(version)[name]
    end

    private

    def serve_cdn_version(name, options, use_v1)
      [javascript_include_tag(jquery_url(name, use_v1), options),
       javascript_tag("window.jQuery || document.write(unescape('#{javascript_include_tag(jquery_asset(use_v1), options).gsub('<', '%3C')}'))")
      ].join("\n").html_safe
    end
    
    def jquery_asset(use_v1)
      use_v1 ? :jquery : :jquery2
    end
    
    def jquery_version(use_v1 = false)
      use_v1 ? Jquery::Rails::JQUERY_VERSION : Jquery::Rails::JQUERY_2_VERSION
    rescue NameError
      Jquery::Rails::JQUERY_VERSION
    end

    def cdn_url(version)
      return unless version
      { google:     "//ajax.googleapis.com/ajax/libs/jquery/#{version}/jquery.min.js",
        microsoft:  "//ajax.aspnetcdn.com/ajax/jQuery/jquery-#{version}.min.js",
        jquery:     "//code.jquery.com/jquery-#{version}.min.js",
        yandex:     "//yandex.st/jquery/#{version}/jquery.min.js",
        cloudflare: "//cdnjs.cloudflare.com/ajax/libs/jquery/#{version}/jquery.min.js"
      }
    end
  end

  class Railtie < Rails::Railtie
    initializer 'jquery_rails_cdn.action_view' do |_app|
      ActiveSupport.on_load(:action_view) do
        include Jquery::Rails::Cdn::ActionViewExtensions
      end
    end
  end
end
