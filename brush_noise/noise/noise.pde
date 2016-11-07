PImage img;

void setup() {
  size(1280,720);
  background(255);
  smooth();
  img = loadImage("JaketheDog.png");
}

void draw() {
  //background(255);
  float x = noise(frameCount/80.0)*width;
  float y = noise(frameCount/160.0)*height;
  //tint(0,150, 210);
  image(img, x,y);
}

void keyPressed() {
  if ( key == 's' || key == 'S' ) {
      saveFrame("random-####.png");
  }
}