import processing.net.*;

// Library for HTTP requests: https://github.com/runemadsen/HTTP-Requests-for-Processing
import http.requests.*;

// Client clientToken; 
String data;
String newToken;

// Keys to authorize the app through Spotify
String authorizationKey;
String refreshToken;

String requestSong = "https://api.spotify.com/v1/audio-features/";
JSONObject json;
JSONObject jsonSong;

// Variables we're interested in saving from the JSON
float tempo;
float energy;
int musicKey;
float loudness;
int mode;
float valence;


//Variable for visualization
import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer song;
AudioMetaData meta;
BeatDetect beat;
FFT fft;

int  r = 200;//orig=200
float rad = 70;//orig=70

int bands = 1024;

float[] sum = new float[bands];
float smooth_factor = 0.2;
float scale=20;


void setup() {
  fullScreen();
  setupVisualization();
  setupSpotify();
  getSpotifyData();
  println("tempo: " + tempo+"\t"+"energy: "+energy+"\t"+"key: "+musicKey+"\t"+"loudness: " + loudness+"\t"+"mode: "+mode+"\t"+"valence: "+valence);
}
void draw() {
  visualization();
}