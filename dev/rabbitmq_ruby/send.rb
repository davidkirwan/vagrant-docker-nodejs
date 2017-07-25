#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"

conn = Bunny.new(:host=>"172.17.0.5", :port=>5672)
conn.start

ch = conn.create_channel
x = ch.topic("david")
routing_key = "hello"
routing_key2 = "world"
msg = "Hello World!"
msg2 = "World Hello!"

x.publish(msg, :routing_key => routing_key)
puts " [x] Sent '#{msg}'"
x.publish(msg2, :routing_key => routing_key2)
puts " [x] Sent '#{msg2}'"

conn.close
