ArrayList<PVector> points = new ArrayList<PVector>();
void setup() {
  size(1280, 720);
  background(0);
  smooth();
}

void draw() {
  noStroke();
 
  fill(255);
  lines();
}

void keyPressed() {
  if ( key == 's' || key == 'S' ) {
    saveFrame("random-####.png");
  }

  if (key=='n'||key=='N') {
    background(0);
  }
}
void circles() {
  float x = noise(mouseX*frameCount)*100 +mouseX;
  float y = noise(mouseY*frameCount)*100+mouseY;
  float radius = (pmouseX*pmouseY-mouseX*mouseY)/100;
  ellipse(x, y, radius, radius);
}

void lines() {
  if (mousePressed) {
    int radius = 10;
    if (frameCount%10==0) {
      PVector point = new PVector(mouseX, mouseY);
      points.add(point);
      //PVector point = points.get(i);
      ellipse(point.x, point.y, radius, radius);     
        stroke(255);
        strokeWeight(0);
        for (int j=0; j<points.size(); j++) {
          PVector prev = points.get(j);
          line(prev.x, prev.y, point.x, point.y);
        }
    }
  }
  
  //for (int i=0; i<points.size(); i++) {
  //  PVector point = points.get(i);
  //  ellipse(point.x, point.y, radius, radius);
  //  if (i>0) {      
  //    stroke(255);
  //    strokeWeight(0);
  //    for (int j=0; j<points.size(); j++) {
  //      PVector prev = points.get(j);
  //      line(prev.x, prev.y, point.x, point.y);
  //    }
  //  }
  //}
}