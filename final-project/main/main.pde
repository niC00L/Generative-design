// BUTTONS
//S - save frame
//L - nodes sorted in lines
//C - nodes sorted in circles
//B - nodes both in circles and lines

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;

Minim minim;
AudioPlayer in;
//AudioInput in;
FFT fft;
float frequency;
int sampleRate = 44100;
float [] max = new float [sampleRate/2];//array that contains the half of the sampleRate size, because FFT only reads the half of the sampleRate frequency. This array will be filled with amplitude values.
float maximum;//the maximum amplitude of the max array
float amplitude;

ArrayList<Node> nodesCircle = new ArrayList<Node>();
ArrayList<Node> nodesLine = new ArrayList<Node>();

float [] octaves = new float []{16, 32, 512, 2048, 8192, 16384, 32768};
float [] spectrums = new float []{60, 230, 910, 4000, 14000};

float rotation = 0.0;

void setup()
{
  size(800, 600);
  colorMode(HSB, 360, 100, 100);
  background(0);

  minim = new Minim(this);
  in = minim.loadFile("song.mp3");
  in.play();
  //in = minim.getLineIn();
  fft = new FFT(in.bufferSize(), in.sampleRate());
  
  nodesCircle = initNodesInCircle(50, 300);
  nodesCircle.addAll(initNodesInCircle(30, 200));
  
  nodesLine = initNodesInLines(20, 10);
}

ArrayList<Node> initNodesInCircle(int count, int radius) {
  ArrayList<Node> tempNodes = new ArrayList<Node>();
  PVector dirVector = new PVector(radius, 0);
  float angle = (float)360/count;  
  for (int i = 0; i <= count; i++) {    
    tempNodes.add(new Node(dirVector.x, dirVector.y, 0, 0,0));
    dirVector.rotate(radians(angle));    
  }
  return tempNodes;
}

ArrayList<Node> initNodesInLines(int xcount, int ycount) {
  ArrayList<Node> tempNodes = new ArrayList<Node>();
  float xgap = (float)width/xcount;
  float ygap = (float)height/ycount;
  for (int y = 1; y<ycount; y++) {
    for (int x = 1; x<xcount; x++) {      
      tempNodes.add(new Node(width/2-x*xgap, height/2-y*ygap, 0, 0,0));
    }
  }
  return tempNodes;
}

void draw()
{    
  frequency();
  amplitude = fft.getFreq(frequency);
  noStroke();
  fill(0, 20);
  rect(0, 0, width, height);  
  
  pushMatrix();  
    float spin = (float)(amplitude%20)/1000;
    translate(width/2, height/2);
    if (key == 'c') {
      if(frequency < 200){
        rotate((frequency/200)+rotation);
        rotation += 0.5;
      }    
      animateNodes(nodesCircle, spectrums, spin);
    } else if(key == 'l') {
      animateNodes(nodesLine, spectrums, 0);
    } else if(key == 'b') {
      animateNodes(nodesCircle, spectrums, spin);
      animateNodes(nodesLine, spectrums, 0);
    } else {  
      animateNodes(nodesCircle, spectrums, spin);
    }
  popMatrix();
}

void animateNodes(ArrayList<Node> nodes, float[] spectrum, float spin) {
   for (int i = 0; i<nodes.size(); i++) {
    int fn = i%(spectrum.length-1);
    if (spectrum[fn] < frequency && frequency < spectrum[fn+1]) {
      fill(amplitude%360, 100, 100);
      nodes.get(i).setSpeed(amplitude/100);
      nodes.get(i).setWide(amplitude/8);
      nodes.get(i).spin(spin);
    } 
    nodes.get(i).animate();
  }
}

void spectr() {
  for (int i = 0; i < fft.specSize(); i++)
  {
    line(i, height, i, height - fft.getBand(i)*4);
  }
}

class Node {
  PVector start;
  float wide;
  PVector target;
  float speed;
  PVector position;

  Node(float x, float y, float wide) {
    this.start = new PVector(x, y);
    this.position = new PVector(x, y);
    this.wide = wide;
  }

  Node(float x, float y, float wide, float targetX, float targetY) {    
    this.start = new PVector(x, y);
    this.position = new PVector(x, y);
    this.wide = wide;
    this.target = new PVector(targetX, targetY);
  }

  Node(float x, float y, float wide, float targetX, float targetY, float speed) {    
    this.start = new PVector(x, y);
    this.position = new PVector(x, y);
    this.wide = wide;
    this.target = new PVector(targetX, targetY);
    this.speed = speed;
  }

  void setWide(float wide) {
    this.wide = wide;
  }
  
  void setPosition(PVector position) {
    this.position = position;
  }

  void setTarget(PVector target) {
    this.target = target;
  }

  void setSpeed(float speed) {
    this.speed = speed;
  }

  void render() {
    PVector start = new PVector();
    start.x = this.position.x-(wide/2);
    start.y = this.position.y-(wide/2);
    ellipse(start.x, start.y, wide, wide);
  }

  void animate() {
    float dist = this.position.dist(this.target);
    if (dist < this.wide) {
      PVector temp = this.start;
      this.start = this.target;
      this.target = temp;
    }
    PVector dirVector = new PVector((this.target.x - this.start.x), (this.target.y - this.start.y)).normalize();
    this.position.x += dirVector.x*speed;
    this.position.y += dirVector.y*speed;
    ellipse(this.position.x, this.position.y, wide, wide);
  }
  
  void spin(float speed) {
    this.position.rotate(speed);
    this.target.rotate(speed);
    this.start.rotate(speed);
  }
}

void frequency() {
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
}

void keyPressed() {
  if (key == 's') {
    saveFrame("frame#####" + ".png");
  }  
}

void stop()
{
  in.close();
  minim.stop();
  super.stop();
}