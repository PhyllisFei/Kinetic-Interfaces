import processing.sound.*;
SoundFile soundfile;

import oscP5.*;
import netP5.*;

PImage stagelight;

BodyPart[] bones = new BodyPart[16];
int skeletonAge = 0;

PImage foot1, foot2, shank1, shank2, thigh1, thigh2;
PImage forearm1, forearm2, bigarm1, bigarm2, hand1, hand2;
PImage bodyUpper, bodyDown, head, neck;

PVector headR;
PVector neckR;
PVector shoulder1R, shoulder2R;
PVector elbow1R, elbow2R;
PVector wrist1R, wrist2R;
PVector hand1R, hand2R;
PVector spineBase, spineMid, spineShoulder;
PVector hip1R, hip2R;
PVector knee1R, knee2R;
PVector ankle1R, ankle2R;
PVector foot1R, foot2R;

float Attractionamount = 0;
int floorLevel = 300;


void setup() {
  fullScreen();
  //size(1920, 1080, P3D);
  background(0, 0, 0);
  soundfile = new SoundFile(this, "bgm.mp3");
  soundfile.loop();

  setupKinect();

  loadImg();

  bones[0] = new BodyPart("head", head);
  bones[1] = new BodyPart("bodyUpper", bodyUpper);
  bones[2] = new BodyPart("hand1", hand1);
  bones[3] = new BodyPart("hand2", hand2);
  bones[4] = new BodyPart("foot1", foot1);
  bones[5] = new BodyPart("foot2", foot2);
  bones[6] = new BodyPart("bigarm1", bigarm1);
  bones[7] = new BodyPart("bigarm2", bigarm2);
  bones[8] = new BodyPart("forearm1", forearm1);
  bones[9] = new BodyPart("forearm2", forearm2);
  bones[10] = new BodyPart("thigh1", thigh1);
  bones[11] = new BodyPart("thigh2", thigh2);
  bones[12] = new BodyPart("shank1", shank1);
  bones[13] = new BodyPart("shank2", shank2);
  bones[14] = new BodyPart("neck", neck);
  bones[15] = new BodyPart("bodyDown", bodyDown);
  int index = int( random(bones.length) );
  bones[index].isDetached = false;

 // soundfile.play();

}

