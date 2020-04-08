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

void draw() {

  updateKinect();

  if (joints != null) {
    
    // ***** head
    PVector vector1 = PVector.sub(neckR, headR);
    float distance1 = vector1.mag();
    float angle1 = vector1.heading();
    float s1 = distance1 / head.width;

    pushMatrix();
    //float s1 = (joints[KinectPV2.JointType_ShoulderRight].getX()-joints[KinectPV2.JointType_ShoulderLeft].getX())/head.width;
    translate(-head.width/2, 0);
    rotate(angle1);
    scale(s1);
    image( head, joints[KinectPV2.JointType_Neck].getX() / s1, joints[KinectPV2.JointType_Neck].getY() / s1 );
    popMatrix();


    // ***** body
    PVector vector2 = PVector.sub(spineMidR, neckR);
    float distance2 = vector2.mag();
    float angle2 = vector2.heading();
    float s2 = distance2 / body.width;

    pushMatrix();
    //float s2 = (joints[KinectPV2.JointType_ShoulderRight].getX()-joints[KinectPV2.JointType_ShoulderLeft].getX())/body.width;
    translate(-0.5 * body.width, 0);
    rotate(angle2);
    scale(s2);
    image(body, ( joints[KinectPV2.JointType_Neck].getX() )/s2, (joints[KinectPV2.JointType_Neck].getY())/s2 );
    popMatrix();


    // ***** bigarm Left
    PVector vector3 = PVector.sub(elbow1R, shoulder1R);
    float distance3 = vector3.mag();
    float angle3 = vector3.heading();
    float s3 = distance3 / bigarm1.width;

    pushMatrix();
    //float s3 = (joints[KinectPV2.JointType_ShoulderRight].getX()-joints[KinectPV2.JointType_ShoulderLeft].getX())/body.width;
    translate(-bigarm1.width/2, 0);
    rotate(angle3);
    scale((joints[KinectPV2.JointType_ShoulderRight].getX()-joints[KinectPV2.JointType_ShoulderLeft].getX())/body.width);
    image( bigarm1, joints[KinectPV2.JointType_ShoulderLeft].getX() / s3, joints[KinectPV2.JointType_ShoulderLeft].getY() / s3 );
    popMatrix();


    // ***** bigarm Right
    PVector vector4 = PVector.sub(elbow2R, shoulder2R);
    float distance4 = vector4.mag();
    float angle4 = vector4.heading();
    float s4 = distance4 / bigarm2.width;

    pushMatrix();
    //float s4 = (joints[KinectPV2.JointType_ShoulderRight].getX()-joints[KinectPV2.JointType_ShoulderLeft].getX())/body.width;
    translate(-bigarm2.width/2, 0);
    rotate(angle4);
    scale(s4);
    image( bigarm2, joints[KinectPV2.JointType_ShoulderRight].getX() / s4, joints[KinectPV2.JointType_ShoulderRight].getY() / s4 );
    popMatrix();


    // ***** forearm Left
    PVector vector5 = PVector.sub(wrist1R, elbow1R);
    float distance5 = vector5.mag();
    float angle5 = vector5.heading();
    float s5 = distance5 / forearm1.width;

    pushMatrix();
    //float s5 = (joints[KinectPV2.JointType_ElbowLeft].getX()-joints[KinectPV2.JointType_WristLeft].getX())/forearm1.width;
    translate(-forearm1.width/2, 0);
    rotate(angle5);
    scale(s5);
    image( forearm1, joints[KinectPV2.JointType_ElbowLeft].getX() / s5, joints[KinectPV2.JointType_ElbowLeft].getY() / s5 );
    popMatrix();


    // ***** forearm Right
    PVector vector6 = PVector.sub(wrist2R, elbow2R);
    float distance6 = vector6.mag();
    float angle6 = vector6.heading();
    float s6 = distance6 / forearm2.width;

    pushMatrix();
    //float s6 = (joints[KinectPV2.JointType_ElbowRight].getX()-joints[KinectPV2.JointType_WristRight].getX())/forearm2.width;
    translate(-forearm2.width/2, 0);
    rotate(angle6);
    scale(s6);
    image( forearm2, joints[KinectPV2.JointType_ElbowRight].getX() / s6, joints[KinectPV2.JointType_ElbowRight].getY() / s6 );
    popMatrix();


    // ***** hand Left
    PVector vector7 = PVector.sub(hand1R, wrist1R);
    float distance7 = vector7.mag();
    float angle7 = vector7.heading();
    float s7 = distance7 / hand1.width;

    pushMatrix();
    //float s7 = (joints[KinectPV2.JointType_ShoulderRight].getX()-joints[KinectPV2.JointType_ShoulderLeft].getX())/body.width;
    translate(-foot1.width/2, 0);
    scale((joints[KinectPV2.JointType_ShoulderRight].getX()-joints[KinectPV2.JointType_ShoulderLeft].getX())/body.width);
    translate(-hand1.width/2, 0);
    image( hand1, joints[KinectPV2.JointType_WristLeft].getX() / s7, joints[KinectPV2.JointType_WristLeft].getY() / s7 );
    popMatrix();


    // ***** hand Right
    PVector vector8 = PVector.sub(hand2R, wrist2R);
    float distance8 = vector8.mag();
    float angle8 = vector8.heading();
    float s8 = distance8 / hand2.width;

    pushMatrix();
    //float s8 = (joints[KinectPV2.JointType_ShoulderRight].getX()-joints[KinectPV2.JointType_ShoulderLeft].getX())/body.width;
    translate(-foot1.width/2, 0);
    scale((joints[KinectPV2.JointType_ShoulderRight].getX()-joints[KinectPV2.JointType_ShoulderLeft].getX())/body.width);
    translate(-hand2.width/2, 0);
    image( hand2, joints[KinectPV2.JointType_WristRight].getX() / s8, joints[KinectPV2.JointType_WristRight].getY() / s8 );
    popMatrix();


    // ***** thigh Left
    PVector vector9 = PVector.sub(spineBaseR + spineMidR, hip1R);
    float distance9 = vector9.mag();
    float angle9 = vector9.heading();
    float s9 = distance9 / thigh1.width;

    pushMatrix();
    //float s9 = abs(((joints[KinectPV2.JointType_SpineBase].getY()+joints[KinectPV2.JointType_SpineMid].getY())/2-joints[KinectPV2.JointType_Neck].getY())/thigh1.height);
    translate(-thigh1.width/2, 0);
    scale(s9);
    image( thigh1, joints[KinectPV2.JointType_HipLeft].getX()/s9, 0.52 * (joints[KinectPV2.JointType_SpineBase].getY()+joints[KinectPV2.JointType_SpineMid].getY())/s9 );
    popMatrix();

  
    // ***** thigh Right
    PVector vector10 = PVector.sub(spineBaseR + spineMidR, hip2R);
    float distance10 = vector10.mag();
    float angle10 = vector10.heading();
    float s10 = distance10 / thigh2.width;

    pushMatrix();
    //float s10 = abs(((joints[KinectPV2.JointType_SpineBase].getY()+joints[KinectPV2.JointType_SpineMid].getY())/2-joints[KinectPV2.JointType_Neck].getY())/thigh2.height);
    translate(-thigh2.width/2, 0);   
    scale(s10);
    image( thigh2, joints[KinectPV2.JointType_HipRight].getX()/s10, 0.52 * (joints[KinectPV2.JointType_SpineBase].getY()+joints[KinectPV2.JointType_SpineMid].getY())/s10 );
    popMatrix();


    // ***** shank Left
    PVector vector11 = PVector.sub(ankle1R, knee1R);
    float distance11 = vector11.mag();
    float angle11 = vector11.heading();
    float s11 = distance11 / shank1.width;

    pushMatrix();
    //float s11 = abs((joints[KinectPV2.JointType_KneeLeft].getY()-joints[KinectPV2.JointType_AnkleLeft].getY())/shank1.height);
    translate(-shank1.width/2, 0);
    scale(s11);
    image(shank1, joints[KinectPV2.JointType_KneeLeft].getX() / s11, joints[KinectPV2.JointType_KneeLeft].getY() / s11 );
    popMatrix();


    // ***** shank Right
    PVector vector12 = PVector.sub(ankle2R, knee2R);
    float distance12 = vector12.mag();
    float angle12 = vector12.heading();
    float s12 = distance12 / shank2.width;

    pushMatrix();
    //float s12 = abs((joints[KinectPV2.JointType_KneeRight].getY()-joints[KinectPV2.JointType_AnkleRight].getY())/shank2.height);
    translate(-shank2.width/2, 0);
    scale(s12);
    image( shank2, joints[KinectPV2.JointType_KneeRight].getX() / s12, joints[KinectPV2.JointType_KneeRight].getY() / s12 );
    popMatrix();


    // ***** foot Left
    PVector vector13 = PVector.sub(foot1R, ankle1R);
    float distance13 = vector13.mag();
    float angle13 = vector13.heading();
    float s13 = distance13 / foot1.width;

    pushMatrix();
    //float s13 = abs((2*joints[KinectPV2.JointType_AnkleLeft].getY()-2*joints[KinectPV2.JointType_FootLeft].getY())/foot1.height);
    translate(-foot1.width/2, 0);
    scale(s13);
    image( foot1, joints[KinectPV2.JointType_AnkleLeft].getX() / s13, joints[KinectPV2.JointType_AnkleLeft].getY() / s13 );
    popMatrix();


    // ***** foot Right
    PVector vector14 = PVector.sub(foot2R, ankle2R);
    float distance14 = vector14.mag();
    float angle14 = vector14.heading();
    float s14 = distance14 / foot2.width;

    pushMatrix();
    //float s14 = abs((2*joints[KinectPV2.JointType_AnkleRight].getY()-2*joints[KinectPV2.JointType_FootRight].getY())/foot2.height);
    translate(-foot2.width/2, 0);
    scale(s14);
    image( foot2, joints[KinectPV2.JointType_AnkleRight].getX() / s14, joints[KinectPV2.JointType_AnkleRight].getY() / s14 );
    popMatrix();
  }
}
