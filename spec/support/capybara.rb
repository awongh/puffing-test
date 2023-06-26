require 'capybara/rails'
require 'capybara/rspec'
require 'billy/capybara/rspec'
require 'capybara/cuprite'

Billy.configure do |c|
  c.cache = true
  c.cache_request_headers = false
  c.ignore_params = ["http://www.google-analytics.com/__utm.gif",
                     "https://r.twimg.com/jot",
                     "http://p.twitter.com/t.gif",
                     "http://p.twitter.com/f.gif",
                     "http://www.facebook.com/plugins/like.php",
                     "https://www.facebook.com/dialog/oauth",
                     "http://cdn.api.twitter.com/1/urls/count.json",
                     "maps.googlepais.com",
  "https://mssdk-sg.byteoversea.com",
  "https://v19-web-newkey.tiktokcdn.com",
  "https://www.tiktok.com",
  "https://mssdk-sg.tiktok.com",
  "https://vmweb-sg.byteoversea.com"]
  c.path_blacklist = []
  c.merge_cached_responses_whitelist = []
  c.persist_cache = true
  c.ignore_cache_port = false # defaults to true
  c.non_successful_cache_disabled = false
  c.non_successful_error_level = :error
  c.cache_path = 'spec/req_cache'
  c.certs_path = 'spec/req_certs'
  #c.proxy_port = 12345 # defaults to random
  c.proxied_request_host = nil
  #c.proxied_request_port = 80
  c.cache_whitelist = []
  c.record_requests = true # defaults to false
  c.cache_request_body_methods = ['post', 'patch', 'put'] # defaults to ['post']
  c.whitelist = ['test.host', 'localhost', '127.0.0.1']

  # dont care about query params for ignored urls
  # c.strip_query_params = true

  c.non_whitelisted_requests_disabled = true
  # c.non_whitelisted_requests_disabled = false
end

# https://evilmartians.com/chronicles/system-of-a-test-setting-up-end-to-end-rails-testing
Capybara.register_driver(:better_cuprite) do |app|

  browser_options = {}.tap do |opts|
    opts['ignore-certificate-errors'] = nil
    opts['auto-open-devtools-for-tabs'] = !ENV['HEADLESS'].in?(%w[n 0 no false])
  end

  options = {}.tap do |opts|
    opts[:browser_options] = browser_options # { 'no-sandbox': nil },
    opts[:js_errors] = true
    opts[:headless] = !ENV['HEADLESS'].in?(%w[n 0 no false])
    logger = StringIO.new
    opts[:logger] = logger
    opts[:timeout] = 100
  end

  driver = Capybara::Cuprite::Driver.new(app, options)
  driver.set_proxy(Billy.proxy.host, Billy.proxy.port)
  driver
end
Capybara.default_driver = Capybara.javascript_driver = :better_cuprite
