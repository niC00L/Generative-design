void setup() {
  background(100);
  size(1280, 720);
  smooth();

  PFont myFont = createFont("Stencil", 42);
  textFont(myFont);
}

String text="";

void draw() {
  background(100);
  text(text, 0, 0, width, height);
}

void keyPressed() {  
  if(key == BACKSPACE) {
    if (text.length()>0) {
      text = text.substring(0, text.length() - 1);
    }
  }
  else {
    text+=key;
  }
}