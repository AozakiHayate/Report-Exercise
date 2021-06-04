Park park;
int road=30;
int[] space = new int[15];
int generate = 0;
int car_number =0;
int c = 2;

void setup() {
  size(515*c, 160*c);
  park = new Park();
  frameRate(60);
//  for (int i = 0; i<14 ; i++) {
//    space[i] = 1 ;
//  }
}

void draw() {
  background(150);
  drawbackground();
  generate++;
  park.run();
  new_car();
}


void mousePressed() {
  //park.addCar(new Car(0,105*c));
  saveFrame("Car_Simulator-####.png");
}

void new_car() {
  int count =0;  
  for(int i = 0; i<15;i++){
    count = count + space[i];
  }
  if(generate%(50*c) == 1 && generate >= 50*c && car_number<= 20) {
      park.addCar(new Car(0,105*c));
      car_number++;
    }
}

void drawbackground() {
  
  //Road Border
  noStroke();
  fill(0);
  rect(0,10*c,80*c,height-80*c,0,0,0,0);
  fill(0);
  rect(0,0,width,10*c);
  rect(0,height-10*c,width,10*c);
  rect(width-10*c,0,10*c,height);
  rect(width-10*c,0,10*c,10*c,-12*c);
  rect(70*c,0,10*c,10*c,-12*c);
  rect(width-10*c,height-10*c,10*c,10*c,-12*c);
  
  
  
  //Line and marks
  fill(255);
  rect(0,height-40*c,width-40*c,2*c);
  //right arrow
  rect(35*c,height-57*c,15*c,4*c);
  triangle(50*c,height-61*c,50*c,height-49*c,56*c,height - 55*c);
  //left arrow
  rect(41*c,height-27*c,15*c,4*c);
  triangle(41*c,height-31*c,41*c,height-19*c,35*c,height - 25*c);
  //turn right arrow
  rect(width-31*c, height-27*c,10*c,4*c);
  rect(width-25*c,height-37*c,4*c,10*c);
  triangle(width-31*c,height-30*c,width-31*c,height-20*c,width-37*c,height-25*c);
  
  rect(width-35*c, 22*c,10*c,4*c);
  rect(width-25*c,22*c,4*c,10*c);
  triangle(width-28*c,32*c,width-18*c,32*c,width-23*c,38*c);
  
  textSize(12*c);
  text("PARKING",14*c,40*c);
  text("SIMULATOR",6*c,65*c);
  
  
  //Parking Space
  //Background
  
  fill(75);
  noStroke();
  rect(90*c,40*c,385*c,50*c,15);
  
  //Line
  for(int i = 0; i< 15; i++) {
    fill(75);
    stroke(255);
    strokeWeight(2*c);
    rect((97+i*25)*c,49*c,20*c,32*c);
  }
}

class Park {
  ArrayList<Car> cars; // An ArrayList for all the cars

  Park() {
    cars = new ArrayList<Car>(); // Initialize the ArrayList
  }

  void run() {
    for (Car c : cars) {
      c.run(cars);  // Passing the entire list of cars to each car individually
    }
  }
  
  void addCar(Car c) {
    cars.add(c);
  }
  
}




// The Car class

class Car {

  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    
  float maxspeed;    
  int angle;
  int tl_flag = 0;
  int tr_flag = 0;
  int pk_flag = 0;
  int draw_flag =1;
  int stop_flag =0;
  
    Car(float x, float y) {
    acceleration = new PVector(0, 0);
    angle = 0;
    velocity = new PVector(cos(angle)*c, sin(angle)*c);
    position = new PVector(x, y);
    r = 10.0*c;
    maxspeed = 1*c;
    maxforce = 0.05*c;
  }

  void run(ArrayList<Car> cars) {
    park(cars);
    stop1(cars);
    update();
    borders();
    render();
    //println(tl_flag);
  }

  void applyForce(PVector force) {
    acceleration.add(force);
  }

  void park(ArrayList<Car> cars) {
    PVector tr  = turnround(cars);  // Turn round force
    PVector sep = separate(cars);
    sep.mult(4.0);
    tr.mult(1.0);
    applyForce(tr);
    applyForce(sep);
  }

  // Method to update position
  void update() {
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    approximation();
    turnround();
    parking();
    if(pk_flag != 1 && stop_flag != 1) {
      position.add(velocity);
    }
    //saveFrame("Moive-#####.png");
    acceleration.mult(0);
  }
  
  void render() {
    float theta = velocity.heading2D() + radians(90);
    if(draw_flag == 1){
      pushMatrix();
      translate(position.x, position.y);
      rotate(theta);
      stroke(0);
      strokeWeight(1*c);
      fill(255,150,50);
      rect(-5*c,-10*c,10*c,20*c,10);
      fill(255);
      rect(-3*c,1*c,6*c,5*c);
      fill(0);
      rect(5*c,3*c,2*c,4*c);
      rect(-7*c,3*c,2*c,4*c);
      rect(5*c,-6*c,2*c,4*c);
      rect(-7*c,-6*c,2*c,4*c);
      popMatrix();
    }
  }

  void borders() {
    if (position.x < -r*c) {
      draw_flag = 0;
    }
    if (position.x <= -r*c && position.x > (-r-1)*c) {
      car_number--;
    }
    if (position.y < -r*c) {
      draw_flag = 0;
    }
    if (position.x > width+r*c) {
      draw_flag = 0;
    }
    if (position.y > height+r*c) {
      draw_flag = 0;
    }
  }

