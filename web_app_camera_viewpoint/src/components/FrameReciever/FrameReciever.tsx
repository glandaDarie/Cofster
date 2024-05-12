import React, { useEffect, useState } from 'react';

interface FrameReceiverProps {
  websocketUrl: string;
}

export const FrameReceiver: React.FC<FrameReceiverProps> = ({ websocketUrl }) => {
  const [imageSrc, setImageSrc] = useState<string | null>(null);
  console.log(`websocketUrl: ${websocketUrl}`)

  useEffect(() => {
    const socket : WebSocket = new WebSocket(websocketUrl);

    socket.addEventListener('open', event => {
        socket.send("Connection established")
    });

    socket.addEventListener('message', async (event) => {
        console.log(`Message from server ${event.data}`)
        if (event.data instanceof Blob) {
            const reader : FileReader = new FileReader();
            reader.onload = () => {
                const base64Image : string = reader.result as string;
                setImageSrc(base64Image);
            };
            reader.readAsDataURL(event.data);
        }
    });

    socket.addEventListener('error', (error) => {
        console.error('WebSocket error:', error);
    });

    return () => {
      socket.close();
    };
  }, [websocketUrl]);

  return (
    <div>
      {imageSrc && <img src={imageSrc} alt="Received Image" />}
    </div>
  );
}
  