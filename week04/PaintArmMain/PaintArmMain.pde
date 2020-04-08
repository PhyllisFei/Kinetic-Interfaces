ArrayList <PaintArm> arms;
ArrayList <PImage> imgs;
PGraphics canvas;
int numOfArm = 100;
int indexOfImage = 0;
PVector mouseAcc = new PVector(0, 0);
boolean displayText = true;

void setup() {
  size(800, 800);
  imgs = new ArrayList();
  imgs.add(loadImage("1.png"));
  imgs.add(loadImage("2.png"));
  imgs.add(loadImage("3.png"));
  imgs.add(loadImage("4.png"));
  for (PImage img : imgs){
    img.resize(width, height);
  }

  canvas = createGraphics(width, height);
  canvas.beginDraw();
  canvas.background(0);
  canvas.rectMode(CENTER);
  canvas.endDraw();

  arms = new ArrayList();
  for (int i = 0; i< numOfArm/5; i++) {
    arms.add(new PaintArm(0, 0, 2*PI/numOfArm*5*i, 2*PI/numOfArm*5*i, new PVector(width/2, height/2), imgs.get(0)));
    arms.add(new PaintArm(0, 0, 2*PI/numOfArm*5*i, 2*PI/numOfArm*5*i, new PVector(0, 0), imgs.get(0)));
    arms.add(new PaintArm(0, 0, 2*PI/numOfArm*5*i, 2*PI/numOfArm*5*i, new PVector(width, 0), imgs.get(0)));
    arms.add(new PaintArm(0, 0, 2*PI/numOfArm*5*i, 2*PI/numOfArm*5*i, new PVector(0, height), imgs.get(0)));
    arms.add(new PaintArm(0, 0, 2*PI/numOfArm*5*i, 2*PI/numOfArm*5*i, new PVector(width, height), imgs.get(0)));
  }
}

void draw() {
  mouseAcc.set(mouseX-pmouseX, mouseY-pmouseY);
  image(canvas, 0, 0);
  for (PaintArm arm : arms) {
    //move around mouse to extend with the resistence of 2
    arm.extendArm(mouseAcc.mag()/10 - 2);
    arm.update();
    arm.display();
  }

  if (displayText)displayText();
}

void keyPressed() {
  switch(key) {
  case ' ':
    for (PaintArm arm : arms) {
      arm.mode*=-1;
    }
    break;

  case 'n':
    indexOfImage = (indexOfImage+1)%imgs.size();
    for (PaintArm arm : arms) {
      arm.setCurrent(imgs.get(indexOfImage));
    }
    break;

  case 's':
    canvas.save("saved/"+frameCount+".png");
    break;

  case 'h':
    displayText = !displayText;
    break;
  case 'c':
    canvas.beginDraw();
    canvas.background(0);
    canvas.endDraw();
    break;
  }
}


void displayText() {  
  text("total num of arms " + arms.size(), 30, 30);
  text("length " + (int)arms.get(0).l1, 30, 50);
  text("mouseAcc " + mouseAcc.x + "," + mouseAcc.y, 30, 70);
  text("painting image #" + (indexOfImage+1) + " in " + imgs.size(), 30, 90);
  if (arms.get(0).mode == 1) text("painting mode circle", 30, 110);
  else text("painting mode rect", 30, 110);


  text("move around mouse to extend arms", 30, height-110);
  text("tap space bar to switch painting mode", 30, height-90);
  text("drag the center node to move them", 30, height-70);
  text("tap 'n' to paint another image", 30, height-50);
  text("tap 's'/'c' to save/clear the current canvas", 30, height-30);
  text("tap 'h' to hide texts", 30, height - 10);
}
