// category: drawing, maths, easing, data, file

boolean isPause = false;

void defaultkeyPressed() {
  if (keyCode == ' ') {
    resetRandom();
    if (isPause) redraw();
  }

  if (keyCode == 'P') {
    isPause = !isPause;
  }

  if (keyCode == 'S') {
    saveFrame("frames/" + String.format("%06d", frameCount) + ".png");
    println("> save frame at", frameCount);
  }
}

// --------- 
class PreRand { 
  float[] ra = new float[5000];
  PVector[] _rndvec = new PVector[5000];
  PreRand() {
    for (int i = 0; i < ra.length; i++) {
      ra[i] = random(0, 1);
      _rndvec[i] = PVector.random3D();
    }
  } 
  float Fixrnd(float seed) {
    return ra[floor(abs(seed))%ra.length];
  } 
  void resetRandom() { 
    for (int i = 0; i < 5000; i++) {
      ra[i] = random(1);
      _rndvec[i].set(PVector.random3D());
    }
  }
  float Fixrnd(float seed, float a, float b) {
    return ra[floor(abs(seed))%ra.length] * (b-a)+a;
  }

  PVector PVectorrnd(float seed) {
    return _rndvec[floor(abs(seed))%_rndvec.length].copy();
  }
}

float[] rand = new float[5000];
PVector[] rndvec = new PVector[5000]; 
void resetRandom() {
  // *OBSELETE*
  // REPLACE BY PreRand
  for (int i = 0; i < 5000; i++) {
    rand[i] = random(1);
    if (rndvec[i] == null) {
      rndvec[i]= PVector.random3D();
    } else {
      rndvec[i].set(PVector.random3D());
    }
  }
}

class TimerFactory {
} // todo

// ----------drawing ---------
void QuadVertex(float x, float y, float z, float w, float h) {
  vertex(x - w/2, y - h / 2, z);
  vertex(x + w/2, y - h / 2, z);
  vertex(x + w/2, y + h / 2, z);
  vertex(x - w/2, y + h / 2, z);
}
void translateP(PVector p) {
  translate(p.x, p.y, p.z);
}
void translateP2D(PVector p) {
  translate(p.x, p.y);
}
void PVectorVertex(PVector p) {
  vertex(p.x, p.y, p.z);
}

void PVectorVertex2D(PVector p) {
  vertex(p.x, p.y);
}

void rectVertex(float x, float y, float a, float b) {
  vertex(x, y);
  vertex(x+a, y);
  vertex(x+a, y+b);
  vertex(x, y+b);
}

PVector noiv2D(PVector v, float t) {
  float step = 0.01;
  return new PVector(noise(v.x*step, t*step), 
    noise(v.y*step, t*step));
}
PVector noiv(PVector v, float t) {
  float step = 0.01;
  return new PVector(noise(v.x*step, t*step), 
    noise(v.y*step, t*step), 
    noise(v.z*step, t*step));
}

void linePVector2DVertex(PVector p1, PVector p2) {
  vertex(p1.x, p1.y); 
  vertex(p2.x, p2.y);
}
void linePVector2D(PVector p1, PVector p2) {
  line(p1.x, p1.y, 
    p2.x, p2.y);
}
void linePVector(PVector p1, PVector p2) {
  line(p1.x, p1.y, p1.z, 
    p2.x, p2.y, p2.z);
}



void drawLineTrace(PVector p1, PVector p2) {
  PVector start = p1.copy();

  int n = 10;
  float x_step = (p2.x - p1.x)/n;
  float z_step = (p2.z - p1.z)/n;
  PVector step = PVector.sub(p2, p1).mult(1.0f / n);
  for (int i = 0; i < n; i++) {
    PVector end = start.copy();
    end.x += x_step;
    end.y += step.y; 
    end.z += getEaseStep(p1.z, p2.z, i, n);
    line(start.x, start.y, start.z, 
      end.x, end.y, end.z);

    start.set(end);
  }
}

void drawTex(color col, float alpha, float size, PImage tex) {

  beginShape(QUAD);
  noStroke(); 
  tint(col, alpha);
  texture(tex);
  normal(0, 0, 1);


  vertex(0 - size/2, 0 - size/2, 0, 0, 0);
  vertex(0 + size/2, 0 - size/2, 0, tex.width, 0);
  vertex(0 + size/2, 0 + size/2, 0, tex.width, tex.height);
  vertex(0 - size/2, 0 + size/2, 0, 0, tex.height);


  endShape();
}

