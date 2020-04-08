class BodyPart {
  String name;
  PImage img;
  PVector pos;
  PVector vel;
  PVector acc;
  float angle;
  float scale;
  float distance;
  boolean isDetached;
  PVector prePos;

  BodyPart(String _name, PImage _img) {
    name = _name;
    img = _img;
    pos = new PVector();
    prePos = new PVector();
    vel = new PVector();
    acc = new PVector();
    angle = 0;
    scale = 1.0;
    distance = 0;
    isDetached = false;
  }

  void checkAcceleration() {

    PVector vector = PVector.sub(pos, prePos);
    if (vector.mag() > 70) {
      println(name, vector.mag());
      isDetached = true;

      vector.mult(0.5);
      applyForce( vector );

      pushStyle();
      noStroke();
      fill(255, 0, 0, 100);
      ellipse(pos.x, pos.y, 100, 100);
      popStyle();
    }
  }

  void findBones(PVector skeletonVector) {
    if (isDetached) {  

      PVector vector = skeletonVector.copy().sub(pos);
      float distance = vector.mag();
      if (distance <= 20) {
        //vector.mult(0.03);
        
        isDetached = false;
      } else{
        vector.mult(0.01);
        applyForce(vector);
        //isDetached = false;
      }
      
      pushStyle();
      strokeWeight(1);
      stroke(255,30);
      line(skeletonVector.x, skeletonVector.y, pos.x, pos.y);
      popStyle();
    }
  }


  void getPreviousPos() {
    prePos.x = pos.x;
    prePos.y = pos.y;
  }

  void updatePhysics() {
    if ( isDetached ) {
      vel.add(acc);
      pos.add(vel);
      acc.mult(0);
    }
    vel.limit(50);
  }
  void applyForce( PVector force ) {
    if ( isDetached ) {
      PVector f = force.copy();
      acc.add( f );
      println(f);
    }
  }

  void updateFromSkeleton( PVector vector, PVector _pos ) {
    if ( !isDetached ) {
      pos = _pos.copy();
      PVector v = vector.copy();
      distance = v.mag();
      angle = v.heading();
    }
  }

  void display() {

    float adjustX = 0;
    float adjustY = 0;
    float adjustW = 1.0;
    float adjustH = 1.0;

    if ( name.equals("head") ) {
      adjustW = 1.5;
      adjustH = 1.5;
    } else if ( name.equals("bodyDown" ) ) {
      adjustY = -20;
      adjustH = 1.2;
    } else if ( name.equals("hand1") || name.equals("hand2") || name.equals("foot1") || name.equals("foot2")) {
      adjustW = 2.5;
      adjustH = 2.5;
    } else if (name.equals("bodyUpper" )) {
      adjustY = 0;
      adjustH = 1.2;
      adjustW = 1.5;
    }


    scale = distance / img.height;

    pushStyle();
    pushMatrix();

    translate(pos.x, pos.y);
    rotate(angle - PI/2);
    image(img, -0.5*img.width * adjustW * scale + adjustX * scale, adjustY * scale, 
      img.width*scale * adjustW, img.height * scale * adjustH );

    popMatrix();
    popStyle();

    //pushStyle();
    //pushMatrix();

    //translate(pos.x, pos.y);
    //rotate(angle);

    //strokeWeight(3);
    //stroke(0, 255, 0);
    //noFill();
    //line(0, 0, distance, 0);

    //popMatrix();
    //popStyle();
  }

  void applyRestitution(float amount) {
    float value = 1.0 + amount;
    vel.mult( value );
  }

  void checkBoundary() {
    if (pos.x < 0) {
      pos.x = 0;
      vel.x *= -1;
    } else if (pos.x > width) {
      pos.x = width;
      vel.x *= -1;
    }
    if (pos.y < 0) {
      pos.y = 0;
      vel.y *= -1;
    } else if (pos.y > height - floorLevel) {
      pos.y = height - floorLevel;
      vel.y *= -1;
    }
  }
}