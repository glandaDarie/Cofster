from typing import Dict
from confluent_kafka import Consumer, KafkaError

def kafka_consumer(topic : str | None = None, bootstrap_servers : str | None = None, **options : None) -> str:
    consumer_config : Dict[str, str] = {
        'bootstrap.servers': bootstrap_servers,
        'group.id': 'my-group',
        'auto.offset.reset': 'latest' 
    }
    consumer : Consumer = Consumer(consumer_config)
    consumer.subscribe([topic])
    while True:
        msg = consumer.poll(1.0)
        if msg is None:
            continue
        if msg.error():
            if msg.error().code() == KafkaError._PARTITION_EOF:
                continue
            else:
                print(msg.error())
                break
        print(f"Received message: {msg.value().decode('utf-8')}")
    consumer.close()
