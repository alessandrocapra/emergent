import processing.net.*; //communicate with unity
import processing.serial.*; //communicate arduino
import ddf.minim.*; //sound playing
import ddf.minim.analysis.*; //sound analyses
import http.requests.*; // Library for HTTP requests: https://github.com/runemadsen/HTTP-Requests-for-Processing

//Connection to Arduino & Unity
Serial myPort;
Server myServer;

// array of available songs
AudioFile[] instruments;

// array of folders, so we can change the folder dinamically
String[] folderNames;

// spotify urls to retrieve the data
String beethoven = "3DNRdudZ2SstnDCVKFdXxG";

// function to retrieve files from the data/jazz folder (change accordingly)
String[] getAudioFilesList(String folderStr) {
  java.io.File folder = new java.io.File(dataPath(folderStr));
  // return filenames in folder
  return folder.list();
}

int[] sendData; //<--- change to number of outputs. 
int[] newData = new int[5]; //<--- how many instances do we have per instrument? Is 5 good? Should this change?

int port = 5204;

void setup() {

  myServer = new Server(this, port);

  frameRate(600); //makes it as fast as possible

  // start spotify and get refreshed token
  setupSpotify();

  // set up which folders we add to load the songs
  folderNames = new String[]{"jazz/", "suspense/", "steampunk/", "adventure/"};

  // take data from server 
  Client thisClient = myServer.available();
  
  while (thisClient == null) {
    delay(10);
    thisClient = myServer.available();
    println("Client unavailable"+"\t"+millis());
  }   

  String whatClientSaid = thisClient.readString();
  if (whatClientSaid != null) {
    println(whatClientSaid);
  } 
  int test = Integer.parseInt(trim(whatClientSaid));
  println(test);
  String song = folderNames[test];

  // load songs from folder into an array
  String[] files = getAudioFilesList(song);

  // Create as many instrument files as the number of audio files in the folder
  instruments = new AudioFile[files.length];

  // for the sendData array (global one), we want 4 elements for each instrument (Low, Mid, Hi, global)
  sendData = new int[files.length*4];

  // create a song for each file and put into array
  for (int i = 0; i < files.length; i++) {
    instruments[i] = new AudioFile(song + files[i], beethoven);
  }

  // For this array, there are methods to get the data. Some examples:
  //   instruments[i].getLocation(); --> get filename of the song
  //   instruments[i].getUrl(); --> get spotify ID

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
}

void draw() {

  // move forward all songs' FFT
  for (int i = 0; i < instruments.length; i++) {
    instruments[i].getSpectrum();
  }
  delay(2); //some delay, otherwise things fuck up

  for (int i = 0; i < instruments.length; i++) { //<--- can we do this in the class itself and save it into a global array?
    newData=instruments[i].addData(); //things we get from each instrument
    sendData[i*4+0]=newData[0]; //save it to one long array for sending 
    sendData[i*4+1]=newData[1];
    sendData[i*4+2]=newData[2];
    sendData[i*4+3]=newData[3];
  }

  for (int i=0; i<sendData.length; i++) {
    //  myPort.write(sendData[i]);  //send everything to the arduino
    myServer.write(sendData[i]); //actually send all the data to the server
  }

  println(sendData);
  delay(2); //some delay, otherwise things fuck up
}