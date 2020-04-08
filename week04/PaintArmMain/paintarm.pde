class PaintArm {
  float l1, l2;  //lengths of upper and lower arms
  float a1, a2; // angles of upper and lower arms
  float a1v, a2v, a1a, a2a;//angular velocity and acceleration of angles
  float a1aoff, a2aoff;  //the noise offset for angular accelerations
  PVector pos0; // fixed position of the center
  int state; 
  /** 
   the button state of the center
   0: not pressed
   1: hover
   2: triggered
   3: on press
   4: released
   **/
  PVector pos1, pos2; //positions of elbow and hand

  float strokeoff; //the noise offset for the stroke of the brush
  PImage currentImg;  //the image this arm is painting
  int mode; //circle mode 1 or rect mode -1
  
  PaintArm(float l1_, float l2_, float a1_, float a2_, PVector pos0_, PImage currentImg_) {
    l1 = l1_;
    l2 = l2_;
    a1 = a1_;
    a2 = a2_;
    mode = 1;
    pos0 = pos0_;
    pos1 = pos0.copy().add(l1*sin(a1), l1*cos(a1));
    pos2 = pos1.copy().add(l2*sin(a2), l2*cos(a2));
    a1aoff = random(10);
    a2aoff = random(10); 
    strokeoff = random(1);
    a1v = 0;
    a2v = 0;
    a1a = (noise(a1aoff) - 0.5)/10;
    a2a = (noise(a2aoff) - 0.5)/10;
    currentImg = currentImg_;
  }

  void display() {
    if (mode == 1)displayCircle();
    else displayRect();
  }

  void displayRect() {
    //draw the center
    pushStyle();
    noStroke();
    if (state == 1 || state == 2 || state == 3) fill(180, 50);
    else fill(255, 150);
    rectMode(CENTER);
    rect(pos0.x, pos0.y, 15, 15);
    popStyle();

    //draw the pendulum only when length is not 0;
    if (l1!=0 && l2!=0) {
      pushStyle();
      rectMode(CENTER);
      noStroke();
      fill(255, 150);
      rect(pos1.x, pos1.y, 3, 3);
      rect(pos2.x, pos2.y, 8, 8);
      stroke(255, 150);
      line(pos0.x, pos0.y, pos1.x, pos1.y); 
      line(pos1.x, pos1.y, pos2.x, pos2.y);

      if (pos2.x<width&&pos2.x>0&&pos2.y<height&&pos2.y>0) {
        canvas.beginDraw();
        canvas.noStroke();
        canvas.fill(currentImg.get(int(pos2.x), int(pos2.y)), 100);
        float strokeSize = noise(strokeoff)*map(l1, 0, width/2, 30, 60);
        strokeoff+=0.05;
        canvas.rect(pos2.x, pos2.y, strokeSize, strokeSize);
        canvas.endDraw();
      }
      popStyle();
    }
  }


  void displayCircle() {
    //draw the center
    pushStyle();
    noStroke();
    if (state == 1 || state == 2 || state == 3) fill(180, 50);
    else fill(255, 150);
    ellipse(pos0.x, pos0.y, 15, 15);
    popStyle();

    //draw the pendulum only when length is not 0;
    if (l1!=0 && l2!=0) {
      pushStyle();
      noStroke();
      fill(255, 150);
      ellipse(pos1.x, pos1.y, 3, 3);
      ellipse(pos2.x, pos2.y, 8, 8);
      stroke(255, 150);
      line(pos0.x, pos0.y, pos1.x, pos1.y); 
      line(pos1.x, pos1.y, pos2.x, pos2.y);

      if (pos2.x<width&&pos2.x>0&&pos2.y<height&&pos2.y>0) {
        canvas.beginDraw();
        canvas.noStroke();
        canvas.fill(currentImg.get(int(pos2.x), int(pos2.y)), 100);
        float strokeSize = noise(strokeoff)*map(l1, 0, width/2, 30, 60);
        strokeoff+=0.05;
        canvas.ellipse(pos2.x, pos2.y, strokeSize, strokeSize);
        canvas.endDraw();
      }
      popStyle();
    }
  }
  void update() {
    //dragging the center
    if (state == 3)pos0.set(mouseX, mouseY);
    checkState();

    //update only when lengths aren't 0 for better performence
    if (l1!=0 && l2!=0) {
      updateAcceleration();
      updateVelocity();
      updatePosition();
      if (abs(a1v) > PI/20)a1v/=5;
      if (abs(a2v) > PI/20)a2v/=5;
      pos1.set(pos0.x+l1*sin(a1), pos0.y+l1*cos(a1));
      pos2.set(pos1.x+l2*sin(a2), pos1.y+l2*cos(a2));
    }
  }

  void updateVelocity() {
    a1v+=a1a;
    a2v+=a2a;
  }
  void updatePosition() {
    a1+=a1v;
    a2+=a2v;
  }
  void updateAcceleration() {
    a1aoff += 0.005;
    a2aoff += 0.01;
    a1a = (noise(a1aoff) - 0.5)/100;
    a2a = (noise(a2aoff) - 0.5)/100;
  }

  void extendArm(float i) {
    //the length should be in between width/2 and 0
    l1=min(max(0, l1+i), width/2); 
    l2=min(max(0, l2+i), width/2);
  }
  void setCurrent(PImage img) {
    currentImg = img;
  }


  boolean checkHover() {
    return (dist(mouseX, mouseY, pos0.x, pos0.y)<7.5);
  }
  void checkState() {
    switch (state) {
    case 0:
      if (checkHover()) {
        state = 1;
      }
      break;
    case 1:
      if (mousePressed) {
        state = 2;
      } else if (!checkHover()) {
        state = 0;
      }
      break;
    case 2:
      if (mousePressed) {
        state = 3;
      } else {
        state = 4;
      }
      break;
    case 3:
      //when on press, both release & mouving off will release it
      if (!mousePressed || !checkHover() ) {
        state = 4;
      }
      break;
    case 4: 
      if (checkHover()) {
        state = 1;
      } else {
        state = 0;
      }
      break;
    }
  }
}