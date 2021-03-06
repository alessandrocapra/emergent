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
     // visualize_spectrums(i);
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

 //     println(n+"\t"+dataLoc[n]+"\t"+chan+"\t"+dataPoint+"\t"+newDataPoint);
        output.println(n+"\t"+dataLoc[n]+"\t"+chan+"\t"+dataPoint+"\t"+newDataPoint);

        n++;
        dataPoint=0;
      }
    }
  }
}