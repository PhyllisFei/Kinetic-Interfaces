import oscP5.*;
OscP5 oscP5;

import ddf.minim.*;

Minim minim;
AudioPlayer light;
AudioPlayer normal;
AudioPlayer low;
AudioPlayer peng;
PImage img;

PVector posePosition;
PVector poseOrientation;

boolean found;
boolean eyebrow;
boolean nostril;
boolean mwidth;
boolean mheight;
boolean isPlaying = false;
float eyeLeftHeight;
float eyeRightHeight;
float mouthHeight;
float mouthWidth;
float nostrilHeight;
float leftEyebrowHeight;
float rightEyebrowHeight;

float poseScale;

color c;
float prev_rightEyebrowHeight;
float prev_mouthWidth;
float prev_mouthHeight;
float prev_nostrilHeight;



void setup() {
  size(640, 480);
  frameRate(30);
  noStroke();
  img = loadImage("drum.jpg");
  minim = new Minim(this);

  light = minim.loadFile("light.mp3");
  normal = minim.loadFile("normal.mp3");
  low = minim.loadFile("low.mp3");
  peng = minim.loadFile("peng.mp3");

  posePosition = new PVector();
  poseOrientation = new PVector();

  oscP5 = new OscP5(this, 8338);
  oscP5.plug(this, "mouthWidthReceived", "/gesture/mouth/width");
  oscP5.plug(this, "mouthHeightReceived", "/gesture/mouth/height");
  oscP5.plug(this, "eyebrowLeftReceived", "/gesture/eyebrow/left");
  oscP5.plug(this, "eyebrowRightReceived", "/gesture/eyebrow/right");
  oscP5.plug(this, "eyeLeftReceived", "/gesture/eye/left");
  oscP5.plug(this, "eyeRightReceived", "/gesture/eye/right");
  oscP5.plug(this, "jawReceived", "/gesture/jaw");
  oscP5.plug(this, "nostrilsReceived", "/gesture/nostrils");
  oscP5.plug(this, "found", "/found");
  oscP5.plug(this, "poseOrientation", "/pose/orientation");
  oscP5.plug(this, "posePosition", "/pose/position");
  oscP5.plug(this, "poseScale", "/pose/scale");
}


void draw() {
  background(255);


  if (found) {
    //translate(posePosition.x, posePosition.y);
    translate(width/2, height/2);
    scale(poseScale*0.5);
    noFill();

    fill(c, 150);
    ellipse(0, 0, 100, 90);
    //fill(0);
    //ellipse(0, 20, mouthWidth*2, mouthHeight*2);
    //ellipse(-3, nostrilHeight, 2, 2);
    //ellipse(3, nostrilHeight, 2, 2);
    //ellipse(-20, eyeLeftHeight*-8, 5, 5);
    //ellipse(20, eyeRightHeight*-8, 5, 5);

    float diffeyebrow = abs(rightEyebrowHeight-prev_rightEyebrowHeight);
    float diffnostril = abs(nostrilHeight-prev_nostrilHeight);
    float diffmouthWidth = abs(mouthWidth-prev_mouthWidth);
    float diffmouthHeight = abs(mouthHeight-prev_mouthHeight);



    //println(diffeyebrow);
    if (diffeyebrow>0.3) {
      eyebrow = true;
      c = color(random(255), random(255), random(255));
      if (!low.isPlaying()) {
        low.rewind();
        low.play();
      }
    } else if (diffnostril>0.1) {
      nostril = true;
    } else if (diffmouthWidth>0.2) {
      mwidth = true;
      if ( !light.isPlaying()) {
        light.rewind();
        light.play();
      }
    } else if (diffmouthHeight>0.2) {
      mheight = true;
      if (!normal.isPlaying()) {

        normal.play();
        normal.rewind();
      }
    }

    if (eyebrow) {
      //fill(c, 150);
      //rectMode(CENTER);
      //rect(-20, leftEyebrowHeight * -5, 25, 5);
      //rect(20, rightEyebrowHeight * -5, 25, 5);

      //fill(0);
      //ellipse(-20, eyeLeftHeight*-8, 5, 5);
      //ellipse(20, eyeRightHeight*-8, 5, 5);
      image(img, -25, leftEyebrowHeight * -5, 15, 10);
      image(img, 15, leftEyebrowHeight * -5, 15, 10);
      image(img, 20, eyeRightHeight*-8, 7, 7);
       image(img, -20, eyeRightHeight*-8, 7, 7);
    }

    if (nostril) {
      fill(0);
      ellipse(-1, nostrilHeight, 2, 2);
      ellipse(5, nostrilHeight, 2, 2);
    }

    if (mwidth) {
      fill(0);
      image(img,0, 20, mouthWidth*2, mouthHeight*2);
    }

    if (mheight) {
      fill(0);
      image(img,-13, 20, mouthWidth*2, mouthHeight*2);
    }



    //    rectMode(CENTER);
    //    rect(-20, leftEyebrowHeight * -5, 25, 5);
    //    rect(20, rightEyebrowHeight * -5, 25, 5);
  }


  prev_rightEyebrowHeight = rightEyebrowHeight;
  prev_mouthWidth = mouthWidth;
  prev_nostrilHeight = nostrilHeight;
  prev_mouthHeight = mouthHeight;
}


public void mouthWidthReceived(float w) {
  //println("mouth Width: " + w);
  mouthWidth = w;
}

public void mouthHeightReceived(float h) {
  //println("mouth height: " + h);
  mouthHeight = h;
}

public void eyebrowLeftReceived(float h) {
  //println("eyebrow left: " + h);
  leftEyebrowHeight = h;
}

public void eyebrowRightReceived(float h) {
  //println("eyebrow right: " + h);
  rightEyebrowHeight = h;
}

public void eyeLeftReceived(float h) {
  //println("eye left: " + h);
  eyeLeftHeight = h;
}

public void eyeRightReceived(float h) {
  //println("eye right: " + h);
  eyeRightHeight = h;
}

public void jawReceived(float h) {
  //println("jaw: " + h);
}

public void nostrilsReceived(float h) {
  //println("nostrils: " + h);
  nostrilHeight = h;
}

public void found(int i) {
  //println("found: " + i); // 1 == found, 0 == not found
  found = i == 1;
}

public void posePosition(float x, float y) {
  //println("pose position\tX: " + x + " Y: " + y );
  posePosition.x = x;
  posePosition.y = y;
}

public void poseScale(float s) {
  //println("scale: " + s);
  poseScale = s;
}

public void poseOrientation(float x, float y, float z) {
  //println("pose orientation\tX: " + x + " Y: " + y + " Z: " + z);
  poseOrientation.x = x;
  poseOrientation.y = y;
  poseOrientation.z = z;
}


void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.isPlugged()==false) {
    //println("UNPLUGGED: " + theOscMessage);
  }
}