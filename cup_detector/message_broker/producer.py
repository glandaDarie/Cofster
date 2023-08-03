from typing import Dict
from confluent_kafka import Producer
from ..utils.kafka_data import KAFKA_HOST, KAFKA_IP, KAFKA_TOPIC

producer_config : Dict[str, str] = {
    "bootstrap.servers": f"{KAFKA_HOST}:{KAFKA_IP}",
}

producer : Producer = Producer(producer_config)

for i in range(5):
    message : str = f"Message {i}"
    producer.produce(KAFKA_TOPIC, key=str(i), value=message)
    producer.flush()

print("Messages produced")