import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;
import controlP5.*;


Kinect2 kinect2;
PImage depthImg;
PImage colorImg;

ArrayList<Particle> particles;

ControlP5 p5;

//params
int resolution;
int thresholdMin;
int thresholdMax;
int pointSize;

boolean colored;
boolean matrixed;


void setup() {
  size(800, 600, P3D);

  int sliderW = 100;
  int sliderH = 15;
  int startX = 10;
  int startY = 35;
  int space = 20;

  p5 = new ControlP5(this);
  p5.addSlider("thresholdMin")
    .setPosition(startX, startY + space * 0)
    .setSize(sliderW, sliderH)
    .setRange(0, 4499)
    .setValue(500);

  p5.addSlider("thresholdMax")
    .setPosition(startX, startY + space * 1)
    .setSize(sliderW, sliderH)
    .setRange(0, 4499)
    .setValue(4499);

  p5.addSlider("resolution")
    .setPosition(startX, startY + space * 2)
    .setSize(sliderW, sliderH)
    .setRange(1, 10)
    .setValue(4);

  p5.addSlider("pointSize")
    .setPosition(startX, startY + space * 3)
    .setSize(sliderW, sliderH)
    .setRange(1, 15)
    .setValue(12);

  p5.addToggle("colored")
    .setPosition(startX, startY + space * 4)
    .setSize(sliderW, sliderH)
    .setValue(false);

  p5.addToggle("matrixed")
    .setPosition(startX, startY + space * 5)
    .setSize(sliderW, sliderH)
    .setValue(false);

  kinect2 = new Kinect2(this);

  kinect2.initDepth();
  kinect2.initRegistered();
  kinect2.initDevice();

  particles = new ArrayList();

  depthImg = new PImage(kinect2.depthWidth, kinect2.depthHeight, ARGB);
}


void draw() {
  background(0);


  // let's make a 3D space!
  // the origin(0,0,0) should be the center of the canvas
  pushMatrix();
  translate(width/2, height/2);
  if (colored) {
    colorImg = kinect2.getRegisteredImage();
    colorImg.loadPixels();
  }

  int[] rawDepth = kinect2.getRawDepth();
  int w = kinect2.depthWidth;
  int h = kinect2.depthHeight;
  depthImg.loadPixels();
  for (int i=0; i < rawDepth.length; i++) {
    int x = i % w;
    int y = floor(i / w);
    int depth = rawDepth[i]; // z

    if ( depth >= thresholdMin
      && depth <= thresholdMax
      && depth != 0) {

      float r = map(depth, thresholdMin, thresholdMax, 255, 0);
      float b = map(depth, thresholdMin, thresholdMax, 0, 255);

      depthImg.pixels[i] = color(r, 0, b);

      if (x % resolution == 0 && y % resolution == 0) { 
        float pX = map(x, 0, w, -w/2, w/2); 
        float pY = map(y, 0, h, -h/2, h/2);
        float pZ = map(depth, 1, 4499, 500, -500);
        color c;

        c = colored ? colorImg.pixels[i] : color(255);
        
        particles.add(new Particle(pX, pY, pZ, c, pointSize, matrixed));
      }
    } else {
      depthImg.pixels[i] = color(0, 0);
    }
  }
  depthImg.updatePixels();
  for (int i = particles.size()-1; i >= 0; i--) {
    Particle p = particles.get(i);
    p.update();
    p.display();
     

    if (p.isDead) {
      particles.remove(p);
    }
  }

  popMatrix();


  image(kinect2.getDepthImage(), 0, 0, kinect2.depthWidth * 0.3, kinect2.depthHeight * 0.3);
  image(depthImg, width-100, 0, kinect2.depthWidth * 0.3, kinect2.depthHeight * 0.3);

  fill(255);
  text(frameRate, 10, 20);
}
