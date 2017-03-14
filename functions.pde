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

  powerSpectrum(int channel) {
    chan=channel-1;
    minim = new Minim(test_v3.this);
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
      visualize_spectrums(i);
    }
  }

  void visualize_spectrums(int i) {
    sum[i] += (fft.getBand(i) - sum[i]) * smooth_factor;
    line( i, height+chan*-45, i, height+chan*-45 - sum[i]*scale );
  }

  void sendData() {
    for (int i = 0; i < fft.specSize()/3; i++)
    {
      if (i%3==0) {
        myPort.write(int(fft.getBand(i)*1000));
        myPort.write("\n"); // let the arduino differentiate per data point.
      }
    }
  }
}