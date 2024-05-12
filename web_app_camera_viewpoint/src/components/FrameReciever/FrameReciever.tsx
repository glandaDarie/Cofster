import React, { useEffect, useState } from 'react';
import { FrameReceiverProps  } from '../../interfaces/FrameReciever/props';
import styles from './FrameReciever.module.css';
import { toast } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';

export const FrameReceiver: React.FC<FrameReceiverProps> = ({ websocketUrl }) => {
  const [imageSrc, setImageSrc] = useState<string | null>(null);

  useEffect(() => {
    const socket : WebSocket = new WebSocket(websocketUrl);

    socket.addEventListener('open', event => {
        socket.send("Connection established")
    });

    socket.addEventListener('message', async (event) => {
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
        toast.error('WebSocket connection error');
    });

    socket.addEventListener('close', () => {
      console.log('WebSocket connection closed');
    });

    return () => {
      socket.close();
    };
  }, [websocketUrl]);

  return (
    <div className={styles['frame-receiver-container']}> 
      {imageSrc && <img src={imageSrc} alt="Received Image" className={styles['frame-image']} />} 
    </div>
  );
}
  