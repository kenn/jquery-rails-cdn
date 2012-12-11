require 'jquery-rails'
require 'jquery-rails-cdn/version'

module Jquery::Rails::Cdn
  module ActionViewExtensions
    JQUERY_VERSION = Jquery::Rails::JQUERY_VERSION
    JQUERY_UI_VERSION = Jquery::Rails::JQUERY_UI_VERSION
    OFFLINE = (Rails.env.development? or Rails.env.test?)
    JQUERY_URL = {
      :google             => "//ajax.googleapis.com/ajax/libs/jquery/#{JQUERY_VERSION}/jquery.min.js",
      :microsoft          => "//ajax.aspnetcdn.com/ajax/jQuery/jquery-#{JQUERY_VERSION}.min.js",
      :jquery             => "http://code.jquery.com/jquery-#{JQUERY_VERSION}.min.js",
      :yandex             => "//yandex.st/jquery/#{JQUERY_VERSION}/jquery.min.js"
    }
    JQUERY_UI_URL = {
      :google             => "//ajax.googleapis.com/ajax/libs/jqueryui/#{JQUERY_UI_VERSION}/jquery-ui.min.js",
      :microsoft          => "//ajax.aspnetcdn.com/ajax/jquery.ui/#{JQUERY_UI_VERSION}/jquery-ui.min.js",
      :jquery             => "http://code.jquery.com/ui/#{JQUERY_UI_VERSION}/jquery-ui.js",
      :yandex             => "//yandex.st/jquery-ui/#{JQUERY_UI_VERSION}/jquery-ui.min.js"
    }

    def jquery_url(name, options = {})
      JQUERY_URL[name]
    end

    def jquery_ui_url(name, options = {})
      JQUERY_UI_URL[name]
    end

    def jquery_include_tag(name, options = {})
      return javascript_include_tag(:jquery) if OFFLINE and !options[:force]

      [ javascript_include_tag(jquery_url(name, options)),
        javascript_tag("window.jQuery || document.write(unescape('#{javascript_include_tag(:jquery).gsub('<','%3C')}'))")
      ].join("\n").html_safe
    end

    def jquery_ui_include_tag(name, options = {})
      return javascript_include_tag("jquery-ui") if OFFLINE and !options[:force]

      [ javascript_include_tag(jquery_ui_url(name, options)),
        javascript_tag("(window.jQuery && window.jQuery.ui) || document.write(unescape('#{javascript_include_tag("jquery-ui").gsub('<','%3C')}'))")
      ].join("\n").html_safe
    end
  end

  class Railtie < Rails::Railtie
    initializer 'jquery_rails_cdn.action_view' do |app|
      ActiveSupport.on_load(:action_view) do
        include Jquery::Rails::Cdn::ActionViewExtensions
      end
    end
  end
end
