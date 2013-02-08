require 'jquery-rails'
require 'jquery-rails-cdn/version'

module Jquery::Rails::Cdn
  module ActionViewExtensions
    JQUERY_VERSION = Jquery::Rails::JQUERY_VERSION
    URL = {
      :google             => "//ajax.googleapis.com/ajax/libs/jquery/#{JQUERY_VERSION}/jquery.min.js",
      :microsoft          => "//ajax.aspnetcdn.com/ajax/jQuery/jquery-#{JQUERY_VERSION}.min.js",
      :jquery             => "http://code.jquery.com/jquery-#{JQUERY_VERSION}.min.js",
      :yandex             => "//yandex.st/jquery/#{JQUERY_VERSION}/jquery.min.js"
    }

    def jquery_url(name, options = {})
      URL[name]
    end

    def jquery_include_tag(name, options = {})
      return javascript_include_tag(:jquery) if offline? and !options[:force]

      javascript_include_tag(jquery_url(name, options)) +
        "\n" +
        javascript_tag("window.jQuery || document.write(unescape('#{javascript_include_tag(:jquery).gsub('<','%3C')}'))")
    end

  private
    def offline?
      @offline ||= (Rails.env.development? || Rails.env.test?)
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
