//game

Mover[] movers = new Mover[10];
Attractor a;
int num = 50;
int maxnum = 10001;
int r = 10;
int friendnum = 50;
int friendr = 30;
float maxspeed = PI/36;
float HP=200;
int ranger = 5;
int eatr = r;
int k=1;
PVector v[] = new PVector[maxnum];
PVector vv[] = new PVector[maxnum];
boolean mv = true;
boolean mo = true;
boolean start = false;
color c[] = new color[maxnum];
float oriangle[] = new float[maxnum];
float moriangle[] = new float[maxnum];
float doriangle[] = new float[maxnum];
float easing[] = new float[maxnum];
float chuxianx[] = new float[maxnum];
float chuxiany[] = new float[maxnum];
float suijix[] = new float[maxnum];
float suijiy[] = new float[maxnum];
int suijir[] = new int[maxnum];
float pointr[] = new float[maxnum];

void setup(){
  colorMode(RGB,255,255,255);
  size(1080,720);
  frameRate(60);
  noStroke();
  chushihua();
  for (int i = 0; i < movers.length; i++) {
    if(i < (movers.length)/2){
      movers[i] = new Mover(random(0.1, 2), random(2*width), random(2*height));
    }
    else{
      movers[i] = new Mover(random(0.1, 2), random(2*width), random(2*height));
    }
  }
  a = new Attractor();
}

void draw(){
  fill(2,2,2,15);
  rect(0,0,width,height);
  if(!start){
    GameStart();
  }
  if(num<=3000){
    if(start){
    a.drag();
    for (int i = 0; i < movers.length; i++) {
    PVector force = a.attract(movers[i]);
    movers[i].applyForce(force);
    movers[i].update();
    movers[i].display();
    }
    GameMain();
    }
  }
  else{
    if(num<maxnum){
      lizixuanzhuan(width/2,height/2);
      r+=1;
      num+=35;
      }
    else{
      GameOver();
    }
  }
}

