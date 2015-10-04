require 'jquery-rails'
require 'jquery-rails-cdn/version'

module Jquery::Rails::Cdn
  mattr_accessor :major_version

  module ActionViewExtensions
    OFFLINE = (Rails.env.development? or Rails.env.test?)
    URL = {
      :google      => "//ajax.googleapis.com/ajax/libs/jquery/{JQUERY_VERSION}/jquery.min.js",
      :microsoft   => "//ajax.aspnetcdn.com/ajax/jQuery/jquery-{JQUERY_VERSION}.min.js",
      :jquery      => "//code.jquery.com/jquery-{JQUERY_VERSION}.min.js",
      :yandex      => "//yandex.st/jquery/{JQUERY_VERSION}/jquery.min.js",
      :cloudflare  => "//cdnjs.cloudflare.com/ajax/libs/jquery/{JQUERY_VERSION}/jquery.min.js"
    }

    def jquery_url(name)
      @@jquery_urls ||= begin
        version = jquery_version_chooser(Jquery::Rails::JQUERY_VERSION, Jquery::Rails::JQUERY_2_VERSION)
        Hash[URL.map{|k,v| [k, v.sub(/\{JQUERY_VERSION\}/, version)] }]
      end
      if name == :local
        jquery_version_chooser(:jquery, :jquery2)
      else
        @@jquery_urls[name]
      end
    end

    def jquery_version_chooser(one, two)
      case Jquery::Rails::Cdn.major_version
      when 1, NilClass
        one
      when 2
        two
      else
        raise 'invalid :major_version option'
      end
    end

    def jquery_include_tag(name, options = {})
      return javascript_include_tag(jquery_url(:local), options) if OFFLINE && !options.delete(:force)

      [ javascript_include_tag(jquery_url(name), options),
        javascript_tag("window.jQuery || document.write(unescape('#{javascript_include_tag(jquery_url(:local), options).gsub('<','%3C')}'))")
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
