ArrayList<PVector> points = new ArrayList<PVector>();
PImage jake;
void setup() {
  size(500, 500);
  background(255);
  smooth();
  for (int i=0; i<50; i++) {
    points.add(new PVector(random(width), random(height)));
  }
}

void draw() {
  background(#09123B);
  for (int i=0; i<50; i++) {
    ellipse(points.get(i).x, points.get(i).y, 5, 5);
  }  
  ellipse(120,120, 50, 50);
}