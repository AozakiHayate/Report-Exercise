import gab.opencv.*;
import processing.video.*;
import java.awt.*;
 
Capture video;
OpenCV opencv;
PImage img;
 
//顔の増幅数
int N = 0;
int Range = 255;
//PCのサイズ
int app_width = 1980;
int app_height = 1080;
int d = 10; 
public class Face_grid
{
  //フィールド
  float x;//位置
  float y;
  int count;//カウンター
   
  Face_grid(float _x, float _y, int _count)//コンストラクタ
  {
    x = _x;
    y = _y;
    count = _count;
  }
  void paint(PImage fImage)//描画メソッド
  {
    int col;
    //countがRangeより大きくなったら減衰させる
    if(count >= Range)
      col = Range * 2 - count;
    else
      col = count;
    //imageを出力
    tint(255,255,255,col);//透明度を調節
    image(fImage, x, y);
    //出力の判定を行って状態を更新する
    if(count > Range * 2)
     {
       count = 0;//0で初期化する
       //新しい位置を決める
       x = random(app_width);
       y = random(app_height);
     }
    //この増加量を変えることで透明度の変わり方が変わる
    count += 5;//カウンターを増やす
  }
};  //Face_gridクラスの宣言の終わり
 
Face_grid[] face;  //Face_gridオブジェクトの宣言
 
void setup() {
  size(1080, 720);
  frameRate(30);
  face = new Face_grid[N];//Face_gridオブジェクトの箱をN個作る
  for(int i = 0; i < N; i++)
  { //以下は初めの設定
    float x = random(app_width);//位置
    float y = random(app_height);
    int count = (int)random(Range);//カウンター
    face[i] = new Face_grid(x, y, count);//それぞれのCircleオブジェクトを作る
  }
 
  //使用できるカメラのリスト
  String[] cameras = Capture.list();
 
  //カメラがなかった場合
  if (cameras.length == 0) {
 
    println("no camera");
    exit();  //終了
  } else {
 
    //カメラがあった場合は、リストを出力
    println("Cameras are");
    for (int i = 0; i < cameras.length; i++) println(cameras[i]);
 
    //キャプチャは半分のサイズにする
    video = new Capture(this, width/2, height/2, cameras[0]);  
    opencv = new OpenCV(this, width/2, height/2);
 
    //顔用のデータをロード  
    opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
    //目のデータをロード
    //opencv.loadCascade(OpenCV.CASCADE_EYE);  
    //口のデータをロード
    //opencv.loadCascade(OpenCV.CASCADE_MOUTH);
 
    video.start();  //キャプチャを開始
  }
}
void draw() {
  opencv.loadImage(video);  //ビデオ画像をメモリに展開
  background(0);  //背景黒
  //Debug用
  //image(video, 0, 0 );  //ビデオ画像を表示
  //顔の領域を描画
  //noFill();
  //stroke(0, 255, 0);
  //strokeWeight(3);
  Rectangle[] faces = opencv.detect();
  //複数人いる場合はここの数値が変わる
  println(faces.length);
 
  //顔検出
  if (0 < faces.length) {
    img = video.get(faces[0].x, faces[0].y, faces[0].width, faces[0].height);
    //rect(eyes[i].x, eyes[i].y, eyes[i].width, eyes[i].height);
    for (int j = 0; j < N; j ++){
      face[j].paint(img);
    }
  }
  image(video, 0, 0, video.width, video.height);//フレームごとに処理します
  video.loadPixels();
  if (0 < faces.length){
    print(faces[0].x);
    for (int i = faces[0].x - 20; i< faces[0].x + faces[0].width + 20; i+=d)
    {
      for(int j = faces[0].y - 20; j< faces[0].y + faces[0].height + 20; j+=d)
      {
        float r = red(video.pixels[i + j*video.width]); // 動画像の色を抽出します
        float g = green(video.pixels[i + j*video.width]);      
        float b = blue (video.pixels[i + j*video.width]);
        if(mousePressed)//マウスボタンの判定
        {
           fill(b,g,r); // RGB->BGR
           stroke(200,120,120); // 全体見やすいように線の色も変わります
           rect(i,j,d,d);//正方形でフレームを再描画します
        }
        else
        {
           fill(r,g,b);
           stroke(0,120,120);
           rect(i,j,d,d);
        }
     }
  }
  updatePixels();
  }
  
}
 
void captureEvent(Capture c) {
  c.read();
}
 