void draw() {
  background(0);
  pushStyle();
  noStroke();
  fill(50);
  rect(0, height-floorLevel, width, floorLevel);
  fill(255);
  popStyle();

  // updateKinect
  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap();
  //individual JOINTS
  for (int i = 0; i < skeletonArray.size(); i++) {

    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    if (skeleton.isTracked()) {
      joints = skeleton.getJoints();

      color col  = skeleton.getIndexColor();
      fill(col);
      stroke(col);
      drawBody( joints );
    }
  }




  // get the body parts
  if (skeletonArray.size() == 0) {
    skeletonAge = 0;
    for (int i=0; i<bones.length; i++) {
      bones[i].isDetached = false;
      bones[i].vel = new PVector();
    }
  } else {
    skeletonAge++;
    updateVectorsFromSkeleton();

    PVector vector, pos;

    // ***** head
    vector = PVector.sub(headR, neckR);
    pos = new PVector(neckR.x, neckR.y);
    bones[0].updateFromSkeleton( vector, pos );
    bones[0].findBones(neckR);

    //// ***** bodyUpper
    vector = PVector.sub(spineMid, spineShoulder);
    pos = new PVector(spineShoulder.x, spineShoulder.y);
    bones[1].updateFromSkeleton( vector, pos );
    bones[1].findBones(spineShoulder);


    // ***** hand Left
    vector = PVector.sub(hand1R, wrist1R);
    pos = new PVector(wrist1R.x, wrist1R.y);
    bones[2].updateFromSkeleton( vector, pos );
    bones[2].findBones(wrist1R);

    // ***** hand Right
    vector = PVector.sub(hand2R, wrist2R);
    pos = new PVector(wrist2R.x, wrist2R.y);
    bones[3].updateFromSkeleton( vector, pos );
    bones[3].findBones(wrist2R);

    // ***** foot Left
    vector = PVector.sub(foot1R, ankle1R);
    pos = new PVector(ankle1R.x, ankle1R.y);
    bones[4].updateFromSkeleton( vector, pos );
    bones[4].findBones(ankle1R);


    // ***** foot Right
    vector = PVector.sub(foot2R, ankle2R);
    pos = new PVector(ankle2R.x, ankle2R.y);
    bones[5].updateFromSkeleton( vector, pos );
    bones[5].findBones(ankle2R);


    // ***** bigarm Left
    vector = PVector.sub(elbow1R, shoulder1R);
    pos = new PVector(shoulder1R.x, shoulder1R.y);
    bones[6].updateFromSkeleton( vector, pos );
    bones[6].findBones(shoulder1R);


    // ***** bigarm Right
    vector = PVector.sub(elbow2R, shoulder2R);
    pos = new PVector(shoulder2R.x, shoulder2R.y);
    bones[7].updateFromSkeleton( vector, pos );
    bones[7].findBones(shoulder2R);


    // ***** forearm Left
    vector = PVector.sub(wrist1R, elbow1R);
    pos = new PVector(elbow1R.x, elbow1R.y);
    bones[8].updateFromSkeleton( vector, pos );
    bones[8].findBones(elbow1R);


    // ***** forearm Right
    vector = PVector.sub(wrist2R, elbow2R);
    pos = new PVector(elbow2R.x, elbow2R.y);
    bones[9].updateFromSkeleton( vector, pos );
    bones[9].findBones(elbow2R);


    // ***** thigh Left
    vector = new PVector(knee1R.x - hip1R.x, knee1R.y - hip1R.y);
    pos = new PVector(hip1R.x, hip1R.y);
    bones[10].updateFromSkeleton( vector, pos );
    bones[10].findBones(hip1R);


    // ***** thigh Right
    vector = new PVector(knee2R.x - hip2R.x, knee2R.y - hip2R.y);
    pos = new PVector(hip2R.x, hip2R.y);
    bones[11].updateFromSkeleton( vector, pos );
    bones[11].findBones(hip2R);


    // ***** shank Left
    vector = PVector.sub(ankle1R, knee1R);
    pos = new PVector(knee1R.x, knee1R.y);
    bones[12].updateFromSkeleton( vector, pos );
    bones[12].findBones(knee1R);


    // ***** shank Right
    vector = PVector.sub(ankle2R, knee2R);
    pos = new PVector(knee2R.x, knee2R.y);
    bones[13].updateFromSkeleton( vector, pos );
    bones[13].findBones(knee2R);


    // ****** Neck
    vector = PVector.sub(spineShoulder, neckR);
    pos = new PVector(neckR.x, neckR.y);
    bones[14].updateFromSkeleton( vector, pos );
    bones[14].findBones(neckR);


    // *** BodyDown
    vector = PVector.sub(spineBase, spineMid);
    pos = new PVector(spineMid.x, spineMid.y);
    bones[15].updateFromSkeleton( vector, pos );
    bones[15].findBones(spineMid);



    // display
    for (int i=0; i<bones.length; i++) {
      BodyPart b = bones[i];

      PVector gravity = new PVector(0, 0.45);

      b.applyForce( gravity);

      b.updatePhysics();
      if (skeletonAge++ > 1600) {
        b.checkAcceleration();
      }
      b.checkBoundary();
      b.applyRestitution(-0.025);
      b.display();
      b.getPreviousPos();
    }
  }

  fill(255);
  text( skeletonAge, 10, 20 );
}


















