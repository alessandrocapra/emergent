import processing.net.*;
import processing.serial.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import http.requests.*; // Library for HTTP requests: https://github.com/runemadsen/HTTP-Requests-for-Processing


Minim minim;
AudioPlayer song;
FFT fft;

Serial myPort;

// array of available songs
AudioFile[] songs = new AudioFile[20];

// spotify urls to retrieve the data
String beethoven = "3DNRdudZ2SstnDCVKFdXxG";

//song selection
  //{"data/16_Saxophone.mp3"}, 


// Variables qui définissent les "zones" du spectre
// Par exemple, pour les basses, on prend seulement les premières 4% du spectre total
float specLow = 0.03; // 3%
float specMid = 0.125;  // 12.5%
float specHi = 0.20;   // 20%

// Valeurs de score pour chaque zone
float scoreLow = 0;
float scoreMid = 0;
float scoreHi = 0;

// Valeur précédentes, pour adoucir la reduction
// float oldScoreLow = scoreLow;
// float oldScoreMid = scoreMid;
// float oldScoreHi = scoreHi;

// Valeur d'adoucissement
// float scoreDecreaseRate = 25;

float[] dataStore = new float[5];
int[] data = new int[5];

// function to retrieve files from the data/jazz folder (change accordingly)
String[] getAudioFilesList(){
  java.io.File folder = new java.io.File(dataPath("jazz/"));
  
  // return filenames in folder
  return folder.list();
}

void setup() {
  minim = new Minim(this);
  //song = minim.loadFile("midterm_demo.mp3");
  //fft = FFT(song.bufferSize(), song.sampleRate()); 
  //printArray(Serial.list());
  
  // load songs into array
  String[] files = getAudioFilesList();
  
  // create songs array
  for(int i = 0; i < files.length; i++){
    songs[i] = new AudioFile(files[i], beethoven);
  }
  
  for(int j = 0; j < songs.length; j++){
    //println(songs[j].getLocation());
  }
  
  println(songs[10].getLocation());
  //println(songs[0].getUrl());
 
  myPort = new Serial(this, Serial.list()[0], 115200);
  song.play(0);
}

void draw() {
  //fft.forward(song.mix);
  
  //Calcul des "scores" (puissance) pour trois catégories de son
  //D'abord, sauvgarder les anciennes valeurs
  //oldScoreVeryLow = scoreVeryLow;
  //oldScoreLow = scoreLow;
  //oldScoreMid = scoreMid;
  //oldScoreHi = scoreHi;

  //scoreVeryLow = 0;
  //scoreLow = 0;
  //scoreMid = 0;
  //scoreHi = 0;

  //for (int i = 0; i < fft.specSize()*specVeryLow; i++)
  //{
  //  scoreVeryLow += fft.getBand(i);
  //}

  //for (int i = (int)(fft.specSize()*specVeryLow); i < fft.specSize()*specLow; i++)
  //{
  //  scoreLow += fft.getBand(i);
  //}

  //for (int i = (int)(fft.specSize()*specLow); i < fft.specSize()*specMid; i++)
  //{
  //  scoreMid += fft.getBand(i);
  //}

  //for (int i = (int)(fft.specSize()*specMid); i < fft.specSize()*specHi; i++)
  //{
  //  scoreHi += fft.getBand(i);
  //}

  //Faire ralentir la descente.
  //if (oldScoreVeryLow > scoreVeryLow) {
  //  scoreVeryLow = oldScoreVeryLow - scoreDecreaseRate;
  //}
  
  //if (oldScoreLow > scoreLow) {
  //  scoreLow = oldScoreLow - scoreDecreaseRate;
  //}

  //if (oldScoreMid > scoreMid) {
  //  scoreMid = oldScoreMid - scoreDecreaseRate;
  //}

  //if (oldScoreHi > scoreHi) {
  //  scoreHi = oldScoreHi - scoreDecreaseRate;
  //}
  
  //float scoreGlobal = (scoreVeryLow + scoreLow + scoreMid + scoreHi)/4;

  //dataStore[0]=log(sqrt(scoreVeryLow))/log(2);
  //dataStore[1]=log(sqrt(scoreLow))/log(2);
  //dataStore[2]=log(sqrt(scoreMid))/log(2);
  //dataStore[3]=log(sqrt(scoreHi))/log(2);
  //dataStore[4]=log(sqrt(scoreGlobal))/log(2);

  //for (int i=0; i<dataStore.length; i++) {
  //  if (dataStore[i]<0) {
  //    dataStore[i]=0.0;
  //  }
  //  data[i]=int(map(dataStore[i], 0, 6, 0, 254));
  //}  

  //println(data);

  //for (int i=0; i<data.length; i++) {
  //  myPort.write(data[i]);
  //}
}