  //turn round
  PVector turnround (ArrayList<Car> cars) {
    float theta = velocity.heading2D();
    PVector tr = new PVector(0,0,0);
    for (Car other : cars) {
      if (tl_flag == 1) {
        if(velocity.x != 0.0 || velocity.y != 1.0*c) {
          PVector diff_tl = new PVector(0,-0.22*c);
          tr.add(diff_tl);
          break;
        }
      }
      if (tr_flag == 1) {
        if((velocity.x != 1.0*c || velocity.y != 0.0) && position.x < width -35*c && position.y <= 33*c) {
          PVector diff_tl = new PVector(0.22*c,0);
          tr.add(diff_tl);
          break;
        }
        if((velocity.y != 1.0*c || velocity.x != 0.0) && position.x >= width-35*c && position.y <= height - 35*c) {
          PVector diff_tl = new PVector(0,0.15*c);
          tr.add(diff_tl);
          break;
        }
        if((velocity.y != 0.0 || velocity.x != -1.0*c) && position.y >= height -32*c) {
          PVector diff_tl = new PVector(-0.22*c,0);
          tr.add(diff_tl);
          break;
        }
      }
      if (tr.mag() > 0) {
      tr.normalize();
      tr.mult(maxspeed);
      tr.sub(velocity);
      tr.limit(maxforce);
      }
    }
    if(theta == -HALF_PI){
        tl_flag = 0;
      }
      if(velocity.x == 1.0*c && position.x <= width-40*c){
        tr_flag = 0;
      }
      if(velocity.y == 1.0*c && position.y <= height -80*c){
        tr_flag = 0;
      }
    return tr;
  }
  
 void approximation() {
    if(0.00 <= velocity.x && velocity.x <=0.01){
      velocity.x = round(velocity.x);
    }
    if(0.00 >= velocity.x && velocity.x >= -0.01){
      velocity.x = round(velocity.x);
    }
    if(0.00 <= velocity.y && velocity.y <=0.01){
      velocity.y = round(velocity.y);
    }
    if(0.00 >= velocity.y && velocity.y >= -0.01){
      velocity.y = round(velocity.y);
    }
    if(1.00 >= velocity.y && velocity.y >= 0.99){
      velocity.y = round(velocity.y);
    }
    if(-1.00 <= velocity.y && velocity.y <= -0.99){
      velocity.y = round(velocity.y);
    }
    if(1.00 >= velocity.x && velocity.x >= 0.99){
      velocity.x = round(velocity.x);
    }
    if(-1.00 <= velocity.x && velocity.x <= -0.99){
      velocity.x = round(velocity.x);
    }
  }
  
  void parking() {
    float time = 1.00;
    for(int i =0; i<15; i++) {
      if(position.y >= 64.00*c && position.y <= 66.00*c){
        if(position.x >= (95+i*25)*c && position.x <= (115 + i*25)*c) {
          pk_flag = 1;
          space[i] =1;
        }
        if(time > int(random(2000)) && position.x >= (95+i*25)*c && position.x <= (115 + i*25)*c) {
          pk_flag = 0;
          space[i] =0;
          position.add(velocity);
        }
      }
    }
  }
  
  void turnround() {
    for(int i =0; i<15;i++) {
        PVector c1 = new PVector((105-6+i*25)*c,height-55*c);
        float d = PVector.dist(position,c1);
        if(d < 0.1*c && space[i] != 1) {
          tl_flag = 1;
        }
    }
    if(position.x >= 480*c && position.y == height - 55*c) {
      tr_flag = 1;
    }
    if((position.y <= 25.00*c + 8.00*c) && (position.x <= width - 40*c) && velocity.y != 0.0 ) {
      tr_flag = 1;
    }
    if(position.y <= 60*c && position.x >= width - 35*c ){
      tr_flag = 1;
    }
    if(position.x >= 40*c && position.y >= height - 40*c) {
      tr_flag = 1;
    }
    if(position.x>=90*c && position.x<=width-10*c && position.y>=10*c && position.y <= 40*c && velocity.x < 1*c) {
      tr_flag = 1;
    }
  }
  
  //keep distance
  PVector separate (ArrayList<Car> cars) {
    float desiredseparation = 24;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    for (Car other : cars) {
      if(position.y == other.position.y || position.x == other.position.x) {
        float d = PVector.dist(position, other.position);
        if ((d > 0) && (d <= desiredseparation)) {
          PVector diff = PVector.sub(position, other.position);
          diff.normalize();
          diff.div(d);      
          steer.add(diff);
          count++;         
        }
      }
    }
    if (count > 0) {
      steer.div((float)count);
    }
    if (steer.mag() > 0) {
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }
  
   void stop1(ArrayList<Car> cars) {
    stop_flag = 0;
    PVector stop1 = new PVector (0,0,0);
    for(int i =0; i<15; i++) {
      for (Car other : cars) {
        if(other.position.x > position.x-40*c && other.position.x <= position.x+15*c && other.position.y <=40*c && position.x >= (95+i*25)*c && position.x <= (115 + i*25)*c && position.y >= 50*c && position.y <= 64*c) {
              stop_flag = 1;
              break;
        }
      }
    }
  }
}
