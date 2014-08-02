 color oddColor = color(106,90,205); //blue purp
color evenColor = color(64,224,208); //turquoise

int segments = 60;
Waver[] wavers = new Waver[segments];
float piSegments = TWO_PI/float(segments);
int hWidth, hHeight;
float degreeOffset = 360f/segments*0.5f;
int lastcontactidx=-1;

boolean autoMouse = false;
int currentSegment = 0;
int timePerSegment = 50; //ms
int autoMouseTime=0;

void setup() {
  float ratio =640f/360f;
  int h = 400;
  size(int(ratio*h), h, P2D);
  
  hWidth = width/2;
  hHeight = height/2;
  smooth();
  for (int i=0;i<segments;++i) {
      wavers[i] = new Waver(i,piSegments);
  }
}

void mousePressed(){
  autoMouse = !autoMouse;
}

void draw() {
  
  
  int contactidx = int((degrees(getMouseAngle(hWidth,hHeight))+degreeOffset)/360*segments)%segments;
  
  if(contactidx!=lastcontactidx)
    wavers[contactidx].mouseOver();
  lastcontactidx = contactidx;
  
  if(autoMouse){
    if ( millis() - autoMouseTime >= timePerSegment ){
      autoMouseTime = millis();
      wavers[currentSegment].mouseOver();
      currentSegment = (++currentSegment)%segments;
    }
  }
  
  pushMatrix();
  translate(hWidth,hHeight);
  stroke(0);
  noStroke();
  
  for(int i=0; i < segments; ++i){
    fill(float(i)/segments*255);
    wavers[i].update();
    wavers[i].display(oddColor,evenColor);
    
    rotate(piSegments);
  }
  popMatrix();
  
}

//returns radians
float getMouseAngle(int ox,int oy){
  float angle = atan2(mouseX-ox,height-mouseY-oy);
  if (angle<0) angle=PI+(PI+angle);
  if(angle==TWO_PI)angle=0f;
  return angle;
}

class Waver {
  
  int index;
  float opos;
  float pos,sidePos;
  float vel;
  float maxAcc = 0.009f;
  float maxVel = PI*9.5;//0.001;
  float acc = 0.001f;
  float segmentWidthRad;
  float hSegmentWidthRad;
  
  Waver(int index,float segmentWidthRad) {
    this.index = index;
    this.segmentWidthRad = segmentWidthRad;
    hSegmentWidthRad = segmentWidthRad/2;
    opos = 0.f;
    pos = opos;
    vel = 0;
  }

  void update(){
    acc *= 0.94;
    vel += acc;
    if(vel > 0){
      vel*=0.98f;
    }
    pos = -(opos + (sin((vel+1)*maxVel+millis()/1000.f)+1f)/2f);
  }
  
  void mouseOver(){
    acc = maxAcc;
  }

  void display(color odd, color even) {
    int total = 10;
    float hStep = 1f/float(total);
    for(int i=total-1;i>=0;--i){
      int o = i+1;
      float sq = hStep*(o);
      sq *= sq;
      float peak = pos*o+pos*o*hStep*width-(width*1.5*sq);
      if((index+i)%2==0)fill(even);
      else fill(odd);
      arc(0,0,peak,peak,HALF_PI-hSegmentWidthRad,HALF_PI+hSegmentWidthRad);
    }
  }
}
