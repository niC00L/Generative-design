int buildings = 40;
float[] heights = new float[buildings];
//int[] windows = new int[];
float bWidth = 32;
int r;
void setup() {
  size(1280, 680);
  background(0);
  for (int i=0; i<buildings; i++) {
    heights[i] = random(50, 200);
  }
}

void draw() {
  moon();
  for (int i=0; i<buildings; i++) {
    float num = heights[i];
    fill(75);
    rect(i*bWidth, height-num, bWidth, num);

    for (int j=0; j<4; j++) {
      for (int k=1; k<num/9; k++) {
        //if (frameCount%100 == 0) {
        r = (int)random(0, 4);
        //}
        noStroke();
        if (r==j) {
          fill(#ffff00);
        } else {
          fill(75);
        }

        rect((2+bWidth*i)+j*8, (height-num)+(k*8), 6, 6);
      }
    }
  }
  
  
}

void moon() {
  int offset = 100;
  //fill(0);
  //rect(0,0,width, height);
  background(0);
  
  pushMatrix();
  
  translate(width/2, height);
  rotate(-frameCount/150.0);
  fill(255);  
  ellipse(width/3+offset, 0, 100, 100);
  
  fill(#ffff00);
  //filter(BLUR, 5);
  ellipse(-width/3-offset, 0, 500, 500);
  //filter(BLUR, 0);
  ellipse(-width/3-offset, 0, 200, 200);
  fill(0);  
  popMatrix();
}