int buildings = 40;
float[] heights = new float[buildings];
//int[] windows = new int[];
float bWidth = 32;
int r;
void setup() {
  size(680, 340);
  background(0);
  for (int i=0; i<buildings; i++) {
    heights[i] = random(50, 200);
  }
  colorMode(HSB, 360, 100, 100);
}

void draw() {
  moon();
  for (int i=0; i<buildings; i++) {
    float num = heights[i];
    fill(75);
    rect(i*bWidth, height-num, bWidth, num);

    for (int j=0; j<4; j++) {
      for (int k=1; k<num/9; k++) {
        int r = (int)(noise(k*j*i+frameCount/50)*8); 
        noStroke();
        if (r==j) {
          fill(60, 100, 100);
        } else {
          fill(75);
        }
        rect((2+bWidth*i)+j*8, (height-num)+(k*8), 6, 6);
      }
    }
  }
}

void moon() {
  float rotateSpeed=150;
  int offset = 100;
  float lightness;
  if (frameCount>rotateSpeed) {
    lightness = rotateSpeed-frameCount%rotateSpeed;
  } else { 
    lightness = frameCount;
  }
  fill(200, 55, lightness);
  rect(0, 0, width, height);
  pushMatrix();
  translate(width/2, height);
  rotate(-frameCount/rotateSpeed);
  rotate(90);
  fill(255);  
  ellipse(width/3+offset, 0, 100, 100);

//this is gradient around sun. It is too slow
  //float b = 0;
  ////fill(40, 250, b);
  //int gradientRadius = 500+(frameCount/50);
  //for (int r = gradientRadius; r > 0; --r) {
  //  fill(200,55,b);
  //  ellipse(-width/3-offset, 0, r, r);
  //  b = (b + 0.2) % gradientRadius;
  //}
  
  fill(60, 100, 100);
  ellipse(-width/3-offset, 0, 200, 200);
  fill(0);  
  popMatrix();
}