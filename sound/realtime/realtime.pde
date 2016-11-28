import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioInput in;
FFT fft;

color c;//color
int x, y, blue;

int sampleRate = 44100;//sampleRate of 44100

float [] max = new float [sampleRate/2];//array that contains the half of the sampleRate size, because FFT only reads the half of the sampleRate frequency. This array will be filled with amplitude values.
float maximum;//the maximum amplitude of the max array
float frequency;//the frequency in hertz

void setup()
{
  size(640, 640);
  background(0);
  frameRate(30);
  noStroke();

  minim = new Minim(this);
  minim.debugOn();
  in = minim.getLineIn(Minim.MONO, 4096, sampleRate);
  fft = new FFT(in.left.size(), sampleRate);
}

void draw()
{
  float size = 40 + frequency/50;
  float sizeX = 40 + frequency/50;
  blue = 150;
  noStroke();
  findNote(); //find note function
  
  translate(0, height);
  rotate(-PI/2);
  
  if (frequency >= 20 && frequency <= 250) {
    for (x = 0; x < width; x+=sizeX) {
      fill(x + sqrt(frequency), x/2 - size + sqrt(frequency), blue);
      rect(x, 0, sizeX, size);
      rect(x, size, sizeX, size);
    }
  }

  if (frequency >= 250 && frequency <= 400){
    for (x = -10; x < width; x+=sizeX) {
      fill(x + sqrt(frequency), x/2 - size - noise(frequency), blue);
      rect(x, size*2, sizeX, size);
      rect(x, size*3, sizeX, size);
    }
  }

  if (frequency >= 400 && frequency <= 500) {
    for (x = -20; x < width; x+=sizeX) {
      fill(x + sqrt(frequency), x/2 - size - noise(frequency), blue);
      rect(x, size*4, sizeX, size);
      rect(x, size*5, sizeX, size);
    }
  }

  if (frequency >= 500 && frequency <= 700) {
    for (x = -30; x < width; x+=sizeX) {
      fill(x + sqrt(frequency), x/2 - size - noise(frequency), blue);
      rect(x, size*6, sizeX, size);
      rect(x, size*7, sizeX, size);
    }
  }

  if (frequency >= 700 && frequency <= 1000) {
    for (x = -40; x < width; x+=sizeX) {
      fill(x + sqrt(frequency), x/2 - size - noise(frequency), blue);
      rect(x, size*8, sizeX, size);
      rect(x, size*9, sizeX, size);
    }
  }

  if (frequency >= 1000 && frequency <= 1500) {
    for (x = -30; x < width; x+=sizeX) {
      fill(x + sqrt(frequency), x/2 - size - noise(frequency), blue);
      rect(x, size*10, sizeX, size);
      rect(x, size*11, sizeX, size);
    }
  }

  if (frequency >= 1500 && frequency <= 2000) {
    for (x = -20; x < width; x+=sizeX) {
      fill(x + sqrt(frequency), x/2 - size - noise(frequency), blue);
      rect(x, size*12, sizeX, size);
      rect(x, size*13, sizeX, size);
    }
  }

  if (frequency > 2000 && frequency <= 2500) {
    for (x = -10; x < frequency; x+=sizeX) {
      fill(x + sqrt(frequency), x/2 - size - noise(frequency), blue);
      rect(x, size*14, sizeX, size);
      rect(x, size*15, sizeX, size);
    }
  }

  if (frequency >= 2500 && frequency <= 3000) {
    for (x = 0; x < width; x+=sizeX) {
      fill(x + sqrt(frequency), x/2 - size - noise(frequency-10), blue);
      rect(x, size*16, sizeX, size);
      rect(x, size*17, sizeX, size);
    }
  }

  if (frequency > 3000) {
    for (x = 0; x < width; x+=sizeX) {
      fill(x + sqrt(frequency), x/2 - size - noise(frequency), blue);
      rect(x, size*18, sizeX, size);
      rect(x, size*19, sizeX, size);
    }
  }
  
  if((frequency > 800 && frequency >= 1500)){
   stroke(255, 200);
   rect(0, random(height), width, random(height));
   rotate(random(PI));
  }

  println(frequency);
}

void findNote() {
  fft.forward(in.left);
  for (int f=0;f<sampleRate/2;f++) { //analyses the amplitude of each frequency analysed, between 0 and 22050 hertz
    max[f]=fft.getFreq(float(f)); //each index is correspondent to a frequency and contains the amplitude value
  }
  maximum=max(max);//get the maximum value of the max array in order to find the peak of volume

  for (int i=0; i <max.length; i++) {// read each frequency in order to compare with the peak of volume
    if (max[i] == maximum) {//if the value is equal to the amplitude of the peak, get the index of the array, which corresponds to the frequency
      frequency = i;
    }
  }
}

void stop()
{
  // always close Minim audio classes when you are done with them
  in.close();
  minim.stop();

  super.stop();
}

void keyPressed(){
 if(key == 's'){
   saveFrame("frame#####" + ".png");
 } 
}