import React from 'react';
import { FrameRenderer } from './components/FrameRenderer/FrameRenderer'; 

export const App: React.FC = () => {
  return (
    <div>
      <h1><center><strong>Cup Viewer</strong></center></h1>
      <FrameRenderer websocketUrl="ws://localhost:8765" />
    </div>
  );
}