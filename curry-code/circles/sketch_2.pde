float frame;

void setup(){
  size(800, 600);
}

void draw(){
  background(0);
  stroke(210);    
  frame = map(sin(frameCount / 50.0), -1.0 , 1.0 , 1, 4.0);   
  
  
  for(int i = 0; i < 10;i++)
    circles();
      
  saveFrame("screen-####.png");
}


void keyPressed(){  
  if(key == 's'){
    saveFrame("screen-####.png");
  }
}

void circles() {
  pushMatrix();
    translate(width/2, height/2);
    scale(frame);
    
    for(int i = 50;i >= 0; i-=10){
      fill(random(0, 255), random(0, 255) , random(0, 255));
      ellipse(0, 0, 50 + i, 50 + i);
    }
    popMatrix(); 
}