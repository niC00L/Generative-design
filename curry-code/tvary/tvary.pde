int count = 8;
int sides = 4;
int len = 500;
int gap = 5;

float cnt = count;

void setup() {
  size(1280, 720);
  smooth();
}

void draw() {
  pushMatrix();
  translate(width/2, height/2);
  rotate(frameCount / 3);
  
  for (int i = 0; i < cnt; i++) {
    line(0 - len/2, 0 - len/2 + gap * i, 0 + len/2, 0 + len/2  + gap * i);
  }
  popMatrix();
  
  //cnt = count;
}



void keyPressed() {
  if (key == 's') {
    saveFrame("sketch-####.png");
  }
}