void drawTex(color col, float alpha, float w, float h, PImage tex) {

  beginShape(QUAD);
  noStroke(); 
  tint(col, alpha);
  texture(tex);
  normal(0, 0, 1);


  vertex(0 - w/2, 0 - h/2, 0, 0, 0);
  vertex(0 + w/2, 0 - h/2, 0, tex.width, 0);
  vertex(0 + w/2, 0 + h/2, 0, tex.width, tex.height);
  vertex(0 - w/2, 0 + h/2, 0, 0, tex.height);


  endShape();
}
void drawBoxBetween(PVector p1, PVector p2, float w, float h, 
  color col, float alpha, PImage tex) {

  // only 2D
  PVector dir = p1.copy().sub(p2);
  float len = dir.mag();
  dir.normalize();
  float ang = atan2(dir.y, dir.x);
  //if (ang < 0) ang += TWO_PI;
  w = len*1.0;


  pushMatrix();
  //translate(p1.x, p2.y);
  rotate(ang); 

  drawTex(col, alpha, w, h, tex);  

  //image( road6, -len * 3.0/2, -3); 
  popMatrix();
} 

void drawFire(color fireColor, float alpha, float size, PImage fire, float seed) {

  beginShape(QUAD);
  noStroke(); 
  tint(fireColor, alpha);
  texture(fire);
  normal(0, 0, 1);

  // switch between  four sectors
  int seedPtr = floor(seed * 20);
  if ( seedPtr % 4 == 0) { 
    vertex(0 - size/2, 0 - size/2, 0, 0, 0);
    vertex(0 + size/2, 0 - size/2, 0, fire.width/2, 0);
    vertex(0 + size/2, 0 + size/2, 0, fire.width/2, fire.height/2);
    vertex(0 - size/2, 0 + size/2, 0, 0, fire.height/2);
  }
  if ( seedPtr % 4 == 1) {

    vertex(0 - size/2, 0 - size/2, 0, fire.width/2, 0);
    vertex(0 + size/2, 0 - size/2, 0, fire.width, 0);
    vertex(0 + size/2, 0 + size/2, 0, fire.width, fire.height/2);
    vertex(0 - size/2, 0 + size/2, 0, fire.width/2, fire.height/2);
  }
  if ( seedPtr % 4 == 2) {

    vertex(0 - size/2, 0 - size/2, 0, 0, fire.height/2);
    vertex(0 + size/2, 0 - size/2, 0, fire.width/2, fire.height/2);
    vertex(0 + size/2, 0 + size/2, 0, fire.width/2, fire.height);
    vertex(0 - size/2, 0 + size/2, 0, 0, fire.height);
  }
  if ( seedPtr % 4 == 3) {

    vertex(0 - size/2, 0 - size/2, 0, fire.width/2, fire.height/2);
    vertex(0 + size/2, 0 - size/2, 0, fire.width, fire.height/2);
    vertex(0 + size/2, 0 + size/2, 0, fire.width, fire.height);
    vertex(0 - size/2, 0 + size/2, 0, fire.width/2, fire.height);
  }

  endShape();
}


// gradients

int VERTICAL_GRAD = 0, HORIZON_GRAD = 1;
void gradientRect(float x, float y, float w, float h, 
  int _GRAD_MODE, color c1, color c2) {
  //float w = 100, h = 200;
  pushMatrix();
  translate(x, y);
  beginShape();
  if (_GRAD_MODE == VERTICAL_GRAD) {

    fill(c1);
    vertex(0, 0);
    fill(c1);
    vertex(w, 0);
    fill(c2);
    vertex(w, h);
    fill(c2);
    vertex(0, h);
  } else 
  if (_GRAD_MODE == HORIZON_GRAD) {

    fill(c1);
    vertex(0, 0);
    fill(c2);
    vertex(w, 0);
    fill(c2);
    vertex(w, h);
    fill(c1);
    vertex(0, h);
  }

  endShape();
  popMatrix();
}


void gradientEllipse(float x, float y, float w, float h, color c1, color c2) {

  pushMatrix();
  translate(x, y);
  beginShape();
  int n = 74;
  for (int i = 0; i < n; i++) {
    float ang = i * 1.0 / n * TWO_PI;
    if (ang > 0 && ang < 4.15) {
      fill(c1);
    } else {
      fill(c2);
    }
    vertex(w * cos(ang), h * sin(ang));
  }

  endShape();
  popMatrix();
}

void fadeBackground(color c) {
  fadeBackground(c, 80);
}
void fadeBackground(color c, float alpha) {
  pushStyle();
  fill(c, alpha);
  noStroke();
  rect(0, 0, width, height);
  popStyle();
}

// ---------- maths ---------

