#!/usr/bin/env node

var amqp = require('amqplib/callback_api');

amqp.connect('amqp://172.17.0.5', function(err, conn) {
  conn.createChannel(function(err, ch) {
    var ex = 'david';
    var args = process.argv.slice(2);
    var key = 'hello';
    var msg = 'Hello World!';

    ch.assertExchange(ex, 'topic', {durable: false});
    ch.publish(ex, key, new Buffer(msg));
    console.log(" [x] Sent %s:'%s'", key, msg);
  });

  setTimeout(function() { conn.close(); process.exit(0) }, 500);
});
