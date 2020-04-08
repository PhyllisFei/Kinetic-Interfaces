class Particle {
  PVector pos;
  PVector vel;

  color c;
  int pointSize;

  boolean isMatrix;

  int life;
  boolean isDead;
  
  PFont font;

  Particle(float posX, float posY, float posZ, color _c, int size, boolean matrix) {
    this.pos = new PVector(posX, posY, posZ);
    this.c = _c;
    this.life = 0;
    this.isDead = false;
    this.pointSize = size;
    this.isMatrix = matrix;
    
    if (this.isMatrix) {
       font = createFont("HeartMatrixed.ttf", this.pointSize);
       textFont(font);
    }
  }

  void update() {
    if (!this.isMatrix) {
      pos.x += random(-1, 1);
      pos.y += random(-1, 1);
      pos.z += random(-1, 1);
    } else {
      pos.y += random(0, 3);
    }
    life += 1;
    isDead = life > 5;
  }

  void display() {
    if (!isDead) {
      if (!this.isMatrix) {
        pushStyle();
        stroke(this.c);
        strokeWeight(this.pointSize);
        point(this.pos.x, this.pos.y, this.pos.z);
        popStyle();
      } else {
        pushStyle();
        
        if (this.c == color(255)) this.c = color(0, 125, 0);
        
        stroke(this.c);
        strokeWeight(this.pointSize);
        point(this.pos.x, this.pos.y, this.pos.z);
        
        popStyle();
      }
    }
  }
}
