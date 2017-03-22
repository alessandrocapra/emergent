void setupVisualization() {

  //size(600, 400);
  minim = new Minim(this);
  song = minim.loadFile(songs[songID][0]);
  fft = new FFT(song.bufferSize(), song.sampleRate());
  //song.loop();
  song.play();
  background(0);
}


void visualization() {
  fft.forward(song.mix);
  for (int i = 0; i < bands; i+=1) {
    sum[i] += (fft.getBand(i) - sum[i]) * smooth_factor;
  }
  //-----------//
  oldScoreLow = scoreLow;
  oldScoreMid = scoreMid;
  oldScoreHi = scoreHi;

  //Reset values
  scoreLow = 0;
  scoreMid = 0;
  scoreHi = 0;

  //Calculate the new "scores"
  for (int i = 0; i < sum.length*specLow; i++)
  {
    scoreLow += sum[i];
  }

  for (int i = (int)(sum.length*specLow); i < sum.length*specMid; i++)
  {
    scoreMid += sum[i];
  }

  for (int i = (int)(sum.length*specMid); i < sum.length*specHi; i++)
  {
    scoreHi += sum[i];
  }

  //Slow down the descent.
  if (oldScoreLow > scoreLow) {
    scoreLow = oldScoreLow - scoreDecreaseRate;
  }

  if (oldScoreMid > scoreMid) {
    scoreMid = oldScoreMid - scoreDecreaseRate;
  }

  if (oldScoreHi > scoreHi) {
    scoreHi = oldScoreHi - scoreDecreaseRate;
  }

  //Volume for all frequencies at this time, with higher sounds higher.
  // This allows the animation to go faster for sounds more acute, which is more noticeable
  float scoreGlobal = 0.66*scoreLow + 0.8*scoreMid + 1*scoreHi;  
  pushMatrix();
  translate(width/2, height/2);
  rotate(i);
  i+=0.0000125*scoreGlobal; // <---------------------We can change this based on scoreGlobal maybe? This will recreate the speed difference as in the walls in the other example, this rotates the whole thing
  println(i);
  
  noStroke();

  //draw the vertices and points
  beginShape();
  noFill();
  stroke(255, 50);
  
  r=200; //<------------ we can change R based on something (the radius at which the balles minium is. 
  
  for (int i = 0; i < 50; i+=2)
  {
    float x2 = (r + sum[i]*scale)*cos(i*2*PI/50);
    float y2 = (r + sum[i]*scale)*sin(i*2*PI/50);
    vertex(x2, y2);
    pushStyle();
    stroke(255); //<---------------------------change color of the balls maybe?
    strokeWeight(10);//orig=2
    point(x2, y2);
    popStyle();
  }
  vertex((r + sum[0]*scale)*cos(0*2*PI/bands), (r + sum[0]*scale)*sin(0*2*PI/bands));
  endShape();
  popMatrix();
}