import processing.net.*; //communicate with unity
import processing.serial.*; //communicate arduino
import ddf.minim.*; //sound playing
import ddf.minim.analysis.*; //sound analyses
import http.requests.*; // Library for HTTP requests: https://github.com/runemadsen/HTTP-Requests-for-Processing

//Connection to Arduino & Unity
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

int[] sendData = new int[85]; //<--- change to number of outputs. 
int[] newData = new int[5]; //<--- how many instances do we have per instrument? Is 5 good? Should this change?

void setup() {
  frameRate(600); //makes it as fast as possible

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
  //printArray(Serial.list());
  // myPort = new Serial(this, Serial.list()[0], 115200);
  myServer = new Server(this, 5204);
}

void draw() {

  // move forward all songs' FFT
  for (int i = 0; i < instruments.length; i++) {
    instruments[i].getSpectrum();
  }
  delay(2); //some delay, otherwise things fuck up

  for (int i = 0; i < instruments.length; i++) { //<--- can we do this in the class itself and save it into a global array?
    newData=instruments[i].addData(); //things we get from each instrument
    sendData[i*5+0]=newData[0]; //save it to one long array for sending 
    sendData[i*5+1]=newData[1];
    sendData[i*5+2]=newData[2];
    sendData[i*5+3]=newData[3];
    sendData[i*5+4]=newData[4];
  }

  for (int i=0; i<sendData.length; i++) {
    //  myPort.write(sendData[i]);  //send everything to the arduino
    myServer.write(sendData[i]); //actually send all the data to the server
  }

  println(sendData);
  delay(2); //some delay, otherwise things fuck up
}