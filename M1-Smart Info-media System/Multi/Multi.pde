//マルチエージェントシミュレータ 改

// by Hajime Nobuhara and HAO YIYANG
//　+季節機能+増殖機能

int Length = 400; //空間管理配列の大きさ
int Max_Human = 1000; //シミュレータに登場させる人間の数

int Ini = 20; //現在の人間数
int Dead = 0;//死ぬ人間
int Alive = Ini;//生きる人間

int Season; // 季節の導入
float Food;//各季節に対する食品の現れる確率差別化する
int Time;  // 　季節変化の時間カウント

//空間管理配列を準備
int[][] MAP = new int[Length][Length]; 
//人間の配列を準備
Human_class[] Human = new Human_class[Max_Human];

//初期化部
void setup() {
  colorMode(HSB);
  size(Length, Length+150);
  background(0);
  frameRate(60);
  
  Season = 1;  // 春からスタート
  for(int i=0; i < Ini; i++){
     int k1 = 1;
     int k2 = int(random(width));
     int k3 = int(random(height-150));
     int k4 = int(random(5));
     int k5 = int(random(5));
     int k6 = 500 +int(random(200)); //初期化人間のhp 500-700
     Human[i] = new Human_class(k1,k2,k3,k4,k5,k6);
  }
  
  for(int i=0; i< Length; i++){
    for(int j=0; j< Length; j++){
      MAP[i][j] = 0;
    }
  }
}

void draw() {
 
 makeground();
 season_change();
 Food = (300*(Season))/10 + 10;//    食物の生成率
 for(int j=0; j < Ini; j++){
  
   if(Human[j].type == 1){
     Human[j].timer ++;  
     Human[j].draw(); 
     Human[j].Text();
     Human[j].hp = Human[j].hp - 1;
     
     if(Human[j].hp < 0){
       Human[j].type = 0;
       MAP[Human[j].xpos][Human[j].ypos] = 0;
       Dead++;
       Alive--;
     }
     
     
   }
 }

  for(int j=0; j < Ini; j++){
     if(Human[j].type == 1){
       Human[j].drive();
     }
  }
  
  for(int j=0; j < Ini; j++){
    if(Human[j].type == 1){
     Human[j].coll();
    }
  }
  
  for(int j=0; j < Ini; j++){
     if(Human[j].type == 1){
       Human[j].eat();
    }
  }
  
  if(int(random(1000)) < Food){   //季節により、食物生成率の変化
    MAP[int(random(Length))][int(random(Length))] = 2;
  }
  
  for(int i=0; i < Length ; i++){
    for(int j=0; j < Length; j++){
      if(MAP[i][j] == 2){
        fill(30,255,255);
        ellipse(i,j,10,10);
        fill(35,255,255);
        ellipse(i,j,8,8);
        fill(45,255,255);
        ellipse(i,j,5,5);
        
        stroke(145,255,255);
        line(i-1,j-5,i-1,j-8); 
        line(i,j-5,i,j-7); 
        noStroke();    
      } 
    }
  }
  
}

class Human_class
{

  int xpos; //x座標
  int ypos; //y座標
  int type; //人間の状態
  int direction; //人間の動作方向
  int timer; //体内時計
  int hp;//体力
    
  Human_class(int c, int xp, int yp, int dirt, int t, int h) {
    xpos = xp;
    ypos = yp;
    type = c;
    direction = dirt;
    timer = t;
    hp = h;
  }



