//epidemic simulation:普通のシミュレーション
//HAO YIYANG 2021

int Length = 500;    //サイズ

int normal = 0;     //カウントのための正常人数
int sick = 0;       //カウントのための病気人数
int dead = 0;       //カウントのための死ぬ人数

float birth_rate = 0.2;  //出生率
int birth_time = 200;    //生まれる時間
int recure_time = 200;   //治す時間
float death_rate = 60;   //死亡率
int death_time =100;     //死亡時間

int Max_Human = 500;  //画面に登場させる人間の数
int Sick = 98;        //病気にならない確率
int time = 0;         //時間の初期化


int[][] MAP = new int[Length][Length];
Human[] UofT_Human = new Human[Max_Human];

void setup() {
  size(Length,Length+100);
  background(0);
  frameRate(60);
 //ここで人間を生成
  for(int i=0; i < Max_Human; i++){
    int k1 = int(random(100));
    //乱数を生成し、Sick以下ならば健常者、それ以外なら病気
    if(k1 < Sick){
      k1 = 1;
    }
    else{
      k1 = 2;
    }
     int k2 = int(random(Length));
     int k3 = int(random(Length));
     int k4 = 0;
     int k5 = 0;
     int k6 = 0;
     if(k1 == 1){
       k4 = 3 - int(random(5));
       if(k4 == 0) k4 = 1;
       k5 = 3 - int(random(5));
       if(k5 == 0) k5 = 1;
     }
     else{
       k4 = 2 - int(random(4));
       if(k4 == 0) k4 = 1;
       k5 = 2 - int(random(4));
       if(k5 == 0) k5 = 1;
     }
     UofT_Human[i] = new Human(k1,k2,k3,k4,k5,k6);
  }
  //空間の状態管理配列
  for(int i=0; i< Length; i++){
    for(int j=0; j< Length; j++){
      MAP[i][j] = 0;
    }
  }
}

//メインループ
void draw() {
 background(0);
 time++;
 //timeのカウント
 
 if(time % birth_time == 1 && time > birth_time && normal > 0){
   int birth = round(normal * birth_rate);
   int count = 0;
   
   for(int j = 0; j < Max_Human; j++){
     if(UofT_Human[j].condition == 3){
       int k4 = 0;
       int k5 = 0;
       k4 = 3 - int(random(5));
       if(k4 == 0) k4 = 1;
       k5 = 3 - int(random(5));
       if(k5 == 0) k5 = 1;
       UofT_Human[j] = new Human(1, int(random(Length)),int(random(Length)),k4,k5,0);
       count ++;
       if(count == birth){
         break;
       }
     }
   }
 }

 for(int j = 0; j < Max_Human; j++){
   if(UofT_Human[j].condition == 2 && UofT_Human[j].sick_time == recure_time){
       UofT_Human[j].condition = 1;
       UofT_Human[j].sick_time = 0;
   }
 }
 
 
 for(int j=0; j < Max_Human; j++){
     if(UofT_Human[j].condition != 3){
       UofT_Human[j].draw();
     }
  }

  for(int j=0; j < Max_Human; j++){
     if(UofT_Human[j].condition != 3){
       UofT_Human[j].drive();
     }
  }
 
  for(int j=0; j < Max_Human; j++){
     if(UofT_Human[j].condition != 3){
       UofT_Human[j].coll();
     }
  }
  
  normal = 0;
  sick = 0;
  for(int j=0; j < Max_Human; j++){  
    if(UofT_Human[j].condition == 1){
      normal++;
    }
    else if(UofT_Human[j].condition == 2){
      float dr = random(100);
      sick++;
      if(random(100) <= death_rate && UofT_Human[j].sick_time == int(recure_time/2)){
        UofT_Human[j].condition = 3;
        UofT_Human[j].sick_time = 0;
        dead++;
        MAP[UofT_Human[j].xpos][UofT_Human[j].ypos] = 3;
      }
    }
  }
  
  fill(255, 255, 255);
  textSize(20);
  text("Time= " + time  , 50, 520);
  text("Normal=" + normal , 50,540);
  text("Sickness=" + sick , 50,560);
  text("Dead=" + dead, 50,580);
  
  text("Birth Rate=" + birth_rate*100 + "%" , 280,520);
  text("Death Rate=" + death_rate + "%" , 280,550);
  text("Recure Time=" + recure_time , 280,580);   
  
  
}

//人間のクラスを定義
class Human
{

  int xpos; 
  int ypos; 
  int xvel; 
  int yvel;
  int sick_time; 
  int condition; 
  
  Human(int c, int xp, int yp, int xv, int yv, int st) {
    xpos = xp;
    ypos = yp;
    xvel = xv;
    yvel = yv;
    sick_time = st;
    condition = c;
  }
//もし健康ならば青、病気ならば赤を描画
  void draw () {
    if(condition ==1){
      fill(0,0,255);
      ellipse(xpos,ypos,4,4);
    }
    else{
      fill(255,0,0);
      ellipse(xpos,ypos,4,4);
      sick_time++;
    } 
  }

  void drive () {
    MAP[xpos][ypos] = 0;
    xpos = (xpos + xvel + Length) % Length;
    ypos = (ypos + yvel + Length) % Length;
    MAP[xpos][ypos] = condition;  
  }
 
   //衝突判定を行う部分
  void coll () {
    for(int i = -2; i < 3; i++){
      for(int j = -2; j < 3; j++){
        if ((MAP[(xpos+i+Length)%Length][(ypos+j+Length)%Length] > 0) && (i != 0) && (j != 0) && (MAP[(xpos+i+Length)%Length][(ypos+j+Length)%Length] != 3)){
          xvel = -xvel;
          yvel = -yvel;
          if(MAP[(xpos+i+Length)%Length][(ypos+j+Length)%Length] == 2){
            condition = 2;
          }     
        }
      }
    }
  }
}

void mousePressed() {
 saveFrame("10-#####.png");
}

