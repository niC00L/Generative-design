void setup() {
  background(100);
  size(1280, 720);
  smooth();

  printArray(PFont.list());

  PFont myFont = createFont("Stencil", 200);
  textFont(myFont);
}

void draw() {
  background(100);
  fill(210, 50);  
  textSize(100);
  textLeading(50);
  float tWidth = textWidth("42 42 42");
  text("42 42 42", width/2, height/2,tWidth, height/4);
}

void keyPressed() {
  if (key == 's') {
    saveFrame("sketch-####.png");
  }
}