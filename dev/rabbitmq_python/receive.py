#!/usr/bin/env python
import pika
import sys

connection = pika.BlockingConnection(pika.ConnectionParameters(host='172.17.0.2'))
channel = connection.channel()

channel.exchange_declare(exchange='david',
                         type='topic')

queue_name = 'hello'
result = channel.queue_declare(queue=queue_name, exclusive=False)

channel.queue_bind(exchange='david',
                   queue=queue_name,
                   routing_key='hello')

print(' [*] Waiting for logs. To exit press CTRL+C')

def callback(ch, method, properties, body):
    print(" [x] routing_key:%r: message:%r" % (method.routing_key, body))

channel.basic_consume(callback,
                      queue=queue_name,
                      no_ack=True)

channel.start_consuming()
