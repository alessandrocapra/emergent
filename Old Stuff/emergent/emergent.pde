import processing.net.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import http.requests.*; // Library for HTTP requests: https://github.com/runemadsen/HTTP-Requests-for-Processing

//song selection
String[][] songs = { //filename, spotifythingy
  {"../data/19 - Drink Up Me Hearties.mp3", "0HewdQ1l9bckQXPfIO3CYH"}, 
  {"../data/05 - Elements.mp3", "1jrFczYf5NysHccOQPXnNP"}, 
  {"../data/Coldplay - The Scientist .mp3", "75JFxkI2RXiU7L9VXzMkle"}, 
  {"../data/07 Snow Patrol - Just Say Yes.mp3", "6JJobJT994GijrdaiRg4aB"}, 
  {"../data/17 - Time.mp3", "6ZFbXIJkuI1dVNWvzJzown"}
};

int songID=0; //change for different songs

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

void setup() {
  fullScreen(P3D);
  frameRate(30);
  setupVisualization();
  setupSpotify();
  getSpotifyData();
  println("danceability: "+ danceability+"\t"+"tempo: " + tempo+"\t"+"energy: "+energy+"\t"+"key: "+musicKey+"\t"+"loudness: " + loudness+"\t"+"mode: "+mode+"\t"+"valence: "+valence);
  smooth_factor=energy*valence; //<------------ has influence on the smoothness of the movements
  scale=scale*energy; //<--------- has influence on the amplitude of the balls
  backgroundColor=color(255*valence, 255*valence, 255*valence);
}

////////////////////////////////////////////////////////////////////////////////////////////////

// Variables qui définissent les "zones" du spectre
// Par exemple, pour les basses, on prend seulement les premières 4% du spectre total
float specLow = 0.03; // 3%
float specMid = 0.125;  // 12.5%
float specHi = 0.20;   // 20%

// Il reste donc 64% du spectre possible qui ne sera pas utilisé. 
// Ces valeurs sont généralement trop hautes pour l'oreille humaine de toute facon.

// Valeurs de score pour chaque zone
float scoreLow = 0;
float scoreMid = 0;
float scoreHi = 0;

// Valeur précédentes, pour adoucir la reduction
float oldScoreLow = scoreLow;
float oldScoreMid = scoreMid;
float oldScoreHi = scoreHi;

// Valeur d'adoucissement
float scoreDecreaseRate = 25;

// Cubes qui apparaissent dans l'espace
int nbCubes;
Cube[] cubes;

//Lignes qui apparaissent sur les cotés
int nbMurs = 500;
Mur[] murs;
 
void setup()
{
  //Faire afficher en 3D sur tout l'écran
  fullScreen(P3D);
 
  //Charger la librairie minim
  minim = new Minim(this);
 
  //Charger la chanson
  song = minim.loadFile("song.mp3");
  
  //Créer l'objet FFT pour analyser la chanson
  fft = new FFT(song.bufferSize(), song.sampleRate());
  
  //Un cube par bande de fréquence
  nbCubes = (int)(fft.specSize()*specHi);
  cubes = new Cube[nbCubes];
  
  //Autant de murs qu'on veux
  murs = new Mur[nbMurs];

  //Créer tous les objets
  //Créer les objets cubes
  for (int i = 0; i < nbCubes; i++) {
   cubes[i] = new Cube(); 
  }
  
  //Créer les objets murs
  //Murs gauches
  for (int i = 0; i < nbMurs; i+=4) {
   murs[i] = new Mur(0, height/2, 10, height); 
  }
  
  //Murs droits
  for (int i = 1; i < nbMurs; i+=4) {
   murs[i] = new Mur(width, height/2, 10, height); 
  }
  
  //Murs bas
  for (int i = 2; i < nbMurs; i+=4) {
   murs[i] = new Mur(width/2, height, width, 10); 
  }
  
  //Murs haut
  for (int i = 3; i < nbMurs; i+=4) {
   murs[i] = new Mur(width/2, 0, width, 10); 
  }
  
  //Fond noir
  background(0);
  
  //Commencer la chanson
  song.play(0);
}
 
