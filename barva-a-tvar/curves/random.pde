void setup() {
  size(720, 720);
  background(255);
  smooth();
}

void draw() {
  float x = width/2;
  float y = height/2;
  int circle = 40;
  //frameRate(30);
  fill(255, 50);
  rect(0, 0, width, height);
  curves(10, x, y);
  fill(0);
  strokeWeight(1);
  noStroke();
  ellipse(x, y, circle, circle);
}

void curves(int num, float startX, float startY) {
  noFill();
  stroke(0);
  strokeWeight(0.3);
  for (int i=1; i<random(num, num+5); i++) {
    bezier(startX, startY, random(0, width), random(0, height), random(0, width), random(0, height), startX, startY);
  }
}

void keyPressed() {
  if ( key == 's' || key == 'S' ) {
      saveFrame("random-####.png");
  }
}