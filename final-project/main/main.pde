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
float amplitude;

ArrayList<Square> squares = new ArrayList<Square>();
int [] octaves = new int []{16, 32, 512, 2048, 8192, 16384, 32768};
int [] spectrum = new int []{60, 230, 910, 4000, 14000};

void setup()
{
  size(800, 600);
  colorMode(HSB, 360, 100, 100);
  background(0);

  minim = new Minim(this);
  in = minim.getLineIn();
  fft = new FFT(in.bufferSize(), in.sampleRate());
  
  initSquaresInCircle(50, 300);
  initSquaresInCircle(30, 200);
  
  //initSquaresInLines(30, 20);
}

void initSquaresInCircle(int count, int radius) {
  PVector dirVector = new PVector(radius, 0);
  float angle = (float)360/count;  
  for (int i = 0; i <= count; i++) {    
    squares.add(new Square(dirVector.x, dirVector.y, 0, 0,0));
    dirVector.rotate(radians(angle));    
  }
}

void initSquaresInLines(int xcount, int ycount) {
  float xgap = width/xcount;
  float ygap = height/ycount;
  for (int y = 1; y<ycount; y++) {
    for (int x = 1; x<xcount; x++) {      
      squares.add(new Square(width/2-x*xgap, height/2-y*ygap, 0, 0,0));
    }
  }
}

void draw()
{  
  float amplitude = fft.getFreq(frequency);
  frequency();
  noStroke();
  fill(0, 20);
  rect(0, 0, width, height);  
  
  println(frameCount/100.0);
  pushMatrix();  
  translate(width/2, height/2);
  //rotate((frameCount/200.0));
  rotate((amplitude/300.0)*(frameCount/100.0));
  for (int i = 0; i<squares.size(); i++) {
    int fn = i%(spectrum.length-1);
    if (spectrum[fn] < frequency && frequency < spectrum[fn+1]) {
      fill(amplitude%360, 100, 100);
      squares.get(i).setSpeed(amplitude/100);
      squares.get(i).setWide(amplitude/8);
    } 
    //fill(360);
    //squares.get(i).setWide(10);
    squares.get(i).animate();
  }
  popMatrix();
}

void spectr() {
  for (int i = 0; i < fft.specSize(); i++)
  {
    line(i, height, i, height - fft.getBand(i)*4);
  }
}

void octaves() {
  for (int i = 1; i < octaves.length; i++) {
    if (frequency >= octaves[i-1] && frequency <= octaves[i])
      squares.get(i).setWide(amplitude);
    squares.get(i).render();
    squares.get(i).setWide(0);
  }
}

void spectrum() {
  for (int i = 1; i < spectrum.length; i++) {
    if (frequency >= spectrum[i-1] && frequency <= spectrum[i])
      squares.get(i).setWide(amplitude);
    squares.get(i).render();
    squares.get(i).setWide(0);
  }
}

class Square {
  PVector start;
  float wide;
  PVector target;
  float speed;
  PVector position;

  Square(float x, float y, float wide) {
    this.start = new PVector(x, y);
    this.position = new PVector(x, y);
    this.wide = wide;
  }

  Square(float x, float y, float wide, float targetX, float targetY) {    
    this.start = new PVector(x, y);
    this.position = new PVector(x, y);
    this.wide = wide;
    this.target = new PVector(targetX, targetY);
  }

  Square(float x, float y, float wide, float targetX, float targetY, float speed) {    
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
    //rect(start.x, start.y, wide, wide);
    ellipse(start.x, start.y, wide, wide);
  }

  void animate() {
    float dist = this.position.dist(this.target);
    if (dist < 1) {
      PVector temp = this.start;
      this.start = this.target;
      this.target = temp;
    }
    PVector dirVector = new PVector((this.target.x - this.start.x), (this.target.y - this.start.y)).normalize();
    this.position.x += dirVector.x*speed;
    this.position.y += dirVector.y*speed;
    ellipse(this.position.x, this.position.y, wide, wide);
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
  in.close();
  minim.stop();
  super.stop();
}