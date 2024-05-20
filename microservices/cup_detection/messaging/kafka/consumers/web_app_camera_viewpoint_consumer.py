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

# should be used later for easier HORIZONTAL SCALING to multiple clients
async def frame_consumer(websocket : websockets.server.WebSocketServerProtocol) -> Coroutine[Any, Any, Coroutine]:
    consumer : KafkaConsumer = KafkaConsumer(
        TOPIC_NAME,
        bootstrap_servers=BOOTSTRAP_SERVERS,
        auto_offset_reset=AUTO_OFFSET_RESET
    )

    try:
        for message in consumer:
            image_bytes : bytes = message.value
            await websocket.send(image_bytes)
    finally:
        consumer.close()

async def connect_and_consume() -> None:
    async with websockets.serve(frame_consumer, "localhost", 8765):
        await asyncio.Future()  

if __name__ == "__main__":
    asyncio.run(connect_and_consume())
