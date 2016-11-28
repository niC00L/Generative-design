void setup() {
  size(500, 500);
  background(0);
  smooth();
}

void draw() {
  
}

void keyPressed() {
  if ( key == 's' || key == 'S' ) {
    saveFrame("final-####.png");
  }
}