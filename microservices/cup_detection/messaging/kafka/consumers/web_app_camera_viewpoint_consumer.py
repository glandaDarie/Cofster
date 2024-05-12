from typing import Any, Coroutine
import asyncio
import websockets
from kafka import KafkaConsumer
import websockets.server

import sys

sys.path.append("../../../")

from utils.constants import (
    BOOTSTRAP_SERVERS,
    TOPIC_NAME,
    AUTO_OFFSET_RESET
)

# should be used later for LOAD BALANCING to multiple clients
async def frame_consumer(websocket : websockets.server.WebSocketServerProtocol) -> Coroutine[Any, Any, Coroutine]:
    consumer : KafkaConsumer = KafkaConsumer(
        TOPIC_NAME,
        bootstrap_servers=BOOTSTRAP_SERVERS,
        auto_offset_reset=AUTO_OFFSET_RESET
    )

    for message in consumer:
        image_bytes : bytes = message.value
        await websocket.send(image_bytes)

    consumer.close()

async def connect_and_consume():
    async with websockets.connect("ws://localhost:8765") as websocket:
        await frame_consumer(websocket)

if __name__ == "__main__":
    asyncio.run(connect_and_consume())
