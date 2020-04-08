import controlP5.*;

import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;

ControlP5 cp5;
Slider2D rotation;
CheckBox checkbox;
Range depthRange;

Kinect2 kinect2;
PImage depthImg;

int resolution = 3;
int thresholdMin = 1;
int thresholdMax = 4499;
int pointSize=1;
int zOffset=0;
boolean line=false;

//GUI
int guiX=10;
int guiY=150;
int sliderW=100;
int sliderH=20;
int sliderGap=sliderH+10;

ArrayList<Particle> particles= new ArrayList<Particle>();

void setup() {
  size(800, 600, P3D);
  kinect2 = new Kinect2(this);

  kinect2.initDepth();
  kinect2.initRegistered();
  kinect2.initDevice();

  depthImg = new PImage(kinect2.depthWidth, kinect2.depthHeight, ARGB);

  //GUI
  cp5 = new ControlP5(this);
  depthRange =cp5.addRange("DepthRange")
    .setBroadcast(false)
    .setPosition(guiX, guiY+sliderGap*0)
    .setSize(sliderW*2, sliderH)
    .setRange(1, 4499)
    .setRangeValues(1, 4499)
    .setHandleSize(15)
    ;

  cp5.addSlider("resolution")
    .setPosition(guiX, guiY+sliderGap*2)
    .setRange(1, 10)
    .setValue(3)
    .setSize(sliderW, sliderH)
    .setNumberOfTickMarks(5)
    .setSliderMode(Slider.FLEXIBLE)
    ;
  cp5.addSlider("pointSize")
    .setPosition(guiX, guiY+sliderGap*3)
    .setRange(1, 5)
    .setValue(1)
    .setSize(sliderW, sliderH)
    .setNumberOfTickMarks(5)
    .setSliderMode(Slider.FLEXIBLE)
    ;
  cp5.addNumberbox("zOffset")
    .setPosition(guiX, guiY+sliderGap*4)
    .setSize(sliderW, sliderH)
    .setRange(-300, 300)
    .setScrollSensitivity(1.1)
    .setValue(0)
    ;
  rotation=cp5.addSlider2D("Rotation")
    .setSize(200, 200)
    .setPosition(10, height-200-30)
    .setValue(0, 0)
    .setMinMax(-PI, PI, PI, -PI)
    ;
  checkbox = cp5.addCheckBox("checkBox")
    .setPosition(guiX, guiY+sliderGap*6)
    .setSize(20, 20)
    .addItem("waterfall", 1)
    ;
}


void draw() {
  background(0);

  thresholdMin=(int)depthRange.getArrayValue(0);
  thresholdMax=(int)depthRange.getArrayValue(1);

  pushMatrix();
  translate(width/2, height/2);
  rotateY(rotation.getArrayValue(0));
  rotateX(rotation.getArrayValue(1));

  noFill();
  stroke(255);
  box(200);

  PImage colorImg=kinect2.getRegisteredImage().copy();
  colorImg.loadPixels();

  int[] rawDepth = kinect2.getRawDepth();
  int w = kinect2.depthWidth;
  int h = kinect2.depthHeight;
  depthImg.loadPixels();
  for (int i=0; i < rawDepth.length; i++) {
    int x = i % w;
    int y = floor(i / w);
    int depth = rawDepth[i];

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
        color c=colorImg.pixels[i];

        particles.add(new Particle(pX, pY, pZ, pointSize, c));
      }
    } else {
      depthImg.pixels[i] = color(0, 0);
    }
  }
  depthImg.updatePixels();

  for (int i=0; i<particles.size(); i++) {
    Particle p=particles.get(i);
    p.move();
    p.display();

    if (line) {
      for (int k=0; k<particles.size(); k++) {
        Particle p2=particles.get(k);
        if (i!=k) {
          p.connectLine(p2);
        }
      }
    }
  }


  while (particles.size()>5000) {
    particles.remove(0);
  }

  popMatrix();


  image(kinect2.getDepthImage(), 0, 0, kinect2.depthWidth * 0.3, kinect2.depthHeight * 0.3);
  image(depthImg, 0, 0, kinect2.depthWidth * 0.3, kinect2.depthHeight * 0.3);


  saveFrame("data/png/frames-#####.png");

  fill(255);
  text(frameRate, 10, 20);
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isFrom(checkbox)) {
    line=!line;
  }
}