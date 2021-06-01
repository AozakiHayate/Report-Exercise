

int sx, sy; 
float density = 0.5; 
int[][][] world;
int b_size = 10;
int counter = 0;

void setup() 
{ 
  size(400, 400);
  colorMode(HSB,100);
  background(100);
  frameRate(1);  //frame speed change
  sx = width;
  sy = height;
  world = new int[sx][sy][2]; 
  stroke(255); 
  noStroke();
  smooth();
  
 /*  lightweight spaceship
  world[30][30][1] = 1;
  world[60][30][1] = 1;
  world[70][40][1] = 1;
  world[30][50][1] = 1;
  world[70][50][1] = 1;
  world[40][60][1] = 1;
  world[50][60][1] = 1;
  world[60][60][1] = 1;
  world[70][60][1] = 1;
  */
  
/* Kok's galaxy */
  for (int i = 0; i < 6; i++) {
    world[40][40+i*10][1] = 1;
    world[50][40+i*10][1] = 1;
    world[40+i*10][110][1] = 1;
    world[40+i*10][120][1] = 1;
    world[110][70+i*10][1] = 1;
    world[120][70+i*10][1] = 1;
    world[70+i*10][40][1] = 1;
    world[70+i*10][50][1] = 1;

  }
  
/*  random parameter 
   for (int i = 0; i < sx * sy * density; i++) { 
    world[(int)random(sx)][(int)random(sy)][1] = 1; 
  } 
  */
} 
 
void draw() 
{ 

  fadeToWhite(); 
  counter = counter + 1;
  
  if((counter % 3) == 1){
 
  for (int x = 0; x < width; x=x + b_size) { 
    for (int y = 0; y < height; y=y + b_size) { 
   
      if ((world[x][y][1] == 1) || (world[x][y][1] == 0 && world[x][y][0] == 1)) 
      { 
        world[x][y][0] = 1; 
 
          fill(60,90,100);  
          ellipse(x, y, b_size, b_size);

      } 
      if (world[x][y][1] == -1) 
      { 
        world[x][y][0] = 0; 
      } 
      world[x][y][1] = 0; 
    } 
  } 


  for (int x = 0; x < width; x=x+b_size) { 
    for (int y = 0; y < height; y=y+b_size) { 
      int count = neighbors(x, y); 
      if (count == 3 && world[x][y][0] == 0) 
      { 
        world[x][y][1] = 1; 
      } 
      if ((count < 2 || count > 3) && world[x][y][0] == 1) 
     { 
        world[x][y][1] = -1; 
      } 
    } 
  }
  }
} 

 

int neighbors(int x, int y) 
{ 
  return world[(x + b_size) % sx][y][0] + 
         world[x][(y + b_size) % sy][0] + 
         world[(x + sx - b_size) % sx][y][0] + 
         world[x][(y + sy - b_size) % sy][0] + 
         world[(x + b_size) % sx][(y + b_size) % sy][0] + 
         world[(x + sx - b_size) % sx][(y + b_size) % sy][0] + 
         world[(x + sx - b_size) % sx][(y + sy - b_size) % sy][0] + 
         world[(x + b_size) % sx][(y + sy - b_size) % sy][0]; 
} 

void fadeToWhite(){
  rectMode(CORNER);
  fill(100,10,100,66);     // blue & red
  rect(0,0,width,height);
}

