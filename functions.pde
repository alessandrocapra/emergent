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

class powerSpectrum {
  Minim       minim; 
  AudioPlayer audio;
  FFT         fft;
  int chan;
  int scale = 2; //scale for visualization
  int bands = 1024; //should be n^2 for fft (512 or 1024 are good numbers
  // for smoothing the data
  float[] sum = new float[bands];
  float smooth_factor = 0.2;
  PrintWriter output = createWriter("positions.txt"); 

  powerSpectrum(int channel) {
    chan=channel-1;
    minim = new Minim(emergent.this);
  }

  //input audio file and start the fft.
  void input(String fileName) {
    println(fileName);
    audio = minim.loadFile(fileName, bands);
    fft = new FFT(audio.bufferSize(), audio.sampleRate());
  }

  void begin() {
    audio.play();
  }

  void getSpectrum() {
    fft.forward(audio.mix);
    for (int i = 0; i < fft.specSize(); i++)
    {
      //visualize_spectrums(i);
    }
  }

  void visualize_spectrums(int i) {
    sum[i] += (fft.getBand(i) - sum[i]) * smooth_factor;
    line( i, height+chan*-45, i, height+chan*-45 - sum[i]*scale );
  }

  int mapData(int dataPoint) {
    int newData=0;

    if (dataPoint>1) {  
      newData=int(map(log(dataPoint), 0, 11, 0, 256));
    }

    return newData;
  }

  void addToBuffer() { 
    int n=0;
    int dataPoint=0;
    int average=8;
    int newDataPoint=0;

    for (int i = 0; i <= dataLoc[dataLoc.length-1]; i++)
    {
      dataPoint= dataPoint+int(fft.getBand(i)*1000);
      if (i%dataLoc[n]==0) {
        if (n!=0) {
          average=dataLoc[n]-dataLoc[n-1];
        }

        dataPoint=int(dataPoint/average);
        newDataPoint=mapData(dataPoint);
        dataBuffer[n+chan*8] = newDataPoint;



        println(n+"\t"+dataLoc[n]+"\t"+chan+"\t"+dataPoint+"\t"+newDataPoint);
        output.println(n+"\t"+dataLoc[n]+"\t"+chan+"\t"+dataPoint+"\t"+newDataPoint);

        n++;
        dataPoint=0;
      }
    }
  }
}