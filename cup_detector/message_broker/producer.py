from typing import Dict
from confluent_kafka import Producer

def kafka_producer(body : Dict[str, str], topic : str | None = None, \
                   bootstrap_servers : str | None = None) -> str | Exception:
    producer_config : Dict[str, str] = {
        "bootstrap.servers": bootstrap_servers,
    }
    try:
        frame_number : str = body["frame_number"]
        frame_data : str= body["frame_data"]
        producer : Producer = Producer(producer_config)
        producer.produce(topic, key=f"{frame_number}) frame", value=frame_data)
        producer.flush()
    except KeyError as e:
        raise Exception(f"KeyError when trying to unwrap the data body: {e}")
    except Exception as e:
        raise Exception(f"Exception with kafka producer: {e}")
    return "Message produced successfully"