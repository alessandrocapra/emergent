import processing.net.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
// Library for HTTP requests: https://github.com/runemadsen/HTTP-Requests-for-Processing
import http.requests.*;

//song selection
String[][] songs = { //filename, spotifythingy
  {"../data/19 - Drink Up Me Hearties.mp3", "0HewdQ1l9bckQXPfIO3CYH"}, 
  {"../data/05 - Elements.mp3", "1jrFczYf5NysHccOQPXnNP"}, 
  {"../data/Coldplay - The Scientist .mp3", "75JFxkI2RXiU7L9VXzMkle"}, 
  {"../data/07 Snow Patrol - Just Say Yes.mp3", "6JJobJT994GijrdaiRg4aB"},
  {"../data/17 - Time.mp3","6ZFbXIJkuI1dVNWvzJzown"}
};

int songID=4; //change for different songs

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
float danceability;

//Variable for visualization
Minim minim;
AudioPlayer song;
FFT fft;

int  r = 200;//orig=200
float rad = 70;//orig=70

int bands = 2048;

float[] sum = new float[bands];
float smooth_factor = 0.2;
float scale=2;

void setup() {
  fullScreen();
  setupVisualization();
  setupSpotify();
  getSpotifyData();
  println("danceability: "+ danceability+"\t"+"tempo: " + tempo+"\t"+"energy: "+energy+"\t"+"key: "+musicKey+"\t"+"loudness: " + loudness+"\t"+"mode: "+mode+"\t"+"valence: "+valence);
  smooth_factor=1-valence;
  scale=scale*energy;
}
void draw() {
  visualization();
}