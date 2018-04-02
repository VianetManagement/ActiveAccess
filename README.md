# ActiveAccess

Active Access is an easy, lightweight drop in protection for your Rails/Rack compatibile application. 

This little gem provides a way to lock down applications domain and/or subdomain by whitelisting IP's.

It also provides a way to bypass the protection for highly specific paths (Good for allowing webhooks to be processed).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active-access'
```

## Usage

#### Rails

**/config/initializers/active_access.rb**
```ruby
ActiveAccess.configure do |config|
  config.protected_domains = ENV.fetch("ACTIVE_ACCESS_DOMAINS", "admin.localhost.com")
  config.allowed_ips       = ENV.fetch("ACTIVE_ACCESS_IPS", "127.0.0.1")
  config.whitelisted_urls  = [["/webhook/event", "ANY"], ["/webhook/event2", "POST"]]
end
```


To dynamically disable the gem from inserting itself into your middleware:

**application.rb**
```ruby
config.before_initialize do
    ActiveAccess.config.enabled = !(Rails.env.test? || Rails.env.development?)
end
```

### General Info:

Configuration Attributes:
- **protected_domains**: Accepts a comma delimited list of domains (ex: "admin.localhost.com, localhost, localhost.com")
- **allowed_ips**: Accepts a comma delimited list of IP's. And also accepts submasked IP's too (ex: "_127.0.0.0/32_")
- **whitelisted_urls**: Accepts a nested array of the destination and its allowed HTTP request method.
   - Using "POST", "GET", "PUT", "PATCH", or "DELETE" will only allow the request to pass if its made using the specified method.
   - Using "ANY" will allow any request type to that destination.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
