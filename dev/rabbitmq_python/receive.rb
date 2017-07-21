#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"

conn = Bunny.new(:host=>"172.17.0.5", :port=>5672)
conn.start

ch = conn.create_channel
x = ch.topic("david")
q = ch.queue("hello", :exclusive => true)
q.bind(x, :routing_key => "hello")

puts " [*] Waiting for logs. To exit press CTRL+C"

begin
  q.subscribe(:block => true) do |delivery_info, properties, body|
    puts " [x] #{delivery_info.routing_key}:#{body}"
  end
rescue Interrupt => e
  ch.close
  conn.close
end
