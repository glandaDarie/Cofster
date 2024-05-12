from typing import Any, Coroutine
import asyncio
import websockets
from kafka import KafkaConsumer
import numpy as np
import cv2
import websockets.server

async def frame_consumer(websocket : websockets.server.WebSocketServerProtocol) -> Coroutine[Any, Any, Coroutine]:
    bootstrap_servers : str = "localhost:9092"
    topic : str = "render_frames"
    consumer : KafkaConsumer = KafkaConsumer(
        topic,
        bootstrap_servers=bootstrap_servers,
        auto_offset_reset="latest"
    )

    for message in consumer:
        image_bytes : bytes = message.value
        nparr : np.ndarray = np.frombuffer(image_bytes, np.uint8)
        frame : np.ndarray = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
        print(f"Consumer: Received from kafka producer frame shape: {frame.shape}")
        await websocket.send(image_bytes)

    consumer.close()

async def connect_and_consume():
    async with websockets.connect("ws://localhost:8765") as websocket:
        await frame_consumer(websocket)

if __name__ == "__main__":
    asyncio.run(connect_and_consume())
