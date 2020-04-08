PImage img;

float x, y;

PVector head = new PVector();

PVector pos;
PVector vel;
PVector acc;
PVector gravity = new PVector(0, 1);

boolean highSpeed;

void setup() {
  size(500, 600);
  img = loadImage("head.png");

  pos = new PVector();
  vel = new PVector();
  acc = new PVector();

  highSpeed = false;
}

void draw() {
  background(0);
  image(img, x, y);

  float mouseX_, mouseY_;
  float mouse_x = 0;
  float mouse_y = 0;
  mouseX_ = mouse_x;
  mouse_x =  mouseX;
  mouseY_ = mouse_y;
  mouse_y = mouseY;

  float d1 = abs (mouseX_ - mouseX);
  float d2 = abs( mouseY_ - mouseY);

  //float f1 = d1/frameCount;
  //float f2 = d2/frameCount;

  //println(f1);
  //println(f2);
  println(d1);
  println(d2);

  if (d1 > 450 || d2 > 500) {
    //highSpeed = true;
    update();
    applyForce(gravity);
    display();
    checkEdges();
  }
}

void update() {
  vel.add(acc);
  pos.add(vel);
  acc.mult(0);
}

void applyForce( PVector force) {
  PVector f = force.copy();
  acc.add(f);
}

void display() {
  pushMatrix();
  pushStyle();

  x = pos.x;
  y = pos.y;

  popStyle();
  popMatrix();
}

void checkEdges() {
  if (pos.x > width) {
    pos.x = width;
    vel.x *= -1;
  } else if (pos.x < 0) {
    pos.x = 0;
    vel.x *= -1;
  }
  if (pos.y > height) {
    pos.y = height;
    vel.y *= -1;
  } else if (pos.y < 0) {
    pos.y = 0;
    vel.y *= -1;
  }
}
