void setupVisualization() {
  minim = new Minim(this);
  song = minim.loadFile(songs[songID][0]);
  fft = new FFT(song.bufferSize(), song.sampleRate());
  song.play();
  background(0);
}

void visualization() {
  pushMatrix();
  translate(width/2, height/2);
  rotate(i);
  i+=0.00005*energy*scoreGlobal; // <---------------------We can change this based on scoreGlobal maybe? This will recreate the speed difference as in the walls in the other example, this rotates the whole thing
  println(i);

  noFill();

  r=200; //<------------ we can change R based on something (the radius at which the balles minium i)s. 

  int nBalls = 50;
  for (int i = 0; i < nBalls; i+=1)
  {
    float x2 = (r + sum[i]*scale)*cos(i*2*PI/nBalls);
    float y2 = (r + sum[i]*scale)*sin(i*2*PI/nBalls);
    pushStyle();
    stroke(255); //<---------------------------change color of the balls maybe?
    strokeWeight(7);//<-----change size of the balls?
    point(x2, y2);
    popStyle();
  }
  popMatrix();
}