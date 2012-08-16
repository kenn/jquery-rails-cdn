require 'jquery-rails'
require 'jquery-rails-cdn/version'

module Jquery::Rails::Cdn
  module ActionViewExtensions
    JQUERY_VERSION = Jquery::Rails::JQUERY_VERSION
    OFFLINE = (Rails.env.development? or Rails.env.test?)
    URL = {
      :google             => "http://ajax.googleapis.com/ajax/libs/jquery/#{JQUERY_VERSION}/jquery.min.js",
      :google_ssl         => "https://ajax.googleapis.com/ajax/libs/jquery/#{JQUERY_VERSION}/jquery.min.js",
      :google_schemeless  => "//ajax.googleapis.com/ajax/libs/jquery/#{JQUERY_VERSION}/jquery.min.js",
      :microsoft          => "http://ajax.aspnetcdn.com/ajax/jQuery/jquery-#{JQUERY_VERSION}.min.js",
      :jquery             => "http://code.jquery.com/jquery-#{JQUERY_VERSION}.min.js"
    }

    def jquery_url(name = :google, options = {})
      URL[name]
    end

    def jquery_include_tag(name, options = {})
      return javascript_include_tag(:jquery) if OFFLINE and !options[:force]

      [ javascript_include_tag(jquery_url(name, options)),
        javascript_tag("window.jQuery || document.write(unescape('#{javascript_include_tag(:jquery).gsub('<','%3C')}'))")
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
