void setup() {
  background(0);
  size(1280, 720);
  smooth();
}

void draw() {
  frameRate(15);
  noStroke();
  fill(0,0,0, 5);
  rect(0,0,width,height);
  fill(255);
  float ewidth = 10*random(25);  
  ellipses(1,random(width),random(height), ewidth);
}

void ellipses(int num, float midX, float midY, float r) {
  for(int i=1; i<=num; i++) {
    ellipse(midX,midY, r, r);
  }
}

void keyPressed() {
  if (key == 's') {
    saveFrame("sketch-####.png");
  }
}