PImage foot1, foot2, shank1, shank2, thigh1, thigh2;
PImage forearm1, forearm2, bigarm1, bigarm2, hand1, hand2;
PImage body, head;

PVector headR;
PVector neckR;
PVector shoulder1R, shoulder2R;
PVector elbow1R, elbow2R;
PVector wrist1R, wrist2R;
PVector hand1R, hand2R;
PVector spineBaseR, spineMidR;
PVector hip1R, hip2R;
PVector knee1R, knee2R;
PVector ankle1R, ankle2R;
PVector foot1R, foot2R;

PVector pos;
PVector vel;
PVector acc;
PVector gravity = new PVector(0, 1);

void setup() {
  size(1920, 1080, P3D);
  background(0, 0, 0);

  setupKinect();

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
  body = loadImage("body.png");
  head = loadImage("head.png");
  

  pos = new PVector();
  vel = new PVector();
  acc = new PVector();

}

void draw() {
  background(0);
  
  updateKinect();

  if (joints != null) {
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
    spineBaseR = new PVector ( joints[KinectPV2.JointType_SpineBase].getX(), joints[KinectPV2.JointType_SpineBase].getY() );
    spineMidR = new PVector  ( joints[KinectPV2.JointType_SpineMid].getX(), joints[KinectPV2.JointType_SpineMid].getY() );
    hip1R = new PVector ( joints[KinectPV2.JointType_HipLeft].getX(), joints[KinectPV2.JointType_HipLeft].getY() );
    hip2R = new PVector ( joints[KinectPV2.JointType_HipRight].getX(), joints[KinectPV2.JointType_HipRight].getY() );
    knee1R = new PVector ( joints[KinectPV2.JointType_KneeLeft].getX(), joints[KinectPV2.JointType_KneeLeft].getY() );
    knee2R = new PVector ( joints[KinectPV2.JointType_KneeRight].getX(), joints[KinectPV2.JointType_KneeRight].getY() );
    ankle1R =  new PVector ( joints[KinectPV2.JointType_AnkleLeft].getX(), joints[KinectPV2.JointType_AnkleLeft].getY() );
    ankle2R = new PVector ( joints[KinectPV2.JointType_AnkleRight].getX(), joints[KinectPV2.JointType_AnkleRight].getY() );
    foot1R = new PVector ( joints[KinectPV2.JointType_FootLeft].getX(), joints[KinectPV2.JointType_FootLeft].getY() );
    foot2R = new PVector ( joints[KinectPV2.JointType_FootRight].getX(), joints[KinectPV2.JointType_FootRight].getY() );
  }

  if (joints != null) {
    
    // ***** head *****
    PVector vector1 = PVector.sub(neckR, headR);
    float distance1 = vector1.mag();
    float angle1 = vector1.heading();
    float s1 = distance1 / head.width;

    pushMatrix();
    translate(neckR.x, neckR.y);
    rotate(angle1 - PI/2);
    scale(s1);
    translate(headR.x-neckR.x, headR.y-neckR.y);

    image( head, -0.5* head.width/s1, -0.4 * head.height/s1);

    float headX_, headY_;
    float head_x = 0;
    float head_y = 0;
    headX_ = head_x;
    head_x = headR.x;
    headY_ = head_y;
    head_y = headR.y;

    float d1x = abs(headX_ - headR.x);
    float d1y = abs(headY_ - headR.y);

    if (d1x > 200 || d1y > 200) {
      update();
      applyForce(gravity);
      display1();
      checkEdges();      
    }
    popMatrix();


    // ***** body *****
    PVector vector2 = PVector.sub(spineMidR, neckR);
    float distance2 = vector2.mag();
    float angle2 = vector2.heading();
    float s2 = distance2 / body.width;

    pushMatrix();
    translate(0.5 * (shoulder1R.x + shoulder2R.x), neckR.y);
    rotate(angle2 - PI/2);
    scale(s2);
    image(body, -0.5 * body.width/s2, 0 );
    popMatrix();


    // ***** bigarm Left *****
    PVector vector3 = PVector.sub(elbow1R, shoulder1R);
    float distance3 = vector3.mag();
    float angle3 = vector3.heading();
    float s3 = distance3 / bigarm1.height;

    pushMatrix();
    translate(shoulder1R.x, shoulder1R.y);
    rotate(angle3 - PI/2);
    scale(s3);
    image( bigarm1, -0.5 * bigarm1.width/s3, 0 );
    popMatrix();


    // ***** bigarm Right *****
    PVector vector4 = PVector.sub(elbow2R, shoulder2R);
    float distance4 = vector4.mag();
    float angle4 = vector4.heading();
    float s4 = distance4 / bigarm2.height;

    pushMatrix();
    translate(shoulder2R.x, shoulder2R.y);
    rotate(angle4 - PI/2);
    scale(s4);
    image( bigarm2, -0.5 * bigarm2.width/s4, 0 );
    popMatrix();


    // ***** forearm Left *****
    PVector vector5 = PVector.sub(wrist1R, elbow1R);
    float distance5 = vector5.mag();
    float angle5 = vector5.heading();
    float s5 = distance5 / forearm1.height;

    pushMatrix();
    translate(elbow1R.x, elbow1R.y);
    rotate(angle5 - PI/2);
    scale(s5);
    image( forearm1, -0.5 * forearm1.width/s5, 0 );
    popMatrix();


    // ***** forearm Right *****
    PVector vector6 = PVector.sub(wrist2R, elbow2R);
    float distance6 = vector6.mag();
    float angle6 = vector6.heading();
    float s6 = distance6 / forearm2.height;

    pushMatrix();
    translate(elbow2R.x, elbow2R.y);
    rotate(angle6 - PI/2);
    scale(s6);
    image( forearm2, -0.5 * forearm2.width/s6, 0 );
    popMatrix();


    // ***** hand Left *****
    PVector vector7 = PVector.sub(hand1R, wrist1R);
    float distance7 = vector7.mag();
    float angle7 = vector7.heading();
    float s7 = distance7 / hand1.width;

    pushMatrix();
    translate(wrist1R.x, wrist1R.y);
    rotate(angle7 - PI/2);
    scale(s7);
    image( hand2, -0.5 * hand1.width/s7, 0);
    //float angle_7 = angle7 - PI/2;
    //if ( angle_7 > PI) {
    //  image( hand2, -0.5 * hand1.width / s7, 0);
    //} else {
    //  image( hand1, -0.5 * hand1.width / s7, 0);
    //}
    popMatrix();


    // ***** hand Right *****
    PVector vector8 = PVector.sub(hand2R, wrist2R);
    float distance8 = vector8.mag();
    float angle8 = vector8.heading();
    float s8 = distance8 / hand2.width;

    pushMatrix();
    translate(wrist2R.x, wrist2R.y);
    rotate(angle8 - PI/2);
    scale(s8);
    image( hand1, -0.5 * hand2.width/s8, 0 );
    popMatrix();


    // ***** thigh Left *****
    PVector vector_9 = new PVector(0.5*(spineBaseR.x+spineMidR.x), 0.5*(spineBaseR.y+spineMidR.y));
    PVector vector9 = PVector.sub(knee1R, vector_9);
    float distance9 = vector9.mag();
    float angle9 = vector9.heading();
    float s9 = distance9 / thigh1.height;

    pushMatrix();
    translate(hip1R.x, vector_9.y);
    rotate(angle9 - 6 * PI/11);
    scale(s9);
    image( thigh1, -0.5 * thigh1.width/s9, 0);
    popMatrix();


    // ***** thigh Right *****
    PVector vector10 = PVector.sub(knee2R, vector_9);
    float distance10 = vector10.mag();
    float angle10 = vector10.heading();
    float s10 = distance10 / thigh2.height;

    pushMatrix();
    translate(hip2R.x, vector_9.y); 
    rotate(angle10 - 5 * PI/11);
    scale(s10);
    image( thigh2, -0.5 * thigh2.width/s10, 0);
    popMatrix();


    // ***** shank Left *****
    PVector vector11 = PVector.sub(ankle1R, knee1R);
    float distance11 = vector11.mag();
    float angle11 = vector11.heading();
    float s11 = distance11 / shank1.height;

    pushMatrix();
    translate(knee1R.x, knee1R.y);
    rotate(angle11 - PI/2);
    scale(s11);
    image(shank1, -0.5 * shank1.width/s11, 0 );
    popMatrix();


    // ***** shank Right *****
    PVector vector12 = PVector.sub(ankle2R, knee2R);
    float distance12 = vector12.mag();
    float angle12 = vector12.heading();
    float s12 = distance12 / shank2.height;

    pushMatrix();
    translate(knee2R.x, knee2R.y);
    rotate(angle12 - PI/2);
    scale(s12);
    image( shank2, -0.5 * shank2.width/s12, 0 );
    popMatrix();


    // ***** foot Left *****
    PVector vector13 = PVector.sub(foot1R, ankle1R);
    float distance13 = vector13.mag();
    float angle13 = vector13.heading();
    float s13 = (distance13 / foot1.height) * 2;

    pushMatrix();
    translate(ankle1R.x, ankle1R.y);
    rotate(angle13 - PI/2);
    scale(s13);
    image( foot1, -0.5 * foot1.width/s13, 0 );
    popMatrix();


    // ***** foot Right *****
    PVector vector14 = PVector.sub(foot2R, ankle2R);
    float distance14 = vector14.mag();
    float angle14 = vector14.heading();
    float s14 = (distance14 / foot2.height) * 2;

    pushMatrix();
    translate(ankle2R.x, ankle2R.y);
    rotate(angle14 - PI/2);
    scale(s14);
    image( foot2, -0.5 * foot2.width/s14, 0 );
    popMatrix();
  }
}



// ***** drop bones *****

void update() {
  vel.add(acc);
  pos.add(vel);
  acc.mult(0);
}

void applyForce( PVector force) {
  PVector f = force.copy();
  acc.add(f);
}

void display1() {
  pushMatrix();
  pushStyle();

  headR.x = pos.x;
  headR.y = pos.y;

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
