ArrayList<PVector> points = new ArrayList<PVector>();
PImage jake;
void setup() {
  size(500, 500);
  background(0);
  smooth();
}

void draw() {
  stroke(random(255), random(255), random(255));
if (mousePressed) {
  points.add(new PVector(mouseX, mouseY));
    lines();
  }
}

void keyPressed() {
  if ( key == 's' || key == 'S' ) {
    saveFrame("random-####.png");
  }

  if (key=='n'||key=='N') {
    background(0);
  }
}

//class lines {
  
//}

void lines() {
    int radius = 5;
    for (int i=0; i<points.size(); i++){
      PVector point = points.get(i);
      ellipse(point.x, point.y, radius, radius);     
        strokeWeight(0);
        float fn = 5;
        if (points.size()<5){
          fn = points.size();
        }
        for (int j=points.size()-1; j>=points.size()-fn; j--) {
          PVector prev = points.get(j);
          line(prev.x, prev.y, point.x, point.y);
        }   
    }
}