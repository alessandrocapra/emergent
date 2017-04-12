import processing.net.*;
import processing.serial.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import http.requests.*; // Library for HTTP requests: https://github.com/runemadsen/HTTP-Requests-for-Processing

Serial myPort;

// array of available songs
AudioFile[] songs = new AudioFile[17];

// spotify urls to retrieve the data
String beethoven = "3DNRdudZ2SstnDCVKFdXxG";

//song selection
//{"data/16_Saxophone.mp3"}, 

// function to retrieve files from the data/jazz folder (change accordingly)
String[] getAudioFilesList() {
  java.io.File folder = new java.io.File(dataPath("jazz/"));

  // return filenames in folder
  return folder.list();
}

int[] sendData;

void setup() {
  frameRate(60);
  //song = minim.loadFile("midterm_demo.mp3");
  //fft = FFT(song.bufferSize(), song.sampleRate()); 
  //printArray(Serial.list());
  
  sendData=new int[85]; //make this number of outputs. 
  
  // load songs into array
  String[] files = getAudioFilesList();

  // create songs array
  for (int i = 0; i < files.length; i++) {
    songs[i] = new AudioFile(files[i], beethoven);
  }

  for (int j = 0; j < songs.length; j++) {
    //println(songs[j].getLocation());
  }

  //println(songs[10].getLocation());
  //println(songs[0].getUrl());

  //println("Song list: \n");
  //for(int x = 0; x < songs.length; x++){
  //  println("Position " + x + ": " + songs[x].getLocation());
  //}

  // prepare all songs' FFT
  for (int i = 0; i < songs.length; i++) {
    songs[i].startFFT();
  }

  // play all of 'em
  for (int i = 0; i < songs.length; i++) {
    songs[i].play();
  }
  // myPort = new Serial(this, Serial.list()[0], 115200);
}

void draw() {

  // move forward all songs' FFT
  for (int i = 0; i < songs.length; i++) {
    songs[i].getSpectrum();
  }
  
  for (int i = 0; i < songs.length; i++) {
    sendData=songs[i].addData(); //<---still fix this into one long array. 
  }
  
  
}