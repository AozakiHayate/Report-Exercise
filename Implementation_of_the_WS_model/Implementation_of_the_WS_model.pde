//グラフ描画のサンプルプログラム

int Length = 400;
int Max_Node = 200;
int Node_number = 2;

Node[] Test_Node = new Node[Max_Node];

//初期化部
void setup() {
  size(Length,Length);
  background(0);
  smooth();
  frameRate(1); //フレームレートはゆっくりに設定
  
  //Node_numberの数だけノードを配置します
  for(int i=0;i<Node_number;i++){
    int k1 = int(random(Length));
    int k2 = int(random(Length));
    Test_Node[i] = new Node(k1,k2);
    Test_Node[i].link_number = Node_number;
    for(int j=0;j<Node_number;j++){
      Test_Node[i].link[j] = j;
    }   
  }  
  
}


//メイン部分
void draw() {
  
    Node_number++; //ノードを1個ずつ増やしてゆきます
    
    //新規に発生したノードの位置はランダムに設定
    int k1 = int(random(Length));
    int k2 = int(random(Length));
    Test_Node[Node_number-1] = new Node(k1,k2);
    
    //新規に発生させたノードの次数をランダムに設定します
    Test_Node[Node_number-1].link_number = int(random(Node_number));
    
    for(int i=0; i< Test_Node[Node_number -1].link_number; i++){
      //上記で設定した次数に基づき、リンク相手をランダムに選びます
      Test_Node[Node_number-1].link[i] = int(random(Node_number));
    }
    
  fadeToWhite();
 
  //ノードを描画します
   for(int j=0; j < Node_number; j++){
       Test_Node[j].draw();
    }

  //リンク（エッジ）を描画します
   for(int j=0; j < Node_number; j++){
     for(int i=0; i< Test_Node[j].link_number; i++){
       stroke(255);
       line(Test_Node[j].xpos,Test_Node[j].ypos, Test_Node[Test_Node[j].link[i]].xpos, Test_Node[Test_Node[j].link[i]].ypos);
    }
   }
    
}

//ノードのクラス
class Node
{

  int xpos; //x座標
  int ypos; //y座標
  int link_number; //当該ノードの次数
  int [] link = new int[Max_Node]; //リンクの相手先情報を格納

  
  Node(int xp, int yp) {
    xpos = xp;
    ypos = yp;
  }

  void draw () {
      noStroke();
      fill(0,0,200);
      ellipse(xpos,ypos,15,15);
  }
}


void fadeToWhite(){
  rectMode(CORNER);
  fill(0,0,0,50);
  rect(0,0,width,height);
}
