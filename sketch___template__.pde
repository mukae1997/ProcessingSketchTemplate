import processing.video.*;

boolean useMouseAid = false;
ArrayList<PVector> mousePoses = new ArrayList<PVector>();

float dt = 0, prevTime = 0;
;

void setup() {
  size(800, 700, P2D);
  rand = new float[5000]; 
  rndvec = new PVector[5000];

  for (int i = 0; i < 5000; i++) {
    rand[i] = random(1);
    rndvec[i] = PVector.random2D();
  }
  resetRandom();
  prevTime = millis();
}
void keyPressed() {

}


void draw() {
  if (isPause) noLoop();
  surface.setTitle(str(frameRate));

  dt = millis() - prevTime;

  if (useMouseAid) {
    if (dist(pmouseX, pmouseY, mouseX, mouseY) > 10) {
      mousePoses.add(new PVector(mouseX, mouseY));
    }
    for (PVector p : mousePoses) {
      pushMatrix();
      translate(p.x, p.y);
      //put a draw snippnet here
      popMatrix();
    }
  }

  background(189);

  // 边框留白 
  float border = width * 0.20;
  translate(border / 2, border / 2);

  //translate(width/2 - border/2, height/2 - border / 2);// 居中

  rect(0, 0, 100, 100);
}

class SmoothVector extends PVector {
  // to do: write a sample use
  PVector oldv = null;
  PVector nextv = null;
  lifeStateTimer t = new lifeStateTimer(2.0);
  void SetTween(PVector _nextp, float tweenTime) { // triggerly use
    oldv = this.copy();
    nextv = _nextp.copy();
    t.reset(tweenTime);
  }
  void update() {
    t.update();
    this.set(PVector.lerp(oldv, nextv, t.state ));
  }
}
