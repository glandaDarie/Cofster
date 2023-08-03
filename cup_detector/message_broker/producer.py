from typing import Dict
from confluent_kafka import Producer

def kafka_producer(frame_data : str, frame_number : int, topic : str | None = None, \
                   bootstrap_servers : str | None = None) -> str:
    producer_config : Dict[str, str] = {
        "bootstrap.servers": bootstrap_servers,
    }
    try:
        producer : Producer = Producer(producer_config)
        producer.produce(topic, key=f"frame number: {frame_number}", value=frame_data)
    except Exception as e:
        raise f"Exception with kafka producer: {e}"
    return "Message produced successfully"