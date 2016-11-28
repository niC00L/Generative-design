/**
 * Processing Sound Library, Example 6
 * 
 * This sketch shows how to use the Amplitude class to analyze a
 * stream of sound. In this case a sample is analyzed. The smoothFactor
 * variable determines how much the signal will be smoothed on a scale
 * from 0 - 1.
 */

import processing.sound.*;

// Declare the processing sound variables 
SoundFile sample;
Amplitude rms;

int bands = 512;
int numChannels = 2;
FFT[] fft = new FFT[numChannels];
AudioIn [] channels = new AudioIn[numChannels];


// Declare a scaling factor
float scale = 5.0;

// Declare a smooth factor
float smoothFactor = 0.5;

// Used for smoothing
float sum;

void setup(){
  size(640, 360);

//  //Load and play a soundfile and loop it
  

//  // Create and patch the rms tracker
  rms = new Amplitude(this);
  rms.input(sample);

  sample = new SoundFile(this, "1.aiff");
  for(int ch=0; ch<numChannels;ch++){
    channels[ch] = new AudioIn(this, ch);
    channels[ch].start();
    fft[ch] = new FFT(this, bands);
    fft[ch].input(channels[ch]);
  }
  sample.play();
}

void draw() {
  // Set background color, noStroke and fill color
  background(0, 0, 255);
  noStroke();
  fill(255, 0, 150);

  // Smooth the rms data by smoothing factor
  sum += (rms.analyze() - sum) * smoothFactor;  

  // rms.analyze() return a value between 0 and 1. It's
  // scaled to height/2 and then multiplied by a scale factor
  float rmsScaled = sum * (height/2) * scale;

  // Draw an ellipse at a size based on the audio analysis
  ellipse(width/2, height/2, rmsScaled, rmsScaled);
}