ArrayList<PVector> points = new ArrayList<PVector>();
PImage jake;
void setup() {
  size(500, 500);
  background(255);
  smooth();
  jake = loadImage("jakejake.jpg"); 
}

void draw() {
  image(jake, width/2-jake.width/2, height/2-jake.height/2);
  loadPixels();
  int iter = 0;
  for (int i=0; i<pixels.length; i++){
    for (int j=0; j<pixels.length; j++){      
      int clr = color(get(i,j));
      if (clr<20){
        iter++;
        if (iter%20 ==0){
          println(i,j);
          points.add(new PVector(i,j));
        }
      }
    }
  }    
  
  //noStroke();
  background(0);
  //fill(255);
  //lines();
  
  noLoop();
}

void keyPressed() {
  if ( key == 's' || key == 'S' ) {
    saveFrame("random-####.png");
  }

  if (key=='n'||key=='N') {
    background(0);
  }
}

void lines() {
    int radius = 5;
    for (int i=0; i<points.size(); i++){
      PVector point = points.get(i);
      ellipse(point.x, point.y, radius, radius);     
        stroke(255);
        strokeWeight(0);
        float fn = 5;
        if (points.size()<5){
          fn = points.size();
        }
        for (int j=points.size()-1; j>=points.size()-fn; j--) {
          PVector prev = points.get(j);
          line(prev.x, prev.y, point.x, point.y);
        }   
    }
}