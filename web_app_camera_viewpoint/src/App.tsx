import React from 'react';
import { FrameReceiver } from './components/FrameReciever/FrameReciever';

export const App: React.FC = () => {
  return (
    <div>
      <h1><center><strong>Cup Viewer</strong></center></h1>
      <FrameReceiver websocketUrl="ws://localhost:8765" />
    </div>
  );
}