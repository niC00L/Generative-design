void setup() { //<>// //<>// //<>//
  background(255);
  size(1280, 720);
  smooth();
}

void draw() {
  frameRate(15);
  noStroke();

  triangles(10, 5);
}

void triangles(int countX, int countY) {
  float w = width/countX;
  float h = height/countY;  
  colorMode(HSB);  
  for (int i=0; i<countX; i++) {
    for (int j=0; j<countY; j++) {
      fill((360*w*j)/width, (360*h*i)/height, 143);
      triangle(w*j, h*i, w*(j+1), h*i, w*j, h*(i+1));
      fill((360*w*j)/width, (360*h*(i+1))/height, 206);
      triangle(w*j, h*(i+1), w*(j+1), h*(i+1), w*(j+1), h*i);
    }
  }
}

void keyPressed() {
  if (key == 's') {
    saveFrame("sketch-####.png");
  }
}