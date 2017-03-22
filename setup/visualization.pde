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
  pushMatrix();
  translate(width/2, height/2);

  //draw the centre beat circel
  noStroke();
  for (int i = 0; i < bands; i+=1) {
    sum[i] += (fft.getBand(i) - sum[i]) * smooth_factor;
  }

  //draw the vertices and points
  beginShape();
  noFill();
  stroke(255, 50);

  for (int i = 0; i < 50; i+=2)
  {
    float x2 = (r + sum[i]*scale)*cos(i*2*PI/50);
    float y2 = (r + sum[i]*scale)*sin(i*2*PI/50);
    vertex(x2, y2);
    pushStyle();
    stroke(255);
    strokeWeight(10);//orig=2
    point(x2, y2);
    popStyle();
  }
  vertex((r + sum[0]*scale)*cos(0*2*PI/bands), (r + sum[0]*scale)*sin(0*2*PI/bands));
  endShape();
  popMatrix();


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
  // Line walls, here you must keep the value of the previous band and the next one to connect them together
  float previousBandValue = sum[0];

  //Distance between each line point, negative because on the dimension z
  float dist = -25;

  //Multiply the height by this constant
  float heightMult = 2;

  for (int i = 1; i < sum.length; i++)
  {
    //Frequency band value, the farther bands are multiplied so that they are more visible.
    float bandValue = sum[i]*(1 + (i/50));

    //Selection of color according to the strengths of the different types of sounds
    strokeWeight(1 + (scoreGlobal/100));

    //Left lower line
    line(0, height-(previousBandValue*heightMult), dist*(i-1), 0, height-(bandValue*heightMult), dist*i);
    line((previousBandValue*heightMult), height, dist*(i-1), (bandValue*heightMult), height, dist*i);
    line(0, height-(previousBandValue*heightMult), dist*(i-1), (bandValue*heightMult), height, dist*i);

    //left upper line
    line(0, (previousBandValue*heightMult), dist*(i-1), 0, (bandValue*heightMult), dist*i);
    line((previousBandValue*heightMult), 0, dist*(i-1), (bandValue*heightMult), 0, dist*i);
    line(0, (previousBandValue*heightMult), dist*(i-1), (bandValue*heightMult), 0, dist*i);

    //Right lower line
    line(width, height-(previousBandValue*heightMult), dist*(i-1), width, height-(bandValue*heightMult), dist*i);
    line(width-(previousBandValue*heightMult), height, dist*(i-1), width-(bandValue*heightMult), height, dist*i);
    line(width, height-(previousBandValue*heightMult), dist*(i-1), width-(bandValue*heightMult), height, dist*i);

    //Right upper line
    line(width, (previousBandValue*heightMult), dist*(i-1), width, (bandValue*heightMult), dist*i);
    line(width-(previousBandValue*heightMult), 0, dist*(i-1), width-(bandValue*heightMult), 0, dist*i);
    line(width, (previousBandValue*heightMult), dist*(i-1), width-(bandValue*heightMult), 0, dist*i);

    //Save the value for the next loop round
    previousBandValue = bandValue;
  }
  for (int i = 0; i < nbMurs; i++)
  {
    //Each wall is assigned a band, and its force is sent to it.
    float intensity = sum[i%((int)(sum.length*specHi))];
    murs[i].display(scoreLow, scoreMid, scoreHi, intensity, scoreGlobal);
  }
}

class Mur {
  // Minimum and maximum position of Z
  float startingZ = -10000;
  float maxZ = 50;

  //position values
  float x, y, z;
  float sizeX, sizeY;

  //Constructor
  Mur(float x, float y, float sizeX, float sizeY) {
    //Make the line appear at the specified location
    this.x = x;
    this.y = y;
    // Random Depth
    this.z = random(startingZ, maxZ);  


    // The size is determined because the walls on the floors have a different size than those on the sides
    this.sizeX = sizeX;
    this.sizeY = sizeY;
  }
  void display(float scoreLow, float scoreMid, float scoreHi, float intensity, float scoreGlobal) {
    // Color determined by low, medium and high sounds
    // Opacity determined by the global volume
    color displayColor = color(scoreLow*0.67, scoreMid*0.67, scoreHi*0.67, scoreGlobal);

    //Make lines disappear in the distance to give an illusion of fog
    fill(displayColor, ((scoreGlobal-5)/1000)*(255+(z/25)));
    noStroke();

    // First band, that which moves according to the force
    // Transformation matrix
    pushMatrix();

    //movement
    translate(x, y, z);

    //enlargement
    if (intensity > 100) intensity = 100;
    scale(sizeX*(intensity/100), sizeY*(intensity/100), 20);

    //Creating the "box"
    box(1);
    popMatrix();

    //Second band, the one that is always the same size
    displayColor = color(scoreLow*0.5, scoreMid*0.5, scoreHi*0.5, scoreGlobal);
    fill(displayColor, (scoreGlobal/5000)*(255+(z/25)));
    //Transformation matrix
    pushMatrix();

    //movement
    translate(x, y, z);

    //enlargement
    scale(sizeX, sizeY, 10);

    //creation of box
    box(1);
    popMatrix();

    //Z movement
    z+= (pow((scoreGlobal/150), 2));
    if (z >= maxZ) {
      z = startingZ;
    }
  }
}