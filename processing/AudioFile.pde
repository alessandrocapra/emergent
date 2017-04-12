class AudioFile {

  private String location;
  private String spotifyUrl;
  String dataPath = "./data/jazz/";
  ArrayList<FloatList> fftData;

  AudioPlayer audio;
  Minim minim;
  FFT fft;
  int bands = 1024;

  // constructor
  AudioFile(String location, String spotifyUrl) {
    this.location = location;
    this.spotifyUrl = spotifyUrl;
    this.minim = new Minim(processing.this);
    
    this.fftData = new ArrayList<FloatList>();
  }

  // methods to use the audio file
  void startFFT() {
    this.audio = minim.loadFile(dataPath + this.location, bands);
    this.fft = new FFT(this.audio.bufferSize(), this.audio.sampleRate());
  }

  void play() {
    this.audio.play();
  }

  void getSpectrum() {
    this.fft.forward(this.audio.mix); 
    
    // create new FloatList object to save this round of fft in the main list
    FloatList fftValue = new FloatList();
    
    for (int i = 0; i < fft.specSize(); i++)
    {
      float val = (20*((float)Math.log10(fft.getBand(i)))*2); // * 2 --> dBscale?      
      if (fft.getBand(i) == 0) {   val = -200;   }  // avoid log(0)
      
      fftValue.append(val);
      //println(fftValue);
    }
    
    this.fftData.add(fftValue);
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
  
  ArrayList getFFTList(){
    return this.fftData;
  }
}