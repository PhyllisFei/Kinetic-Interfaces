import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;

Kinect2 kinect2;
PImage depthImg;
PImage colorImg;
PVector blackHolePos;

ArrayList<Particle> particles;

void setup() {
  size(1000, 800, P3D);
  setupPeasyCam();
  setupGui();
  particles = new ArrayList();
  kinect2 = new Kinect2(this);
  kinect2.initDepth();
  kinect2.initRegistered();
  kinect2.initDevice();

  blackHolePos = new PVector(0, -212, 300);

  depthImg = new PImage(kinect2.depthWidth, kinect2.depthHeight, ARGB);
}

void draw() {
  background(0);
  

  if (registeredColor) {
    colorImg = kinect2.getRegisteredImage();
    colorImg.loadPixels();
  }

  int[] rawDepth = kinect2.getRawDepth();
  int w = kinect2.depthWidth;
  int h = kinect2.depthHeight;
 
  depthImg.loadPixels();
  for (int i=0; i < rawDepth.length; i++) {
    depthImg.pixels[i] = color(0, 0);
    if (rawDepth[i] >= thresholdMin && rawDepth[i] <= thresholdMax && rawDepth[i] != 0) {
      float r = map(rawDepth[i], thresholdMin, thresholdMax, 255, 0);
      float b = map(rawDepth[i], thresholdMin, thresholdMax, 0, 255);
      depthImg.pixels[i] = color(r, 0, b);
      int x = i % kinect2.depthWidth;
      int y = floor(i / kinect2.depthWidth);

      // point cloud
      if (pointCloud && x%resolution == 0 && y%resolution == 0) {
        float pX = map(x, 0, w, -w/2, w/2) + offsetX;
        float pY = map(y, 0, h, -h/2, h/2);
        float pZ = map(rawDepth[i], 0, 4499, 900, -900) + offsetZ;
        PVector point = new PVector(pX, pY, pZ);
        color clr;
        // color
        if (registeredColor) clr = colorImg.pixels[i];
        else clr = color(255);

        PVector vel = new PVector(directionX, -directionY, directionZ);
        particles.add(new Particle(point, vel, clr, lifeSpan, particleSize));
      }
    }
  }
  depthImg.updatePixels();
  drawParticles();
  if (guiToggle) drawGui();
}

void drawParticles() {
  for (int i = 0; i < particles.size(); i++) {
    Particle p = particles.get(i);
    p.display();
    p.update();

    if (p.isDead) {
      particles.remove(p);
      i--;
    }
  }
  
  //blackHole box
  pushMatrix();
  blackHolePos.set(0 + blackHoleX, -212 - blackHoleY, 300 + blackHoleZ);
  translate(blackHolePos.x,blackHolePos.y,blackHolePos.z);
  rotateX(radians(frameCount)*2);
  rotateY(radians(frameCount)*2);
  fill(128);
  box(30);
  popMatrix();
  lights();
}

void keyPressed() {
  if (key == ' ') guiToggle = !guiToggle;
}
