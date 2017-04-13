import processing.net.*;
import processing.serial.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import http.requests.*; // Library for HTTP requests: https://github.com/runemadsen/HTTP-Requests-for-Processing

Serial myPort;
Server myServer;
// array of available songs
AudioFile[] instruments = new AudioFile[17];

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
int[] newData = new int[5];

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
    instruments[i] = new AudioFile(files[i], beethoven);
  }

  for (int j = 0; j < instruments.length; j++) {
    //println(songs[j].getLocation());
  }

  //println(songs[10].getLocation());
  //println(songs[0].getUrl());

  //println("Song list: \n");
  //for(int x = 0; x < songs.length; x++){
  //  println("Position " + x + ": " + songs[x].getLocation());
  //}

  // prepare all songs' FFT
  for (int i = 0; i < instruments.length; i++) {
    instruments[i].startFFT();
  }

  // play all of 'em
  for (int i = 0; i < instruments.length; i++) {
    instruments[i].play();
  }
  // myPort = new Serial(this, Serial.list()[0], 115200);
  myServer = new Server(this, 5204); 
}

void draw() {

  // move forward all songs' FFT
  for (int i = 0; i < instruments.length; i++) {
    instruments[i].getSpectrum();
  }
  delay(2);

  for (int i = 0; i < instruments.length; i++) {
    newData=instruments[i].addData(); //<---still fix this into one long array.
    sendData[i*5+0]=newData[0];
    sendData[i*5+1]=newData[1];
    sendData[i*5+2]=newData[2];
    sendData[i*5+3]=newData[3];
    sendData[i*5+4]=newData[4];
  }
  
  for (int i=0; i<sendData.length; i++){
   myPort.write(sendData[i]); 
   myServer.write(sendData[i]); 
  }
  
  println(sendData);
  delay(2);
}