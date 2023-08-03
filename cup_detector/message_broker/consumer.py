from typing import Dict
from confluent_kafka import Consumer, KafkaError
from ..utils.kafka_data import KAFKA_HOST, KAFKA_IP, KAFKA_TOPIC

consumer_config : Dict[str, str] = {
    'bootstrap.servers': f"{KAFKA_HOST}:{KAFKA_IP}",
    'group.id': 'my-group',
    'auto.offset.reset': 'latest' 
}

consumer : Consumer = Consumer(consumer_config)

consumer.subscribe([KAFKA_TOPIC])

while True:
    msg = consumer.poll(1.0)
    print(f"msg type: {type(msg)}")
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
