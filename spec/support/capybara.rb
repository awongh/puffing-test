require 'capybara/rails'
require 'capybara/rspec'
require 'billy/capybara/rspec'
require 'capybara/cuprite'

Billy.configure do |c|
  c.cache = true
  c.persist_cache = true
  c.record_requests = true # defaults to false

  c.cache_path = 'spec/req_cache/'
  c.certs_path = 'spec/req_certs/'

  c.cache_request_body_methods = ['post', 'patch', 'put'] # defaults to ['post']
  c.whitelist = ['test.host', 'localhost', '127.0.0.1']

  c.non_whitelisted_requests_disabled = true
  # c.non_whitelisted_requests_disabled = false
end

# https://evilmartians.com/chronicles/system-of-a-test-setting-up-end-to-end-rails-testing
Capybara.register_driver(:better_cuprite) do |app|

  browser_options = {}.tap do |opts|
    opts['ignore-certificate-errors'] = nil
  end

  options = {}.tap do |opts|
    opts[:browser_options] = browser_options # { 'no-sandbox': nil },
    opts[:js_errors] = true
    opts[:timeout] = 100
  end


  driver = Capybara::Cuprite::Driver.new(app, options)
  driver.set_proxy(Billy.proxy.host, Billy.proxy.port)
  driver
end
Capybara.default_driver = Capybara.javascript_driver = :better_cuprite