void GameStart(){
  lizivertical();
  fill(11,100);
  rect(0,height/2-160,width,187);
  rect(100,height/2+20,width-200,55);
  fill(#FFFFFF);
  textAlign(LEFT,TOP);
  textSize(100);
  text("Friends",width/2-190,height/2-140);
  textSize(20);
  text("We are all alone without friends",width/2-170,height/2-30);
  textSize(20);
  text("Made By Hao Tsukuba 2021",width/2-160,height/2-10);
  if(millis()>=5000){
    lizesuiji();
  }
  textAlign(CENTER,TOP);
  fill(#FFFFFF);
  if(mousePressed){
    if(mouseX>100 && mouseX<width-200){
      if(mouseY>height/2+20 && mouseY<height/2+75){
        start = true;
      }
    }
  }
  if(mouseX>100 && mouseX<width-200 && mouseY>height/2+20 && mouseY<height/2+75){
    textSize(45);
    text("START",width/2-10,height/2+20);
  }
  else{
    textSize(40);
    text("START",width/2-10,height/2+20);
  }
  textAlign(LEFT,TOP);
  textSize(12);
  text("FPS:"+round(frameRate),width-40,0);
}

void GameMain(){
  lizixuanzhuan(mouseX,mouseY);
  friendchuxian();
  PressedControl();
  word();
}

void GameOver(){
  lizivertical();
  fill(11,100);
  rect(0,height/2-130,width,127);
  rect(100,height/2+20,width-200,55);
  fill(#FFFFFF);
  textAlign(LEFT,TOP);
  textSize(100);
  text("Game Over",width/2-260,height/2-120);
  textSize(40);
  text("Thanks",width/2-70,height/2+20);
}

void chushihua(){
  for(int i =0;i<maxnum-1;i++){
    c[i] = color(random(1,255),random(1,255),random(100,255));
    v[i] = new PVector(random(width),random(height));
    vv[i] = new PVector(random(width)+10,random(height)-10);
    oriangle[i] = round(random(360));
    doriangle[i] = random(maxspeed);
    if(i%10 == 0){
      pointr[i] = random(2.0)+1.0;
    }
    else{
      pointr[i] = random(2.0);
    }
    moriangle[i] = oriangle[i]/180*PI;
    chuxianx[i] = random(width-60)+30;
    chuxiany[i] = random(height-60)+30;
    if(i%30 == 0){
      suijix[i] = random(0.7)+0.3;
      suijiy[i] = random(0.7)+0.3;
    }
    else{
      suijix[i] = 1;
      suijiy[i] = 1;
    }
    suijir[i] = round(random(-ranger,ranger));
    easing[i] = random(0.02,1.3);
    moriangle[i] += doriangle[i];
  }
}

void lizesuiji(){
  pushMatrix();
  for(int i = 0;i<50;i++){
      moriangle[i] += doriangle[i];
      v[i].lerp(width/2+cos(moriangle[i]*0.13)*(suijir[i]*10+400), height/2-10+sin(moriangle[i]*0.1)*(suijir[i]*10+400),0,easing[i]);
      fill(c[i]);
      ellipse(v[i].x, v[i].y, pointr[i]+1,pointr[i]+1);
  }
  popMatrix();
}

void lizivertical(){
  pushMatrix();
  for(int i = 0;i<width;i=i+2){
      moriangle[i] += doriangle[i];
      v[i].lerp(i, sin(moriangle[i]*0.1)*(suijir[i]+height),0,easing[i]);
      fill(c[i]);
      ellipse(v[i].x, v[i].y, pointr[i],pointr[i]);
  }
  popMatrix();
}

void lizixuanzhuan(float locationx,float locationy){
  pushMatrix();
  if(mv){
    eatr = r;
    for(int i = 0;i<num-1;i++){
      moriangle[i] += doriangle[i];
      v[i].lerp(locationx+cos(suijix[i]*moriangle[i])*(suijir[i]+r*suijix[i]), locationy+sin(suijix[i]*moriangle[i])*(suijir[i]+r*suijix[i]),0,easing[i]);
      fill(c[i]);
      ellipse(v[i].x, v[i].y, pointr[i],pointr[i]);
    }
  }
  if(!mv){
    eatr = ranger;
    for(int i = 0;i<num-1;i++){
      moriangle[i] += doriangle[i];
      v[i].lerp(locationx+cos(moriangle[i])*suijir[i], locationy+sin(moriangle[i])*suijir[i],0,easing[i]);
      fill(c[i]);
      ellipse(v[i].x, v[i].y, pointr[i],pointr[i]);
    }
  }
  popMatrix();
}

void friendchuxian(){
  pushMatrix();
  friendnum = 10;
  friendr = 10;
  if(distance(chuxianx[k],chuxiany[k],mouseX,mouseY) > eatr+friendr){
      for(int i = 0;i<friendnum+19;i++){
      moriangle[i] += doriangle[i];
      vv[i].lerp(chuxianx[k]+cos(moriangle[i])*(suijir[i]+friendr), chuxiany[k]+sin(moriangle[i])*(suijir[i]+friendr),0,easing[i]);
      fill(c[i+k*friendnum]);
      ellipse(vv[i].x, vv[i].y, pointr[i],pointr[i]);
    }  
  }
  if(distance(chuxianx[k],chuxiany[k],mouseX,mouseY) <= eatr+friendr){
    k++;
    r+=2;
    num+=50;
  }
  popMatrix();
}

float distance(float x1,float y1,float x2,float y2){
  return sqrt(sq(x1-x2)+sq(y1-y2));
}

void word(){
  fill(#FFFFFF);
  textAlign(LEFT,TOP);
  textSize(15);
  text("Friends:"+num,0,0);
  text("Radius:"+r,110,0);
  if(mv){
    fill(#33CCFF);
    text("Spread",200,0);
  }
  if(!mv){
    fill(#FF6699);
    text("Gather",200,0);
  }
  textSize(12);
  fill(#FFFFFF);
  text("FPS:"+round(frameRate),width-40,0);
}

void mousePressed(){
  mv = false;
}

void mouseReleased(){
  mv = true;
}

void keyPressed() {
  if (key == '1') {
    r++;
  }
  if (key == '2') {
    r--;
  }
  if (key == '3') {
    num+=10;
  }
  if (key == '4') {
    num-=10;
  }
  if (key == '5') {
    ranger+=10;
  }
  if (key == '6') {
    ranger-=10;
  }  
}

void mouseWheel(MouseEvent event){
  float e = event.getCount();
  if(r>=0){
      if(e == -1) r+=10;
      if(e == 1) r-=10;
  }
  if(r<0){
    r=0;
  }
}

void PressedControl(){
  fill(255,5+HP,0);
  rect(0,19,HP,7);
  if(!mv && HP>=0){
    HP-=1;
  }
  else{
    if(HP<=250){
      HP+=0.1;
    }
  }
  if(HP <= 0 && num>=100 && r>10){
    num-=25;
    r-=1;
  }
}

class Attractor {
  float mass;    
  float G;       
  PVector position;   
  PVector dragOffset;

  Attractor() {
    position = new PVector(width/2,height/2);
    mass = 20;
    G = 1;
    dragOffset = new PVector(0.0,0.0);
  }
    PVector attract(Mover m) {
    PVector force = PVector.sub(position,m.position);   
    float d = force.mag();                              
    d = constrain(d,5.0,25.0);                        
    force.normalize();                                  
    float strength = (G * mass * m.mass) / (d * d);      
    force.mult(strength);                                 
    return force;
  }
  
  void drag() {
    position.x = mouseX + dragOffset.x;
    position.y = mouseY + dragOffset.y;
  }
}

class Mover {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float mass;

  Mover(float m, float x, float y) {
    mass = m;
    position = new PVector(x, y);
    velocity = new PVector(1, 0);
    acceleration = new PVector(0, 0);
  }

  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }

  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    acceleration.mult(0);
  }

  void display() {
    fill(255,255,255);
    rect(position.x, position.y, mass*3+2, mass*3+2);
    if(num>50){
      if(distance(position.x,position.y,mouseX,mouseY) <= eatr+5){
          r-=0.1;
          num-=2.5;
      }
    }
  }
}
