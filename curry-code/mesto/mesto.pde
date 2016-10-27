void setup() {
  size(1280,720);
  background(0);
}

void draw() {
  
  for(int i=0; i<40; i++) {
    float num = random(50,200);
    float fn = 32;
    fill(75);
    rect(i*fn,720-num, fn, num);
    for(int j=0; j<4; j++) {
      for(int k=1; k<=num/10; k++) {
        int r = (int)random(0,4);
        noStroke();
        if (r==j) {
        fill(#ffff00);
        }
        else {
          fill(75);
        }
        rect((2+32*i)+j*8, (720-num)+(k*8), 6, 6);
      }
    }
  }
  noLoop();
}