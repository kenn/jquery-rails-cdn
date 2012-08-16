# jquery-rails-cdn

Add CDN support to [jquery-rails](https://github.com/rails/jquery-rails).

Serving jQuery from a publicly available [CDN](http://en.wikipedia.org/wiki/Content_Delivery_Network) has clear benefits:

* **Speed**: Users will be able to download jQuery from the closest physical location.
* **Caching**: CDN is used so widely that potentially your users may not need to download jQuery at all.
* **Parallelism**: Browsers have a limitation on how many connections can be made to a single host. Using CDN for jQuery offloads a big one.

## Features

This gem offers the following features:

* Supports multiple CDN. (Google, Microsoft and jquery.com)
* jQuery version is automatically detected via jquery-rails.
* Automatically fallback to jquery-rails' bundled jQuery when:
  * You're on a development environment, so that you can work offline.
  * The CDN is down or unavailable.

On top of that, if you're using asset pipeline, you may have noticed that the major chunks of the code in `application.js` is jQuery. Implications of externalizing jQuery from `application.js` are:

* Updating your js code won't evict the entire cache in browsers - your code changes more often than jQuery upgrades, right?
* `rake assets:precompile` takes less peak memory usage.

Changelog:

* v0.1.0: Added `:google_schemeless` for sites that support both ssl / non-ssl
* v0.0.1: Initial release

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jquery-rails-cdn'
```

## Usage

This gem adds two methods `jquery_include_tag` and `jquery_url` to generate a script tag to the jQuery on a CDN of your preference.

If you're using asset pipeline with Rails 3.1+, first remove `//= require jquery` from `application.js`.

Then in layout:

```ruby
= jquery_include_tag :google
= javascript_include_tag 'application'
```

Note that valid CDN symbols are:

```ruby
:google
:google_ssl
:google_schemeless
:microsoft
:jquery
:yandex
```

It will generate the following on production:

```html
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js" type="text/javascript"></script>
<script type="text/javascript">
//<![CDATA[
window.jQuery || document.write(unescape('%3Cscript src="/assets/jquery-86b29a215ef746103e2469f095a4df9e.js" type="text/javascript">%3C/script>'))
//]]>
</script>
```

on development:

```html
<script src="/assets/jquery.js?body=1" type="text/javascript"></script>
```

Be sure to put the following line in `config/application.rb`, as it will be served when CDN is not available.

```ruby
config.assets.precompile += ['jquery.js']
```

If you want to check the production URL, you can pass `:force => true` as an option.

```ruby
jquery_include_tag :google, :force => true
```
