PShape myShape;
PShape polygon;
void setup() {
  size(1280, 720);
  background(0);
  smooth();
}

void draw() {
  frameRate(5);
  fill(0, 25);
  rect(0, 0, width, height);

  myShape = createShape();  
  myShape.beginShape();
  for (int i = 1; i<6; i++) {
    myShape.vertex(i*random(5)*10, i*random(5)*10);
  }
  myShape.endShape(CLOSE);
  myShape.setFill(255);


  for (int i = 0; i>5; i++) {
    reg_polygon(new PVector(random(width), random(height)), 6, 200);
  }
}

void reg_polygon(PVector center, int points, float rad) {
  polygon = createShape();  
  polygon.beginShape();
  for (int i = 0; i<points; i++) {
    polygon.vertex(rad*cos(i*TWO_PI/points) + center.x, rad*sin(i*TWO_PI/points)+ center.y);
  }
  polygon.endShape(CLOSE);
  polygon.setFill(255);
  shape(polygon);
}