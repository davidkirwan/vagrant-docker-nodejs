#!/usr/bin/env python
import pika
import sys

connection = pika.BlockingConnection(pika.ConnectionParameters(host='172.17.0.5'))
channel = connection.channel()

channel.exchange_declare(exchange='david',
                         type='topic')

routing_key = 'hello'

message = 'Hello World!'
channel.basic_publish(exchange='david',
                      routing_key='hello',
                      body=message)
print(" [x] Sent %r" % (message))
connection.close()
