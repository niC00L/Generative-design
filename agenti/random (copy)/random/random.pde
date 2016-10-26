// P_2_2_4_01.pde
// 
// Generative Gestaltung, ISBN: 978-3-87439-759-9
// First Edition, Hermann Schmidt, Mainz, 2009
// Hartmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni
// Copyright 2009 Hartmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni
//
// http://www.generative-gestaltung.de
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/**
 * limited diffusion aggregation 
 * 
 * KEYS
 * s                   : save png
 * p                   : save pdf
 */

import processing.pdf.*;
import java.util.Calendar;

boolean savePDF = false;

int maxCount = 1000; //max count of the cirlces
int currentCount = 1;
float[] x = new float[maxCount];
float[] y = new float[maxCount];
float[] r = new float[maxCount]; // radius

void setup() {
  size(600,600);
  smooth();
  //frameRate(10);

  // first circlex
  x[0] = width/2;
  y[0] = height/2;
  r[0] = 10;
  //r[0] = 400; 
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
  float newX = random(0+newR, width-newR);
  float newY = random(0+newR, height-newR);

  float closestDist = 100000000;
  int closestIndex = 0;
  // which circle is the closest?
  for(int i=0; i < currentCount; i++) {
    float newDist = dist(newX,newY, x[i],y[i]);
    if (newDist < closestDist) {
      closestDist = newDist;
      closestIndex = i; 
    } 
  }

  // show random position and line
   //fill(230);
   //ellipse(newX,newY,newR*2,newR*2); 
   //line(newX,newY,x[closestIndex],y[closestIndex]);

  // aline it to the closest circle outline
  float angle = atan2(newY-y[closestIndex], newX-x[closestIndex]);

  x[currentCount] = x[closestIndex] + cos(angle) * (r[closestIndex]+newR);
  y[currentCount] = y[closestIndex] + sin(angle) * (r[closestIndex]+newR);
  r[currentCount] = newR;
  currentCount++;
println(x, y);
  // draw them
  for (int i=0 ; i < currentCount-1; i++) {
    stroke(0);    
    
    //original circle
    bolt.lightning(new PVector(x[i],y[i]), new PVector(x[i+1], y[i+1]));
  }

  if (currentCount >= maxCount) noLoop();

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
    for(int i=0; i<branches; i++) {      
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