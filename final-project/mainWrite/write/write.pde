PrintWriter freq;
PrintWriter amp;

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;

Minim minim;
AudioPlayer in;
//AudioInput in;
FFT fft;
int sampleRate = 44100;
float [] max = new float [sampleRate/2];//array that contains the half of the sampleRate size, because FFT only reads the half of the sampleRate frequency. This array will be filled with amplitude values.
float maximum;//the maximum amplitude of the max array

//calculate width from milimeters
float dpi = 300;
float a4_w = 297;
float a4_h = 210;
float mm2px(float mm_value, float dpi) {
  return mm_value/25.4*dpi;
}

void setup()
{
  freq = createWriter("freq.txt");
  amp = createWriter("amp.txt");
  
  size(400, 400);
  colorMode(HSB, 360, 100, 100);
  background(0);
  
  frameRate(30);

  minim = new Minim(this);
  in = minim.loadFile("song1.mp3");
  in.play();
  //in = minim.getLineIn(Minim.STEREO, 512);
  fft = new FFT(in.bufferSize(), in.sampleRate());



}

void draw()
{    
  float frequency = getFrequency()[0];
  float amplitude = getFrequency()[1];
  freq.println(frequency+' ');
  amp.println(amplitude+' ');  
}

float[] getFrequency() {
  float frequency = 0;
  fft.forward(in.left);
  for (int f=0; f<sampleRate/2; f++) { //analyses the amplitude of each frequency analysed, between 0 and 22050 hertz
    max[f]=fft.getFreq(float(f)); //each index is correspondent to a frequency and contains the amplitude value
  }
  maximum=max(max);//get the maximum value of the max array in order to find the peak of volume

  for (int i=0; i < max.length; i++) {// read each frequency in order to compare with the peak of volume
    if (max[i] == maximum) {//if the value is equal to the amplitude of the peak, get the index of the array, which corresponds to the frequency
      frequency = i;
    }
  }
  return new float[] {frequency, maximum};
  //return frequency;
}

void keyPressed() {
  if (key == 's') {
    saveFrame("output/final#####" + ".png");
  }
  if (key == 'q') {
    freq.flush(); // Writes the remaining data to the file
  freq.close(); // Finishes the file
  amp.flush(); // Writes the remaining data to the file
  amp.close(); // Finishes the file
  exit(); // Stops the program
  }
}

void stop()
{
  in.close();
  minim.stop();
  super.stop();
}