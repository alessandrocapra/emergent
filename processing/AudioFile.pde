class AudioFile {

  private String location;
  private String spotifyUrl;
  String dataPath = "./data/jazz/";
  ArrayList<FloatList> fftData;

  AudioPlayer audio;
  Minim minim;
  FFT fft;
  int bands = 512;

  // constructor
  AudioFile(String location, String spotifyUrl) {
    this.location = location;
    this.spotifyUrl = spotifyUrl;
    this.minim = new Minim(processing.this);
    this.fftData = new ArrayList<FloatList>();
  }

  // methods to use the audio file

  void play() {
    this.audio.play();
  }

  void startFFT() {
    this.audio = minim.loadFile(dataPath + this.location, bands);
    this.fft = new FFT(this.audio.bufferSize(), this.audio.sampleRate());
  }


  void getSpectrum() {
    this.fft.forward(this.audio.mix);
  }

  int[] addData() {
    float specVeryLow=0.01;
    float specLow = 0.04; // 3%
    float specMid = 0.125;  // 12.5%
    float specHi = 0.20;   // 20%
    float scoreVeryLow=0;
    float scoreLow = 0;
    float scoreMid = 0;
    float scoreHi = 0;
    float oldScoreVeryLow=scoreVeryLow;
    float oldScoreLow = scoreLow;
    float oldScoreMid = scoreMid;
    float oldScoreHi = scoreHi;
    float scoreDecreaseRate = 25;

    int[] fftValue = new int[5];
    float[] dataStore = new float[5];

    oldScoreVeryLow = scoreVeryLow;
    oldScoreLow = scoreLow;
    oldScoreMid = scoreMid;
    oldScoreHi = scoreHi;

    scoreVeryLow = 0;
    scoreLow = 0;
    scoreMid = 0;
    scoreHi = 0;

    for (int i = 0; i < fft.specSize()*specVeryLow; i++)
    {
      scoreVeryLow += fft.getBand(i);
    }

    for (int i = (int)(fft.specSize()*specVeryLow); i < fft.specSize()*specLow; i++)
    {
      scoreLow += fft.getBand(i);
    }

    for (int i = (int)(fft.specSize()*specLow); i < fft.specSize()*specMid; i++)
    {
      scoreMid += fft.getBand(i);
    }

    for (int i = (int)(fft.specSize()*specMid); i < fft.specSize()*specHi; i++)
    {
      scoreHi += fft.getBand(i);
    }
    if (oldScoreVeryLow > scoreVeryLow) {
      scoreVeryLow = oldScoreVeryLow - scoreDecreaseRate;
    }

    if (oldScoreLow > scoreLow) {
      scoreLow = oldScoreLow - scoreDecreaseRate;
    }

    if (oldScoreMid > scoreMid) {
      scoreMid = oldScoreMid - scoreDecreaseRate;
    }

    if (oldScoreHi > scoreHi) {
      scoreHi = oldScoreHi - scoreDecreaseRate;
    }

    float scoreGlobal = (scoreVeryLow + scoreLow + scoreMid + scoreHi)/4;

    dataStore[0]=log(sqrt(scoreVeryLow))/log(2);
    dataStore[1]=log(sqrt(scoreLow))/log(2);
    dataStore[2]=log(sqrt(scoreMid))/log(2);
    dataStore[3]=log(sqrt(scoreHi))/log(2);
    dataStore[4]=log(sqrt(scoreGlobal))/log(2);

    for (int i=0; i<dataStore.length; i++) {
      if (dataStore[i]<0) {
        dataStore[i]=0.0;
      }
      fftValue[i]=int(map(dataStore[i], 0, 6, 0, 254));
    }  
    return fftValue;
  }

  // setters
  void setLocation(String location) {
    this.location = location;
  }

  void setSpotifyUrl(String url) {
    spotifyUrl = url;
  }

  // getters
  String getLocation() {
    return this.location;
  }

  String getUrl() {
    return this.spotifyUrl;
  }
}