void draw()
{
  //Faire avancer la chanson. On draw() pour chaque "frame" de la chanson...
  fft.forward(song.mix);
  
  //Calcul des "scores" (puissance) pour trois catégories de son
  //D'abord, sauvgarder les anciennes valeurs
  oldScoreLow = scoreLow;
  oldScoreMid = scoreMid;
  oldScoreHi = scoreHi;
  
  //Réinitialiser les valeurs
  scoreLow = 0;
  scoreMid = 0;
  scoreHi = 0;
 
  //Calculer les nouveaux "scores"
  for(int i = 0; i < fft.specSize()*specLow; i++)
  {
    scoreLow += fft.getBand(i);
  }
  
  for(int i = (int)(fft.specSize()*specLow); i < fft.specSize()*specMid; i++)
  {
    scoreMid += fft.getBand(i);
  }
  
  for(int i = (int)(fft.specSize()*specMid); i < fft.specSize()*specHi; i++)
  {
    scoreHi += fft.getBand(i);
  }
  
  //Faire ralentir la descente.
  if (oldScoreLow > scoreLow) {
    scoreLow = oldScoreLow - scoreDecreaseRate;
  }
  
  if (oldScoreMid > scoreMid) {
    scoreMid = oldScoreMid - scoreDecreaseRate;
  }
  
  if (oldScoreHi > scoreHi) {
    scoreHi = oldScoreHi - scoreDecreaseRate;
  }
  
  //Volume pour toutes les fréquences à ce moment, avec les sons plus haut plus importants.
  //Cela permet à l'animation d'aller plus vite pour les sons plus aigus, qu'on remarque plus
  float scoreGlobal = 0.66*scoreLow + 0.8*scoreMid + 1*scoreHi;
  
  //Couleur subtile de background
  background(scoreLow/100, scoreMid/100, scoreHi/100);
   
  //Cube pour chaque bande de fréquence
  for(int i = 0; i < nbCubes; i++)
  {
    //Valeur de la bande de fréquence
    float bandValue = fft.getBand(i);
    
    //La couleur est représentée ainsi: rouge pour les basses, vert pour les sons moyens et bleu pour les hautes. 
    //L'opacité est déterminée par le volume de la bande et le volume global.
    cubes[i].display(scoreLow, scoreMid, scoreHi, bandValue, scoreGlobal);
  }
  
  //Murs lignes, ici il faut garder la valeur de la bande précédent et la suivante pour les connecter ensemble
  float previousBandValue = fft.getBand(0);
  
  //Distance entre chaque point de ligne, négatif car sur la dimension z
  float dist = -25;
  
  //Multiplier la hauteur par cette constante
  float heightMult = 2;
  
  //Pour chaque bande
  for(int i = 1; i < fft.specSize(); i++)
  {
    //Valeur de la bande de fréquence, on multiplie les bandes plus loins pour qu'elles soient plus visibles.
    float bandValue = fft.getBand(i)*(1 + (i/50));
    
    //Selection de la couleur en fonction des forces des différents types de sons
    stroke(100+scoreLow, 100+scoreMid, 100+scoreHi, 255-i);
    strokeWeight(1 + (scoreGlobal/100));
    
    //ligne inferieure gauche
    line(0, height-(previousBandValue*heightMult), dist*(i-1), 0, height-(bandValue*heightMult), dist*i);
    line((previousBandValue*heightMult), height, dist*(i-1), (bandValue*heightMult), height, dist*i);
    line(0, height-(previousBandValue*heightMult), dist*(i-1), (bandValue*heightMult), height, dist*i);
    
    //ligne superieure gauche
    line(0, (previousBandValue*heightMult), dist*(i-1), 0, (bandValue*heightMult), dist*i);
    line((previousBandValue*heightMult), 0, dist*(i-1), (bandValue*heightMult), 0, dist*i);
    line(0, (previousBandValue*heightMult), dist*(i-1), (bandValue*heightMult), 0, dist*i);
    
    //ligne inferieure droite
    line(width, height-(previousBandValue*heightMult), dist*(i-1), width, height-(bandValue*heightMult), dist*i);
    line(width-(previousBandValue*heightMult), height, dist*(i-1), width-(bandValue*heightMult), height, dist*i);
    line(width, height-(previousBandValue*heightMult), dist*(i-1), width-(bandValue*heightMult), height, dist*i);
    
    //ligne superieure droite
    line(width, (previousBandValue*heightMult), dist*(i-1), width, (bandValue*heightMult), dist*i);
    line(width-(previousBandValue*heightMult), 0, dist*(i-1), width-(bandValue*heightMult), 0, dist*i);
    line(width, (previousBandValue*heightMult), dist*(i-1), width-(bandValue*heightMult), 0, dist*i);
    
    //Sauvegarder la valeur pour le prochain tour de boucle
    previousBandValue = bandValue;
  }
  
  //Murs rectangles
  for(int i = 0; i < nbMurs; i++)
  {
    //On assigne à chaque mur une bande, et on lui envoie sa force.
    float intensity = fft.getBand(i%((int)(fft.specSize()*specHi)));
    murs[i].display(scoreLow, scoreMid, scoreHi, intensity, scoreGlobal);
  }
}

