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
int sampleRate = 44100;
float [] max = new float [sampleRate/2];//array that contains the half of the sampleRate size, because FFT only reads the half of the sampleRate frequency. This array will be filled with amplitude values.
float maximum;//the maximum amplitude of the max array

ArrayList<NodesGroup> nodesCircle1 = new ArrayList<NodesGroup>();
ArrayList<NodesGroup> nodesCircle2 = new ArrayList<NodesGroup>();
ArrayList<NodesGroup> nodesCircle3 = new ArrayList<NodesGroup>();

ArrayList<NodesGroup> nodesLine = new ArrayList<NodesGroup>();

//float [] spectrums = new float []{16, 32, 512, 2048, 8192, 16384, 32768};
float [] spectrum = new float []{60, 230, 910, 4000, 14000};

//calculate width from milimeters
float dpi = 300;
float a4_w = 297;
float a4_h = 210;
float mm2px(float mm_value, float dpi) {
  return mm_value/25.4*dpi;
}

void setup()
{
  frameRate(30);
  int w = ceil(mm2px(a4_w, dpi));
  int h = ceil(mm2px(a4_h, dpi));
  size(1920, 1080);
  colorMode(HSB, 360, 100, 100);
  background(0);

  minim = new Minim(this);
  in = minim.loadFile("songs/song2.mp3");
  //2, 8, 11
  in.loop();
//  in = minim.getLineIn(Minim.STEREO, 512);
  fft = new FFT(in.bufferSize(), in.sampleRate());
  println(fft);
  
  nodesCircle1 = initNodeGroupsInCircle(92, 450, spectrums.length-1);
  nodesCircle2 = initNodeGroupsInCircle(64, 320, spectrums.length-1);
  nodesCircle3 = initNodeGroupsInCircle(36, 170, spectrums.length-1);

  nodesLine = initNodeGroupsInLines(20, 10, spectrum.length);  
}

ArrayList<NodesGroup> initNodeGroupsInCircle(int count, int radius, int groups) {
  ArrayList<NodesGroup> tempNodes = new ArrayList<NodesGroup>(); //initialize temp array  
  PVector dirVector = new PVector(radius, 0);  //starting position of vectors
  float angle = (float)360/(count/groups);  //angle between nodes

  for (int g = 0; g <= groups; g++) {
    NodesGroup nodeGroup = new NodesGroup();
    for (int i = 0; i <= ceil(count/groups); i++) {  
      nodeGroup.add(new Node(dirVector.x, dirVector.y, 0, 0));
      dirVector.rotate(radians(angle));
    }
    dirVector.rotate(radians(angle/groups));
    tempNodes.add(nodeGroup);
  }
  return tempNodes;
}

ArrayList<NodesGroup> initNodeGroupsInLines(int xcount, int ycount, int groups) {
  ArrayList<NodesGroup> tempNodes = new ArrayList<NodesGroup>();  
  float xgap = (float)width/(xcount/groups);
  float ygap = (float)height/(ycount/groups);
  for (int g = 0; g < groups; g++) {
    NodesGroup nodeGroup = new NodesGroup();
    for (int y = 1; y <= ycount/groups; y++) {
      for (int x = 1; x <= xcount/groups; x++) {      
        nodeGroup.add(new Node(width/2-x*xgap, height/2-y*ygap, 0, 0));
      }
    }
    tempNodes.add(nodeGroup);
  }
  return tempNodes;
}

void draw()
{    
  float frequency = getFrequency()[0];
  float amplitude = getFrequency()[1]; 
  noStroke();
  fill(0, 25);
  rect(0, 0, width, height);  
  float nodeSpin = 0;
  if (frequency < 200) {
    nodeSpin = (float)(amplitude%30)/700;
  } 
  float nodeSpeed = amplitude/100;
  float nodeWidth = amplitude/8;
  color nodeColor = color(amplitude%360, 100, 100);
  animateGroups(nodesCircle1, nodeColor, nodeSpeed, nodeWidth, nodeSpin, frequency);
  animateGroups(nodesCircle2, nodeColor, nodeSpeed, nodeWidth, nodeSpin, frequency);
  animateGroups(nodesCircle3, nodeColor, nodeSpeed, nodeWidth, nodeSpin, frequency);
  popMatrix();
  
  //if (frameCount%30 == 0) {
    //saveFrame("output/frames/song1final#####" + ".png");
  //}

}

