void setupVisualization() {
  
  //size(600, 400);
  minim = new Minim(this);
  song = minim.loadFile("../data/05 - Elements.mp3");
  meta = song.getMetaData();
  beat = new BeatDetect();
  fft = new FFT(song.bufferSize(), song.sampleRate());
  //song.loop();
  song.play();
  background(0);
}

void visualization() {
  fft.forward(song.mix);
  background(0);
  translate(width/2, height/2);

  //draw the centre beat circel
  noStroke();
  beat.detect(song.mix);
  fill(255, 10);
  if (beat.isOnset()) {
    rad = rad*0.9;
  } else {
    rad = 70;
  }
  ellipse(0, 0, 2*rad, 2*rad);

  //draw lines between points
  stroke(255, 50);
  for (int i = 0; i < bands - 1; i+=5) {
    sum[i] += (fft.getBand(i) - sum[i]) * smooth_factor;
    float x = (r)*cos(i*2*PI/bands);
    float y = (r)*sin(i*2*PI/bands);
    float x2 = (r + sum[i]*scale)*cos(i*2*PI/bands);
    float y2 = (r + sum[i]*scale)*sin(i*2*PI/bands);
    line(x, y, x2, y2);
  }

  //draw the vertices and points
  beginShape();
  noFill();
  stroke(255, 50);
  for (int i = 0; i < bands; i+=30)
  {
    float x2 = (r + sum[i]*scale)*cos(i*2*PI/bands);
    float y2 = (r + sum[i]*scale)*sin(i*2*PI/bands);
    vertex(x2, y2);
    pushStyle();
    stroke(255);
    strokeWeight(10);//orig=2
    point(x2, y2);
    popStyle();
  }
  endShape();
}