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

// Variables we're interested in saving from the JSON
float tempo;
float energy;
int key;
float loudness;
int mode;
float valence;

void setup() {

  String keys[] = loadStrings("KeyToken.txt");
  authorizationKey=keys[0];
  refreshToken=keys[1];

  // First, request a new refreshed token
  PostRequest postToken = new PostRequest("https://accounts.spotify.com/api/token");

  // adding all required data and headers
  postToken.addHeader("Authorization", "Basic " + authorizationKey);
  postToken.addData("grant_type", "refresh_token");
  postToken.addData("refresh_token", refreshToken);

  postToken.send();

  println("Response Content Refresh Token: " + postToken.getContent());

  // Save new token for song request
  JSONObject json = parseJSONObject(postToken.getContent());
  if (json == null) {
    println("JSONObject could not be parsed");
  } else {
    newToken = json.getString("access_token");
  }

  ////////////////

  // Second, retrieve the song data

  // POST request
  GetRequest getSongData = new GetRequest(requestSong + "756CJtQRFSxEx9jV4P9hpA");
  getSongData.addHeader("Authorization", "Bearer " + newToken);
  getSongData.send();
  println("Response Content: " + getSongData.getContent());

  // save whatever data we want from the JSON
  JSONObject jsonSong = parseJSONObject(getSongData.getContent());
  if (jsonSong == null) {
    println("JSONObject could not be parsed");
  } else {
    tempo = jsonSong.getFloat("tempo");
    energy = jsonSong.getFloat("energy");
    key = jsonSong.getInt("key");
    loudness = jsonSong.getFloat("loudness");
    mode = jsonSong.getInt("mode");
    valence = jsonSong.getFloat("valence");
  }
}