void animateGroups(ArrayList<NodesGroup> nodeGroups, color nodeColor, float nodeSpeed, float nodeWidth, float nodeSpin, float frequency) {
  for (int i = 0; i < spectrum.length-1; i++) {
    if (spectrum[i] < frequency && frequency < spectrum[i+1]) {
      nodeGroups.get(i).setValues(nodeColor, nodeSpeed, nodeWidth, nodeSpin);
    }
    nodeGroups.get(i).render();
  }
} 

class NodesGroup {
  ArrayList<Node> nodes;

  NodesGroup() {
    this.nodes = new ArrayList<Node>();
  }

  NodesGroup(ArrayList<Node> nodeGroup) {
    this.nodes = nodeGroup;
  }

  void add(Node node) {
    this.nodes.add(node);
  }

  Node get(int i) {
    return this.nodes.get(i);
  }

  int size() {
    return this.nodes.size();
  }

  void setValues(color c, float speed, float wide, float spin) {
    for (int i = 0; i < this.nodes.size(); i++) {
      nodes.get(i).setColor(c);
      nodes.get(i).setSpeed(speed);
      nodes.get(i).setWide(wide);
      nodes.get(i).spin(spin);
    }
  }

  void render() {
    //if (key == 's'){
    //  this.syncNodes();
    //}
    if (nodes.get(0).targetDist() <= nodes.get(0).wide*2) {
      this.syncNodes();
    }
    for (int i = 0; i < this.nodes.size(); i++) {
      nodes.get(i).animate(true);
      nodes.get(i).render();
    }
  }

  void syncNodes() {  
    PVector target = this.nodes.get(0).target;
    for (int i = 1; i < this.nodes.size(); i++) {
      if (!this.nodes.get(i).target.equals(target)) {
        return;
      }
    }
    for (int i = 0; i < this.nodes.size(); i++) {
      PVector pos = this.nodes.get(i).target.copy();
      this.nodes.get(i).setPosition(pos);
    }
  }
}

class Node {
  PVector start;
  float wide;
  PVector target;
  float speed;
  PVector position;
  color fill;

  //init node in position
  Node(float x, float y) {
    this.start = new PVector((int)x, (int)y);
    this.position = new PVector(x, y);
  }
  //init node in position with target
  Node(float x, float y, float targetX, float targetY) {    
    this.start = new PVector((int)x, (int)y);
    this.position = new PVector(x, y);
    this.target = new PVector((int)targetX, (int)targetY);
  }

  //set stuff
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

  void setColor(color fill) {
    this.fill = fill;
  }

  float targetDist() {
    return this.dist(this.target);
  }

  float dist(PVector vector) {
    return this.position.dist(vector);
  }

  //render still nodes
  void render() {    
    fill(this.fill); //each node can have different fill
    ellipse(this.position.x, this.position.y, wide, wide);
  }

  //default value for animate
  void animate() {
    animate(false);
  }

  //animate node
  void animate(boolean back) {
    int dist = (int)this.position.dist(this.target);    //distance from node to its target
    if (dist <= this.wide) {  //if node reaches target do something
      if (back) {  //if back is true, move node backward
        PVector temp = this.start.copy();  
        this.start = this.target.copy();
        this.position = this.target.copy();
        this.target = temp;
      } else {   //if back is false, teleport to starting position
        this.position = this.start.copy();
      }
    }
    //actually move node
    PVector dirVector = new PVector((this.target.x - this.start.x), (this.target.y - this.start.y)).normalize();
    this.position.x += dirVector.x*speed;
    this.position.y += dirVector.y*speed;
  }

  // rotate node 
  void spin(float speed) {
    this.position.rotate(speed);
    this.target.rotate(speed);
    this.start.rotate(speed);
  }
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
}

void stop()
{
  in.close();
  minim.stop();
  super.stop();
}
