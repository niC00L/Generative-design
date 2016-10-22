void setup() {
  size(1280, 720);
  background(0);
}

void draw() {
  frameRate(25);
  fill(0, 70);
  rect(0, 0, width, height);
  int midX = width/2;
  int midY = height/2;
  stroke(255);
  lines(5, midX, midY);
}

void lines(int num, float midX, float midY) {
  for (int i=1; i<=num; i++) {
    float x = midX+random(-200, 200);
    float y = midY+random(-200, 200);
    line(midX, midY, x, y);
    fill(random(255), random(255), random(255));
    float r = 8*random(5);
    ellipse(x, y, r, r);
  }
}

void keyPressed() {
  if (key == 's') {
    saveFrame("sketch-####.png");
  }
}