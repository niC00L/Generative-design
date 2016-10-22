void setup() {
  background(100);
  size(1280, 720, P3D);
  smooth();

  PFont myFont = createFont("Stencil", 200);
  textFont(myFont);
}
float a = 0;
void draw() {
  fill(100, 1);
  rect(0,0,width,height);
  fill(210);  
  textSize(100);
  textLeading(50);
  
  //pushMatrix();  
  translate(width/2, height/2);
  rotate(a);
  rotateY(0.8*a);
   noFill();
   stroke(255);
  box(300);
  a+=0.01;
  
  //popMatrix();
}

void keyPressed() {
  if (key == 's') {
    saveFrame("sketch-####.png");
  }
}