//Classe pour afficher les lignes sur les cotés
class Mur {
  //Position minimale et maximale Z
  float startingZ = -10000;
  float maxZ = 50;
  
  //Valeurs de position
  float x, y, z;
  float sizeX, sizeY;
  
  //Constructeur
  Mur(float x, float y, float sizeX, float sizeY) {
    //Faire apparaitre la ligne à l'endroit spécifié
    this.x = x;
    this.y = y;
    //Profondeur aléatoire
    this.z = random(startingZ, maxZ);  
    
    //On détermine la taille car les murs au planchers ont une taille différente que ceux sur les côtés
    this.sizeX = sizeX;
    this.sizeY = sizeY;
  }
  
  //Fonction d'affichage
  void display(float scoreLow, float scoreMid, float scoreHi, float intensity, float scoreGlobal) {
    //Couleur déterminée par les sons bas, moyens et élevé
    //Opacité déterminé par le volume global
    color displayColor = color(scoreLow*0.67, scoreMid*0.67, scoreHi*0.67, scoreGlobal);
    
    //Faire disparaitre les lignes au loin pour donner une illusion de brouillard
    fill(displayColor, ((scoreGlobal-5)/1000)*(255+(z/25)));
    noStroke();
    
    //Première bande, celle qui bouge en fonction de la force
    //Matrice de transformation
    pushMatrix();
    
    //Déplacement
    translate(x, y, z);
    
    //Agrandissement
    if (intensity > 100) intensity = 100;
    scale(sizeX*(intensity/100), sizeY*(intensity/100), 20);
    
    //Création de la "boite"
    box(1);
    popMatrix();
    
    //Deuxième bande, celle qui est toujours de la même taille
    displayColor = color(scoreLow*0.5, scoreMid*0.5, scoreHi*0.5, scoreGlobal);
    fill(displayColor, (scoreGlobal/5000)*(255+(z/25)));
    //Matrice de transformation
    pushMatrix();
    
    //Déplacement
    translate(x, y, z);
    
    //Agrandissement
    scale(sizeX, sizeY, 10);
    
    //Création de la "boite"
    box(1);
    popMatrix();
    
    //Déplacement Z
    z+= (pow((scoreGlobal/150), 2));
    if (z >= maxZ) {
      z = startingZ;  
    }
  }
}