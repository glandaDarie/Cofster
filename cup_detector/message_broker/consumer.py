from typing import Dict
from confluent_kafka import Consumer, KafkaError

def kafka_consumer(topic : str | None, bootstrap_servers : str | None, **options : Dict[str, str]) -> None:
    consumer_config : Dict[str, str] = {
        "bootstrap.servers": bootstrap_servers,
        "group.id": options.get("group_id", "my-group"),
        "auto.offset.reset": options.get("auto_offset_reset", "latest") 
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