PVector center;

void setup() {
  size(1280, 720);
  smooth();
  background(0);
  center = new PVector(width/2, height/2);
}

void draw() {
  noStroke();
  frameRate(30);
  fill(0, 99);
  rect(0, 0, width, height);  
  PVector mouse = new PVector(mouseX, mouseY);
  Bolt bolt = new Bolt(center, mouse, 15, 20);
  if (mousePressed) {
    bolt.lightning(1);
  }
  
  //for(int i=1; i<13; i++) {
  //  bolt.lightning(new PVector(100*i, 0), new PVector(100*i, height), 50, 20);
  //  bolt.lightning(new PVector(0, 100*i), new PVector(width, 100*i), 50, 20);
  //}
}

class Bolt {
  PVector start;
  PVector end;
  //splits per 100px  
  int splits = 10;
  //noise is amount of offset at each point
  float noise = 20;
  
  //various methods, it is simple to figure out (i think)
  Bolt(PVector start, PVector end){
    this.start = start;
    this.end = end;
  }
  
  Bolt(PVector start, PVector end, int splits){
    this.start = start;
    this.end = end;
    this.splits = splits;
  }
  
  Bolt(PVector start, PVector end, int splits, float noise){
    this.start = start;
    this.end = end;
    this.splits = splits;
    this.noise = noise;
  }
  
  void lightning() {
    lightning(0);
  }
  
  void lightning(int branches) {    
    PVector tempStart = start;
    PVector tempEnd;
    PVector offset;   
    PVector dirVector = new PVector(end.x-start.x, end.y-start.y);
    //direction vector length 
    float boltLen = start.dist(end);
    //splits per 100px
    float splitPer = (float)splits/100;
    //number of needed splits on vector 
    splits = round(boltLen*splitPer);
    
    for (int i=1; i<=splits; i++) {
      
      //direction vector always points to end
      dirVector = new PVector((end.x-tempStart.x)/(splits-i+1), (end.y-tempStart.y)/(splits-i+1));
      
      //calculating offset
      offset = new PVector(random(-0.2, 0.2)*noise, random(-0.2, 0.2)*noise);
      
      //final line leads exactly to end, with noise it can be beyond end point
      if (i==splits) {        
        tempEnd = end;
      } else {
        tempEnd = new PVector(tempStart.x+dirVector.x+offset.x, tempStart.y+dirVector.y+offset.y);
      }
      stroke(255);  
      line(tempStart.x, tempStart.y, tempEnd.x, tempEnd.y);
      
      //so next line starts where last one ended
      tempStart = tempEnd;
    }
  }
}


void keyPressed() {
  if (key == 's') {
    saveFrame("bolt-####.png");
  }
}