import processing.net.*;

// Library for HTTP requests: https://github.com/runemadsen/HTTP-Requests-for-Processing
import http.requests.*;

Client clientToken; 
String data;

// Keys to authorize the app through Spotify
String authorizationKey = "MTJiOWUxY2E2ZDdiNDhiZjk1MmZjZjA4ZWJjYTZkMjQ6NDIwZGM4ZTNlYzgwNGZiZGFlM2NjZTY3NWRlZDcxYzU=";
String refreshToken = "AQA9Upmsi6JG-ojXRbOL6WyCeziiBFI6MJNIGWY8ghMfHgd1Grr6vrfKyFewsy_HlepC2A4cs-bc71NWUM5dUACDE_i5Q3kdpiVOZpyNwwkE_jrGTY_GKZrxBOlQGjn6q5w";

String requestSong = "https://api.spotify.com/v1/audio-features/";

void getTrackData() {
  // get refreshed access token
  getRefreshedAccesToken();
  
  // make request for a specific song id
  
  // 
}

void getRefreshedAccesToken(){
  clientToken = new Client(this, "https://accounts.spotify.com/api/token", 80);  // Connect to server on port 80
}

String connectToSpotify(){
  c = new Client(this, "https://api.spotify.com/v1/audio-features/1zHlj4dQ8ZAtrayhuDDmkY", 80);  // Connect to server on port 80
  c.write("GET / HTTP/1.0\n");  // Use the HTTP "GET" command to ask for a webpage
  // c.write("Host: my_domain_name.com\n\n"); // Be polite and say who we are
  
  if (c.available() > 0) {    // If there's incoming data from the client...
    data += c.readString();   // ...then grab it and print it
    //println(data);
  }
  
  return data;
}