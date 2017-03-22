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
  background(0);
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

  for (int i = 0; i < 50; i+=1)
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
  vertex((r + sum[0]*scale)*cos(0*2*PI/bands),(r + sum[0]*scale)*sin(0*2*PI/bands));
  endShape();
}