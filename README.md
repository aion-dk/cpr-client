CPR Client
===

A client for looking up people in the danish CPR registry.
This cpr-client only supports requests allowed for private companies (STAMP).
To use the CPR services, you must first get an agreement with [cpr.dk](https://cpr.dk/).

Install
-------

You can install cpr-client via rubygems:

    $ gem install cpr-client

Or add this to your Gemfile

    gem 'cpr-client'

Usage
-----

```ruby
# The client is connecting to the demo environment
client = CPRClient.new(username, password, true)
record = client.lookup('0707614285')

if record.nil?
  puts "The record was not found"
elsif record.protected?
  puts "The record has name and address protection"
else
  puts record[:adrnvn]
  puts record[:adrnvn, :t]
end
```
