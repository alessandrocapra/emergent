float[] analyzeLyrics(String song_name) {
  String[] happy = loadStrings("happy.txt");
  String[] sad = loadStrings("sad.txt");
  String[] angry = loadStrings("angry.txt");
  String[] lyrics = loadStrings(song_name+".txt");
  StringList lyrics_words = new StringList();

  float happyCounter=0;
  float sadCounter=0;
  float angryCounter=0;

  for (int i=0; i<lyrics.length; i++) {
    String[] words = split(lyrics[i], ' ');
    for (int j=0; j<words.length; j++) {
      lyrics_words.append(words[j]);
    }
  }
  for (int i=0; i<lyrics_words.size(); i++) {
    for (int j=0; j<happy.length; j++) {
      if (lyrics_words.get(i).equals(happy[j])) {
        happyCounter++;
        break;
      }
    }
    for (int j=0; j<sad.length; j++) {
      if (lyrics_words.get(i).equals(sad[j])) {
        sadCounter++;
        break;
      }
    }
    for (int j=0; j<angry.length; j++) {
      if (lyrics_words.get(i).equals(angry[j])) {
        angryCounter++;
        break;
      }
    }
  }

  happyCounter=happyCounter/lyrics_words.size();
  sadCounter=sadCounter/lyrics_words.size();
  angryCounter=angryCounter/lyrics_words.size();

  float[] results={happyCounter, sadCounter, angryCounter};
  return results;
}