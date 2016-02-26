CPR Client
===

A client for looking up people in the CPR registry (as a private company).
It is backed by HTTPClient.

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