void sendData() {
  for ( int i =0; i<dataBuffer.length; i++) {
    myPort.write(dataBuffer[i]);
    while (myPort.available() > 0) {
      int inByte = myPort.read();
      //     println(inByte);
    }
  }
  //println("new buffer");
}

void drawDataLoc() {
  for ( int i=0; i<dataLoc.length; i++) {
    line(dataLoc[i], 0, dataLoc[i], height);
  }
}

void setupChannels() {
  ////number indicates channel, used for visualization
  chan1 = new powerSpectrum(1);
  chan2 = new powerSpectrum(2);
  chan3 = new powerSpectrum(3);
  chan4 = new powerSpectrum(4);
  chan5 = new powerSpectrum(5);
  chan6 = new powerSpectrum(6);
  chan7 = new powerSpectrum(7);
  chan8 = new powerSpectrum(8);
  chan9 = new powerSpectrum(9);
  chan10 = new powerSpectrum(10);
  chan11 = new powerSpectrum(11);
  chan12 = new powerSpectrum(12);
  chan13 = new powerSpectrum(13);
  chan14 = new powerSpectrum(14);
  chan15 = new powerSpectrum(15);
  chan16 = new powerSpectrum(16);

  ////add music to each channel. This should be in the /data folder. 
  chan1.input("data/jazz/01_KickIn.mp3");
  chan2.input("data/jazz/02_KickOut.mp3");
  chan3.input("data/jazz/03_SnareUp.mp3");
  chan4.input("data/jazz/04_SnareDown.mp3");
  chan5.input("data/jazz/05_HiHat.mp3");
  chan6.input("data/jazz/06_Tom1.mp3");
  chan7.input("data/jazz/07_Tom2.mp3");
  chan8.input("data/jazz/08_Tom3.mp3");
  chan9.input("data/jazz/09_Overheads.mp3");
  chan10.input("data/jazz/10_BassMic.mp3");
  chan11.input("data/jazz/11_BassDI.mp3");
  chan12.input("data/jazz/12_PianoMics1.mp3");
  chan13.input("data/jazz/13_PianoMics2.mp3");
  chan14.input("data/jazz/14_Trumpet.mp3");
  chan15.input("data/jazz/15_Trombone.mp3");
  chan16.input("data/jazz/16_Saxophone.mp3");

  ////start everything (including play)
  chan1.begin();
  chan2.begin();
  chan3.begin();
  chan4.begin();
  chan5.begin();
  chan6.begin();
  chan7.begin();
  chan8.begin();
  chan9.begin();
  chan10.begin();
  chan11.begin();
  chan12.begin();
  chan13.begin();
  chan14.begin();
  chan15.begin();
  chan16.begin();
}

void analyzeSpectra() {
  //get the powerspectrum (fft) per channel
  chan1.getSpectrum();
  chan2.getSpectrum();
  chan3.getSpectrum();
  chan4.getSpectrum();
  chan5.getSpectrum();
  chan6.getSpectrum();
  chan7.getSpectrum();
  chan8.getSpectrum();
  chan9.getSpectrum();
  chan10.getSpectrum();
  chan11.getSpectrum();
  chan12.getSpectrum();
  chan13.getSpectrum();
  chan14.getSpectrum();
  chan15.getSpectrum();
  chan16.getSpectrum();
}

void addToBuffer() {
  chan1.addToBuffer();
  chan2.addToBuffer();  
  chan3.addToBuffer();
  chan4.addToBuffer();
  chan4.addToBuffer();
  chan5.addToBuffer();
  chan6.addToBuffer();
  chan7.addToBuffer();
  chan8.addToBuffer();
  chan9.addToBuffer();
  chan10.addToBuffer();
  chan11.addToBuffer();
  chan12.addToBuffer();
  chan13.addToBuffer();
  chan14.addToBuffer();
  chan15.addToBuffer();
  chan16.addToBuffer();
}