 void draw () {
 
    smooth();
    noStroke();
    fill(100,255,255);
    
    if(hp < 100){
      fill(40,255,255);
    }
  
    if(hp < 50){
       fill(10,255,255);
    }   
    
    int Time = timer % 5;
    switch(Time){
      
      case 0:
        ellipse(xpos,ypos,6,6);
        rect(xpos-3,ypos+3,6,5); 
        rect(xpos-3,ypos+8,3,5); 
        rect(xpos-4,ypos+3,2,5); 
        rect(xpos+2,ypos+3,2,5); 
        break;
      case 1:
        ellipse(xpos,ypos,6,6);
        rect(xpos-3,ypos+3,6,5);
        rect(xpos-3,ypos+8,3,4);
        rect(xpos,ypos+8,3,1);        
        break;
       case 2:
        ellipse(xpos,ypos,6,6);
        rect(xpos-3,ypos+3,6,5);
        rect(xpos-3,ypos+8,3,3);
        rect(xpos,ypos+8,3,3);
        break;
        case 3:
        ellipse(xpos,ypos,6,6);
        rect(xpos-3,ypos+3,6,5);
        rect(xpos-3,ypos+8,3,1);
        rect(xpos,ypos+8,3,4);
        break;
        case 4:
        
        //5枚目
        ellipse(xpos,ypos,6,6);
        rect(xpos-3,ypos+3,6,5);
        rect(xpos,ypos+8,3,5);
        rect(xpos-4,ypos+3,2,5); 
        rect(xpos+2,ypos+3,2,5); 
        break;
        
    }
    fill(0);
    rect(0,400,400,150);
  }

void Text() {
  fill(255);
  textSize(30);
  text("Alive:"+Alive,130,440);
  text("Dead:"+Dead,125,480);
  if(Season == 0) {
    text("Season:Winter",98,520);
  }
  else if(Season == 1) {
    text("Season:Spring",98,520);
  }
  else if(Season == 2) {
    text("Season:Summer",98,520);
  }
  else if(Season == 3) {
    text("Season:Autumn",98,520);
  }
}

void drive () {
    
    if(random(100) < 5){
      direction = int(random(5));
    }
    
    switch(direction){
      case 0:
        break;
    
      case 1:
          MAP[xpos][ypos] = 0;
          xpos = (xpos + 1 + width) % width;
          break;
          
      case 2:
          MAP[xpos][ypos] = 0;
          xpos = (xpos - 1 + width) % width;
          break;
          
      case 3:
          MAP[xpos][ypos] = 0;
          ypos = (ypos + 1 + height-150) % (height-150);
          break;
      
     case 4:
          MAP[xpos][ypos] = 0;
          ypos = (ypos - 1 + height-150) % (height-150);
          break;
    }
     
   
   MAP[xpos][ypos] = type;  
    
  }
  
    //衝突の判定
  void coll() {
    //自分の周囲 10x10 の範囲を探索して、他人がいたら避けるようにする
    for(int i = -10; i < 10; i++){
      for(int j = -10; j < 10; j++){
        if (MAP[(xpos+i+width) % width][(ypos+j+height-150) % (height-150)] == 1){
          
          MAP[xpos][ypos] = 0;
          //相手から2画素分逃げるようにする
          if(i < 0){
            xpos = (xpos + 2 + width) % width; 
          }
          if(i > 0){
            xpos = (xpos - 2 + width) % width;
          }
          //相手から2画素分逃げるようにする
          if(j < 0){
            ypos = (ypos + 2 + height-150) % (height-150);
          }
          if(j > 0){
            ypos = (ypos - 2 + height-150) % (height-150);
          }
          
          MAP[xpos][ypos] = type; 
          
       
        }
      }
    }
  }
  
  //食べ物の獲得
  void eat(){
    
    int action = 0;
    
    for(int r = 0; r < 100; r++){
      for(int s = 0; s < 360; s=s+10){
          
      int i = int(r * cos(radians(s)));
      int j = int(r * sin(radians(s)));
          
      if ((MAP[(xpos+i+width) % width][(ypos+j+height-150) % (height-150)] == 2)){       
        
            MAP[xpos][ypos] = 0;
             
            if((i > 0)&&(action==0)){
              direction = 1;
              xpos = (xpos + 1 + width) % width;
              action = 1;
            }
            
            if((i < 0)&&(action==0)){
               direction = 2;
               xpos = (xpos - 1 + width) % width;
               action = 1;
            }
          
            if((j > 0)&&(action==0)){
              direction = 3;
              ypos = (ypos + 1 + height-150) % (height-150);
              action = 1;
            }
            if((j < 0)&&(action==0)){
              direction = 4;
              ypos = (ypos - 1 + height-150) % (height-150);
              action = 1;
            }       
      }
      if(action == 1)
       break;
      }
    }
    if((MAP[xpos][ypos] == 2)){
      hp = hp + 500;
    }
    MAP[xpos][ypos] = 1;
  }
}


void makeground(){
  if(Season == 0) {
   fill( 0,5,255);
   rect(0,0,width,height);  
  }
  else if(Season == 1) {
   fill( 50,200,150);
   rect(0,0,width,height);  
  }
  else if(Season == 2) {
   fill( 80,200,100);
   rect(0,0,width,height);  
  }
  else if(Season == 3) {
   fill( 20,250,80);
   rect(0,0,width,height);  
  }
}



void season_change(){
  Time ++;
  if((Time == 300) && (Season < 3)){
    Season++;
  }
  else if((Time == 300) && (Season == 3)) {
    Season = 0;
  }
  
  int tmp = Ini;
  
  for(int i = 0; i < tmp; i++){
    if(  Ini <= Max_Human-1 && Human[i].hp >= 800){
      Ini++;
      Alive++;
      Human[i].hp = Human[i].hp - 100;
      Human[Ini-1] = new Human_class(1, Human[i].xpos,Human[i].ypos,
                                      int(random(5)),int(random(5)),200 + int(random(200)));
                                      //担当する人間の位置から新たな人間増殖する
    }
  }
  if(Time > 300){
    Time = 0;
  }
}

void mousePressed() {
 saveFrame("Capture-####.png"); 
}

