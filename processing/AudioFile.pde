class AudioFile {
  
  private String location;
  private String spotifyUrl;
  
  // constructor
  AudioFile(String location, String spotifyUrl){
    this.location = location;
    this.spotifyUrl = spotifyUrl;
  }
  
  // setters
  void setLocation(String location){
    this.location = location;
  }
  
  void setSpotifyUrl(String url){
    spotifyUrl = url;
  }
  
  // getters
  String getLocation(){
    return this.location;
  }
  
  String getUrl(){
    return this.spotifyUrl;
  }
}