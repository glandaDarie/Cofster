import { DownloadVideoCallback } from "../interfaces/DownloadVideoCallback/props";

export const downloadVideo: DownloadVideoCallback = (frames: HTMLImageElement[]) => {
    const canvas: HTMLCanvasElement = document.createElement('canvas');
    const context: CanvasRenderingContext2D | null = canvas.getContext('2d');

    if (!context) {
        return false;
    }

    const width: number = context.canvas.width = frames[0].width;
    const height: number = context.canvas.height = frames[0].height;

    frames.forEach(frame => {
        context.drawImage(frame, 0, 0, width, height);
    });

    const stream: MediaStream = canvas.captureStream();
    const mediaRecorder: MediaRecorder = new MediaRecorder(stream, { mimeType: 'video/webm' });
    const recordedChunks: Blob[] = [];

    mediaRecorder.ondataavailable = (event) => {
        if (event.data.size > 0) {
            recordedChunks.push(event.data);
        }
    };

    mediaRecorder.onstop = () => {
        const videoBlob: Blob = new Blob(recordedChunks, { type: 'video/webm' });
        const videoURL: string = URL.createObjectURL(videoBlob);

        const link: HTMLAnchorElement = document.createElement('a');
        link.href = videoURL;
        link.download = 'recorded_video.webm';

        document.body.appendChild(link);
        link.click();

        document.body.removeChild(link);
        URL.revokeObjectURL(videoURL);
    };

    mediaRecorder.start();

    setTimeout(() => {
        mediaRecorder.stop();
    }, frames.length * 1000 / 30);

    return true;
};
