void getScores() {
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
  scoreGlobal = 0.66*scoreLow + 0.8*scoreMid + 1*scoreHi;
}