int randomInt(float a, float b) {
  return floor(random(a, b));
}
float maxAbs(float v1, float v2) {
  if (abs(v1) > abs(v2)) {
    return v1;
  } else {
    return v2;
  }
}


void reverseRotation(PVector p) {

  rotateZ(-p.z);
  rotateY(-p.y);
  rotateX(-p.x);
}

PVector rotate2D(float x, float y, float ang) {
  PVector p = new PVector();
  float newx = 0, newy = 0;
  newx = x * cos(ang) + y * sin(ang);
  newy = - x * sin(ang) + y * cos(ang);
  p.set(newx, newy);
  return p;
}


// ------------ easing ----------------

float sinEase(float in) {
  return sin(in * PI/2);
}
float getEaseStep(float p1, float p2, int i, int n) {
  return  (p2 - p1) * (ease_step_sin(i, n));
}

float ease_step_para(int i, int n) {
  float step = i * 1.0 / n;
  return ((1+i)*step)*((1+i)*step) - (i*step)*(i*step) ;
}
float ease_step_sin(int i, int n) {
  float step =  1.0 / n* PI /2;
  return pow(sin((1+i)*step ), 2) - pow(sin(i*step), 2) ;
}

int[] _pitchIntervalMap_ = {-1, 0, 1, 0, -1, 1, 0, -1, 0, 1, 0, -1};
int[] _pitchIntervalAccumMap_ = {0, 1, 2, 3, 4, 6, 7, 8, 9, 10, 11, 12};


int pitchIntervalMap(int notePitch) {
  return _pitchIntervalMap_[notePitch];
}

int pitchIntervalMapAccum(int notePitch) {
  return _pitchIntervalAccumMap_[notePitch];
}

float sign(float f) {
  return f==0?0:(f/abs(f));
}




// --------- data -------------

JSONArray PVectorToJSONArray2D(PVector p) {

  JSONArray vec = new JSONArray();
  vec.setFloat(0, p.x);
  vec.setFloat(1, p.y);
  return vec;
}

JSONArray PVectorToJSONArray3D(PVector p) {

  JSONArray vec = new JSONArray();
  vec.setFloat(0, p.x);
  vec.setFloat(1, p.y);
  vec.setFloat(2, p.z);
  return vec;
}

PVector JSONArrayToPVector2D(JSONArray a) {
  return new PVector(1.0f *a.getFloat(0), 1.0f *a.getFloat(1));
}

// ------------- file --------------


void getImages(String f_path, ArrayList<PImage> container) {

  int j = 0;
  String filepath = sketchPath(f_path);
  File dir = new File(filepath);
  File[] files = dir.listFiles();
  if (files != null) {      
    for (int i = 0; i < files.length; i++) {
      String fn = files[i].getName();       
      if (!files[i].isDirectory() && fn.charAt(0) != '.'  ) { // 判断是文件还是文件夹
        PImage rs = loadImage(filepath+"/"+fn);
        container.add(rs);
      }
    }
  }
}

void getMovies(String f_path, ArrayList<Movie> container, 
  String format) {
  int j = 0;
  String filepath = sketchPath(f_path);
  File dir = new File(filepath);
  File[] files = dir.listFiles();
  if (files != null) {      
    for (int i = 0; i < files.length; i++) {
      String fn = files[i].getName();       
      if (!files[i].isDirectory() && fn.charAt(0) != '.'  ) { // 判断是文件还是文件夹
        // 判断是否为 mp4
        if (fn.contains("."+format)) {
          Movie m = new Movie(this, filepath+"/"+fn);
          container.add(m);
        }
      }
    }
  }
}

// -------------------------------

class lifeStateTimer {

  private float state = 0;
  boolean isDead = false;
  float startTime = 0;
  float lifeSpan = 3.0;
  float timeCnter = 0;
  lifeStateTimer(float ls) {
    lifeSpan = ls;
    //reset();
  }
  boolean isDead() {
    return isDead;
  }

  void reset(float newlifespan) {
    lifeSpan = newlifespan;
    reset();
  }
  void reset() {
    state = 0;
    startTime = millis();
    isDead = false;
    timeCnter = startTime;
  }

  void update(float dt) {
    if (isDead) return ;
    timeCnter += dt;
    state = (timeCnter - startTime) * 0.001 / lifeSpan; 
    isDead = state > 1;
    state = min(state, 1);
  }
  void update() {
    if (isDead) return ;
    state = (millis() - startTime) * 0.001 / lifeSpan; 
    isDead = state > 1;
    state = min(state, 1);
  }

  float getState() {
    return state;
  }
}
