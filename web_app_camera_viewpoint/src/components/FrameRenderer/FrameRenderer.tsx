import React, { useEffect, useState } from 'react';
import { FrameRendererProps  } from '../../interfaces/FrameRenderer/props';
import styles from './FrameRenderer.module.css';
import { toast } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';

export const FrameRenderer : React.FC<FrameRendererProps> = ({ websocketUrl }) => {
  const [imageSrc, setImageSrc] = useState<string | null>(null);
  const [isError, setIsError] = useState<boolean>(false);

  useEffect(() => {
    const socket : WebSocket = new WebSocket(websocketUrl);

    socket.addEventListener('open', _ => {
        socket.send('Connection established')
    });

    socket.addEventListener('message', async (event) => {
        if (event.data instanceof Blob) {
            const reader : FileReader = new FileReader();
            reader.onload = () => {
                const base64Frame : string = reader.result as string;
                setImageSrc(base64Frame);
            };
            reader.readAsDataURL(event.data);
        }
    });

    socket.addEventListener('error', (error) => {
      if (isError) {
        console.error('WebSocket error:', error);
        toast.error('WebSocket connection error');
      }
      setIsError(true);
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
      {imageSrc && <img src={imageSrc} alt='Received Image' className={styles['frame-image']} />} 
    </div>
  );
}
  