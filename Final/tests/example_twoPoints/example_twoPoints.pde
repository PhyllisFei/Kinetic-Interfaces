PVector point1, point2;

void setup() {
  size(600, 700);
  point1 = new PVector(width/2, height/2);
  
}


void draw() {
  background(0);
  noStroke();
  
  point2 = new PVector(mouseX, mouseY);

  // img
  PVector vector = PVector.sub(point2, point1); 
  float distance = vector.mag();
  float angle = vector.heading();
  //float angle = atan2( vector.y, vector.x );
  println( degrees(angle) );
  
  int imgWidth = 100;
  int imgHeight = 20;

  pushMatrix();
  translate(point1.x, point1.y);
  rotate(angle);
  scale(distance/imgWidth);
  
  fill(255, 255, 0);
  rect(0, -imgHeight/2, imgWidth, imgHeight);
  popMatrix();


  // skeletion joints
  fill(255, 0, 0);
  ellipse(point1.x, point1.y, 10, 10);
  ellipse(point2.x, point2.y, 10, 10);
  stroke(255, 0, 0);
  line(point1.x, point1.y, point2.x, point2.y);
}
