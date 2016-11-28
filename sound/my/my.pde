import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;

Minim minim;
AudioInput in;
FFT fft;
float frequency;
int sampleRate = 44100;//sampleRate of 44100
float [] max = new float [sampleRate/2];//array that contains the half of the sampleRate size, because FFT only reads the half of the sampleRate frequency. This array will be filled with amplitude values.
float maximum;//the maximum amplitude of the max array

void setup()
{
  size(512, 800);
  //background(0);
  //frameRate(30);
  //noStroke();
  colorMode(HSB, 360, 100, 100);  
  minim = new Minim(this);
  minim.debugOn();
  in = minim.getLineIn();
  fft = new FFT(in.left.size(), 44100);
}

void draw()
{  
  frequency();
  println(frequency, fft.getFreq(frequency));
  background(0);
  stroke(360);

  //if (frequency >= 20 && frequency <= 250) {
  stroke(360);
  if (frameCount%40<20) {
    AMwawe(frequency/10, fft.getFreq(frequency)%10);
  }
  //}

  //if (frequency >= 250 && frequency <= 400){
  //  wawes(100);
  //}

  //if (frequency >= 400 && frequency <= 500) {
  //  wawes(150);
  //}

  //if (frequency >= 700 && frequency <= 1000) {
  //  wawes(200);
  //}

  //for(int i = 500; i<3000; i+=500) {
  //if (frequency >= i && frequency <= i+500) {
  //  stroke(frequency%360, 100, 100);
  // AMwawe(frequency/10, fft.getFreq(frequency)%10);
  //}
  //}
  //  
  //yvalues = new float[width/5];
  //}
}

//}

//float theta = 0.0;
//float period = 500.0;
//float dx;
//float[] yvalues;

void AMwawe(float amplitude, float count) {
  float a = 0.0;
  float inc = TWO_PI/(width/(count*5));
  float prev_x = 0, prev_y = 150, x, y;

  for (int i=0; i<500; i=i+4) {
    x = i;
    y = 50 + sin(a) * (amplitude/2);
    line(prev_x, prev_y, x, y);
    prev_x = x;
    prev_y = y;
    a = a + inc;
  }

  //theta += 0.02;

  // For every x value, calculate a y value with sine function
  //float x = theta;
  //for (int i = 0; i < yvalues.length; i++) {
  //  yvalues[i] = sin(x)*amplitude;
  //  x+=dx;
  //}

  //for (int i=0; i < yvalues.length-1; i++) {
  //  line(i*count, height/2+yvalues[i],(i+1)*count, height/2+yvalues[i+1]); 
  //}
}

void wawes(float start) {
  for (int i = 0; i < in.bufferSize() - 1; i++) {
    //println(in.left.get(i)*50);
    line( i, start + in.left.get(i)*50, i+1, start + in.left.get(i+1)*50 );
    //line( i, start+50 + in.right.get(i)*50, i+1, start+50 + in.right.get(i+1)*50 );
  }
}

void frequency() {
  fft.forward(in.left);
  for (int f=0; f<sampleRate/2; f++) { //analyses the amplitude of each frequency analysed, between 0 and 22050 hertz
    max[f]=fft.getFreq(float(f)); //each index is correspondent to a frequency and contains the amplitude value
  }
  maximum=max(max);//get the maximum value of the max array in order to find the peak of volume

  for (int i=0; i <max.length; i++) {// read each frequency in order to compare with the peak of volume
    if (max[i] == maximum) {//if the value is equal to the amplitude of the peak, get the index of the array, which corresponds to the frequency
      frequency = i;
    }
  }
}

void keyPressed() {
  if (key == 's') {
    saveFrame("frame#####" + ".png");
  }
}

void stop()
{
  // always close Minim audio classes when you are done with them
  in.close();
  minim.stop();

  super.stop();
}