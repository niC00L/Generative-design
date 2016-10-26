//* KEYS
//* s                   : save png
//* p                   : save pdf
//*/

import processing.pdf.*;
import java.util.Calendar;

boolean savePDF = false;

int maxCount = 500; //max count of the cirlces
int currentCount = 1;
float[] x = new float[maxCount];
float[] y = new float[maxCount];
float[] speed = new float[maxCount];
float[] r = new float[maxCount]; // radius

void setup() {
  size(600, 600);
  smooth();
  //frameRate(10);

  // first circlex
  x[0] = 0;
  y[0] = 0;
  r[0] = 10;
}

void draw() {
  Bolt bolt = new Bolt(20, 20);
  frameRate(30);
  if (savePDF) beginRecord(PDF, timestamp()+".pdf");
  background(255);

  strokeWeight(0.5);
  //noFill();

  // create a radom set of parameters
  float newR = random(1, 7);
  float newX = random(-width/2+newR, width/2-newR);
  float newY = random(-height/2+newR, height/2-newR);

  float closestDist = 100000000;
  int closestIndex = 0;
  // which circle is the closest?
  for (int i=0; i < currentCount-1; i++) {
    float newDist = dist(newX, newY, x[i], y[i]);
    if (newDist < closestDist) {
      closestDist = newDist;
      closestIndex = i;
    }
  }

  // aline it to the closest circle outline
  float angle = atan2(newY-y[closestIndex], newX-x[closestIndex]);

  x[currentCount] = x[closestIndex] + cos(angle) * (r[closestIndex]);
  y[currentCount] = y[closestIndex] + sin(angle) * (r[closestIndex]);
  r[currentCount] = newR;  
  speed[currentCount] = random(0,1);
  if (currentCount<maxCount-1){
    currentCount++;
  }
  pushMatrix();
  translate(width/2, height/2);
  //rotate(frameCount/100.0);
  // draw them
  for (int i=0; i < currentCount-1; i++) {
    stroke(0);    

    PVector start = new PVector(x[i], y[i]);
    PVector end = new PVector(x[i+1], y[i+1]);
    bolt.lightning(start.rotate((frameCount/10.0)*speed[i]), end.rotate((frameCount/10.0)*speed[i+1]));
  }
  popMatrix();

  //if (currentCount-1 >= maxCount) noLoop();
  
  if (savePDF) {
    savePDF = false;
    endRecord();
  }
}

class Bolt {
  PVector start;
  PVector end;
  //splits per 100px  
  int splits = 10;
  //noise is amount of offset at each point
  float noise = 20;

  Bolt() {
  }

  //various methods, it is simple to figure out (i think)
  Bolt(int splits, float noise) {
    this.splits = splits;
    this.noise = noise;
  }  

  Bolt(PVector start, PVector end, int splits, float noise) {
    this.start = start;
    this.end = end;
    this.splits = splits;
    this.noise = noise;
  }

  void lightning() {
    lightning(this.start, this.end, this.splits, this.noise, 0);
  }

  void lightning(PVector start, PVector end) {
    lightning(start, end, this.splits, this.noise, 0);
  }

  void lightning(float branches) {
    lightning(this.start, this.end, this.splits, this.noise, branches);
  }

  ArrayList<PVector> createPoints() {
    return createPoints(this.start, this.end, this.splits, this.noise);
  }

  //creating list of points
  ArrayList<PVector> createPoints(PVector start, PVector end, int splits, float noise) {
    ArrayList<PVector> points = new ArrayList<PVector>();
    points.add(start);
    PVector point;
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

      point = new PVector(tempEnd.x, tempEnd.y);
      points.add(point);

      //so next line starts where last one ended
      tempStart = tempEnd;
    }    
    return points;
  }

  IntList branchesPoints(float branches, int splits) {
    IntList points = new IntList();
    for (int i=0; i<branches; i++) {      
      points.append((int)random(splits));
    }
    return points;
  }

  void lightning(PVector start, PVector end, int splits, float noise, float branches) {
    ArrayList<PVector> points = createPoints(start, end, splits, noise);

    float boltLen = start.dist(end);
    float branchesPer = (float)branches/1000;
    //number of desired branches on bolt 
    branches = round(boltLen*branchesPer);    
    IntList branchesPoints = branchesPoints(branches, points.size());

    for (int i=0; i<=points.size()-2; i++) {            
      PVector tempStart = points.get(i);
      PVector tempEnd = points.get(i+1);      
      line(tempStart.x, tempStart.y, tempEnd.x, tempEnd.y);     

      if (branchesPoints.hasValue(i)) {
        PVector branchEnd = new PVector(tempEnd.x+10*random(-5, 5), tempEnd.y+10*random(-5, 5));
        lightning(tempStart, branchEnd, splits, noise, branches);
      }
    }
  }
}


void keyReleased() {
  if (key == 's' || key == 'S') saveFrame(timestamp()+"_##.png");
  if (key == 'p' || key == 'P') savePDF = true;
}

// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}