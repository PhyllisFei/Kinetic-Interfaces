/**
Bryn Mawr College, Department of Computer Science <br>
Fireworks are an ArrayList of Burst, each of which keep an ArrayList of Particle <br>
Click mouse to generate fireworks!
*/

ArrayList bursts;

void setup() {
  size(800, 800);
  bursts = new ArrayList();
}

void draw() {
  noStroke();
  // transparent black background
  fill(0, 45);
  rect(0, 0, width, height);

  for (int i = bursts.size() - 1; i >= 0; i--) {
    Burst b = (Burst)bursts.get(i);
    if (b.update()) bursts.remove(i);
  }
}

void mousePressed() {
  bursts.add(new Burst(mouseX, mouseY, int(random(50, 200))));
}
class Burst{
  float gravity;
  ArrayList particles;

  Burst(float x, float y, int qty){
    particles = new ArrayList();
    gravity = 0.5;
    color c = color(random(100, 255), random(100, 255), random(100, 255));

    for (int i = 0; i < qty; i++){        
      float vx = random(-20, 20);
      float vy = random(0, 20);
      if (random(1) < 0.8)
        vy *= -1.5;
      particles.add(new Particle(x, y, vx, vy, c));
    }
  }

  boolean update(){
    for (int i = particles.size() - 1; i >= 0; i--){
      Particle p = (Particle)particles.get(i);
      p.accelerate(gravity);
      if (p.update()) particles.remove(i);
    }    
    return particles.size() == 0;
  }
}

class Particle {
  float x, y;
  float vx, vy;
  color c;

  Particle(float x, float y, float vx, float vy, color c) {
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.vy = vy;
    this.c = c;
  }

  void accelerate(float a) {
    vy += a;
  }

  boolean update() {
    float px = x;
    float py = y;
    x += vx;
    y += vy;
    stroke(c); 
    line(px, py, x, y);
    return y > height || x < 0 || x > width;
  }
}