void loadImg() {
  foot1 = loadImage("foot1.png");
  foot2 = loadImage("foot2.png");
  shank1 = loadImage("shank1.png");
  shank2 = loadImage("shank2.png");
  thigh1 = loadImage("thigh1.png");
  thigh2 = loadImage("thigh2.png");
  forearm1 = loadImage("forearm1.png");
  forearm2 = loadImage("forearm2.png");
  bigarm1 = loadImage("bigarm1.png");
  bigarm2 = loadImage("bigarm2.png");
  hand1 = loadImage("hand1.png");
  hand2 = loadImage("hand2.png");
  bodyUpper = loadImage("bodyUpper.png");
  head = loadImage("head.png");
  neck = loadImage("neck.png");
  bodyDown = loadImage("bodyDown.png");

  stagelight = loadImage("light.png");
}





void updateVectorsFromSkeleton() {
  headR = new PVector ( joints[KinectPV2.JointType_Head].getX(), joints[KinectPV2.JointType_Head].getY() );
  neckR = new PVector ( joints[KinectPV2.JointType_Neck].getX(), joints[KinectPV2.JointType_Neck].getY());
  shoulder1R = new PVector ( joints[KinectPV2.JointType_ShoulderLeft].getX(), joints[KinectPV2.JointType_ShoulderLeft].getY() );
  shoulder2R = new PVector ( joints[KinectPV2.JointType_ShoulderRight].getX(), joints[KinectPV2.JointType_ShoulderRight].getY() );
  elbow1R = new PVector ( joints[KinectPV2.JointType_ElbowLeft].getX(), joints[KinectPV2.JointType_ElbowLeft].getY() );
  elbow2R = new PVector ( joints[KinectPV2.JointType_ElbowRight].getX(), joints[KinectPV2.JointType_ElbowRight].getY() );
  wrist1R = new PVector ( joints[KinectPV2.JointType_WristLeft].getX(), joints[KinectPV2.JointType_WristLeft].getY() );
  wrist2R = new PVector ( joints[KinectPV2.JointType_WristRight].getX(), joints[KinectPV2.JointType_WristRight].getY() );
  hand1R = new PVector ( joints[KinectPV2.JointType_HandLeft].getX(), joints[KinectPV2.JointType_HandLeft].getY() );
  hand2R = new PVector ( joints[KinectPV2.JointType_HandRight].getX(), joints[KinectPV2.JointType_HandRight].getY() );
  spineBase = new PVector ( joints[KinectPV2.JointType_SpineBase].getX(), joints[KinectPV2.JointType_SpineBase].getY() );
  spineMid = new PVector  ( joints[KinectPV2.JointType_SpineMid].getX(), joints[KinectPV2.JointType_SpineMid].getY() );
  spineShoulder = new PVector  ( joints[KinectPV2.JointType_SpineShoulder].getX(), joints[KinectPV2.JointType_SpineShoulder].getY() );
  hip1R = new PVector ( joints[KinectPV2.JointType_HipLeft].getX(), joints[KinectPV2.JointType_HipLeft].getY() );
  hip2R = new PVector ( joints[KinectPV2.JointType_HipRight].getX(), joints[KinectPV2.JointType_HipRight].getY() );
  knee1R = new PVector ( joints[KinectPV2.JointType_KneeLeft].getX(), joints[KinectPV2.JointType_KneeLeft].getY() );
  knee2R = new PVector ( joints[KinectPV2.JointType_KneeRight].getX(), joints[KinectPV2.JointType_KneeRight].getY() );
  ankle1R =  new PVector ( joints[KinectPV2.JointType_AnkleLeft].getX(), joints[KinectPV2.JointType_AnkleLeft].getY() );
  ankle2R = new PVector ( joints[KinectPV2.JointType_AnkleRight].getX(), joints[KinectPV2.JointType_AnkleRight].getY() );
  foot1R = new PVector ( joints[KinectPV2.JointType_FootLeft].getX(), joints[KinectPV2.JointType_FootLeft].getY() );
  foot2R = new PVector ( joints[KinectPV2.JointType_FootRight].getX(), joints[KinectPV2.JointType_FootRight].getY() );
}
