int buildings = 40;
float[] heights = new float[buildings];
//int[] windows = new int[];
float bWidth = 32;
int r;
//PGraphics sun;
void setup() {
  size(800, 400);
  background(0);
  for (int i=0; i<buildings; i++) {
    heights[i] = random(50, 200);
  }
  colorMode(HSB, 360, 100, 360, 100);
  //sun = createGraphics(400, 400, JAVA2D);  
}

void draw() {
  sky();
  for (int i=0; i<buildings; i++) {
    float num = heights[i];
    fill(75);
    rect(i*bWidth, height-num, bWidth, num);

    for (int j=0; j<4; j++) {
      for (int k=1; k<num/9; k++) {
        int r = (int)(noise(k*(j+1)*(i+1)+frameCount/50)*8); 
        noStroke();
        if (r-1==j) {
          fill(60, 100, 360);
        } else {
          fill(75);
        }
        rect((2+bWidth*i)+j*8, (height-num)+(k*8), 6, 6);
      }
    }
  }
  
  if (frameCount%2==0){
    saveFrame("mestop-####.png");
  }
}

void sky() {
  float rotateSpeed=150;
  int offset = 100;
  float lightness;
  lightness = (sin(frameCount/rotateSpeed+20))*360;
  fill(200, 55, lightness);
  rect(0, 0, width, height);
  pushMatrix();
  translate(width/2, height);
  rotate(-frameCount/rotateSpeed);
  rotate(89.9);
  fill(255);  
  ellipse(width/3+offset, 0, 100, 100);


//this is gradient around sun. It is too slow
  float b = 0;
  //fill(40, 250, b);
  int gradientRadius = 500+(frameCount/50);
  //sun.beginDraw();  
  //sun.colorMode(HSB, 360, 100, 360, 100);  
  //sun.clear();
  //for (int r = gradientRadius; r > 0; --r) {    
  //  sun.fill(200,55, 360, b);
  //  sun.ellipse(0, 0, r, r);
  //  b = (b + (1/200.0)) % gradientRadius;
  //}
  //sun.fill(60, 100, 360, 100);
  //sun.ellipse(0,0, 200, 200);
  //sun.endDraw();
  //image(sun, -width/3-offset, 0);
    
    //if (frameCount%rotateSpeed<0){
  for (int r = gradientRadius; r > 0; r--) {    
    fill(200,55, 360, b);
    ellipse(-width/3-offset, 0, r, r);
    b = (b + 1/100.0) % 360;
  }
    //}
  
  fill(60, 100, 360, 100);
  ellipse(-width/3-offset,0, 150, 150);
  fill(0);  
  popMatrix();
}