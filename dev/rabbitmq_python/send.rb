#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"

conn = Bunny.new(:host=>"172.17.0.5", :port=>5672)
conn.start

ch = conn.create_channel
x = ch.topic("david")
routing_key = "hello"
msg = "Hello World!"

x.publish(msg, :routing_key => routing_key)
puts " [x] Sent '#{msg}'"

conn.close
