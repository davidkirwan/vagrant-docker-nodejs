#!/usr/bin/env node

var amqp = require('amqplib/callback_api');


amqp.connect('amqp://172.17.0.5', function(err, conn) {
  conn.createChannel(function(err, ch) {
    var ex = 'david';
    var key = 'hello';

    ch.assertExchange(ex, 'topic', {durable: false, auto_delete: true});

    ch.assertQueue('hello', {exclusive: true}, function(err, q) {
      console.log(' [*] Waiting for logs. To exit press CTRL+C');

      ch.bindQueue(q.queue, ex, key);

      ch.consume(q.queue, function(msg) {
        console.log(" [x] %s:'%s'", msg.fields.routingKey, msg.content.toString());
      }, {noAck: true});
    });
  });
});
