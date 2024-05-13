import React, { useEffect, useState } from 'react';
import { FrameRendererProps  } from '../../interfaces/FrameRenderer/props';
import styles from './FrameRenderer.module.css';
import { toast } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
import { downloadVideo } from '../../callbacks/downloadVideo';

export const FrameRenderer : React.FC<FrameRendererProps> = ({ websocketUrl }) => {
  const [imageSrc, setImageSrc] = useState<string | null>(null);
  const [frames, setFrames] = useState<HTMLImageElement[]>([]);
  const [isError, setIsError] = useState<boolean>(false);

  useEffect(() => {
    const socket : WebSocket = new WebSocket(websocketUrl);

    socket.addEventListener('open', _ => {
        socket.send('Connection established')
    });

    socket.addEventListener('message', async (event) => {
        if (event.data instanceof Blob) {
            const reader : FileReader = new FileReader();
            const currentFrame : HTMLImageElement = new Image();
            reader.onload = () => {
                const base64Frame : string = reader.result as string;
                setImageSrc(base64Frame);
                setFrames(previousFrame => [...previousFrame, currentFrame])
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

  const handleDownload = () => {
    toast.info('Started downloading video')
    const isVideoDownloaded : boolean = downloadVideo(frames);
    if (isVideoDownloaded) {
      toast.success('Download finished successfully')
    } else {
      toast.error('Could not install the video, download crashed')
    }
  };

  return (
    <div className={styles['frame-receiver-container']}> 
      {imageSrc && <img src={imageSrc} alt='Received Image' className={styles['frame-image']} />} 
      <button className={styles['frame-download-button']} onClick={handleDownload}>Download video</button>
    </div>
  );
}
  