require 'rails'
require 'action_view'
require 'jquery-rails-cdn'
require 'minitest/autorun'

class ActionView::Base
  include Jquery::Rails::Cdn
end

class TestCdn < Minitest::Test
  def test_env
    assert Rails.env == 'development'
  end

  class One < Minitest::Test
    def setup
      Jquery::Rails::Cdn.major_version = 1
      Jquery::Rails::Cdn.class_variable_set(:@@jquery_urls, nil)
      @view = ActionView::Base.new
    end

    def test_local
      assert_equal '<script src="/javascripts/jquery.js"></script>', @view.jquery_include_tag(:google)
    end

    def test_remote
      regex = Regexp.new 'ajax.googleapis.com/ajax/libs/jquery/1.\d+.\d+/jquery.min.js'
      assert_match regex, @view.jquery_include_tag(:google, force: true)
    end
  end

  class Two < Minitest::Test
    def setup
      Jquery::Rails::Cdn.major_version = 2
      Jquery::Rails::Cdn.class_variable_set(:@@jquery_urls, nil)
      @view = ActionView::Base.new
    end

    def test_local
      Jquery::Rails::Cdn.major_version = 2
      assert_equal '<script src="/javascripts/jquery2.js"></script>', @view.jquery_include_tag(:google)
    end

    def test_remote
      regex = Regexp.new 'ajax.googleapis.com/ajax/libs/jquery/2.\d+.\d+/jquery.min.js'
      assert_match regex, @view.jquery_include_tag(:google, force: true)
    end
  end
end
