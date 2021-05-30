// Cellular Automata example for linear cell patterns
// by Takehiko Nagakura (rev. 2013.4.31)

// Cells are array of black or white squares
// Each takes a state of 1 or 0: 1 means white cell. 0 means black cell
// This is the initial states of cells.
// You may change the number of elements in this array of cells.

int[] init_cells = {1,0,1,0,0,0,0,1,0,1,1,1,0,0,0,1,1,1,0,0,1,0,1,0,0,0,0,1,0,1,1,1,0,0,0,1,1,1,0,0,1,0,1,0,1,1,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0};
//int[] init_cells = {1,0,1,0,0,0,0,1,0,1,1,1,0,0,0,1,1,1,0,0};


/////////////////////////////////////////////////////////////////////////////////////////////////////

// This array keeps the current states of the cells.
int[] cur_cells = new int[init_cells.length]; //[bold]

// Another array to temporarily store (copy) the states of the cells
// when you compute the transformation of cells into next generation.
int[] new_cells = new int[init_cells.length]; //[bold]

// Size of cell drawn on the screen.
int cellsize = round ((900 - 220) / (init_cells.length + 4)) ;
// Counter for generation iteration.
int counter = 0;
// If 1, this flags signals restaring of cellular computation with new rules/initial state
int reset_flag = 1;

// Positions of the topleft corner of the row of initial cells
int init_row_left_pos = round(80 + cellsize * 3 + 60);
int init_row_top_pos = cellsize;

void setup() {
  size(1000,1200);
  init_rules();  // Set up the initial rules that a user may change edit later
}

void draw()  {
  delay(1); // slow down the iteration a bit.
  
  if (reset_flag ==1) { // if a rule or init state is changed, starts from scratch.
    arrayCopy(init_cells, cur_cells); // initialize
    arrayCopy(init_cells, new_cells); // initialize
    // draw the first row separately at the top
    background(255);
    counter = 0;
    reset_flag=0;
  }
  
  draw_cell_row (init_cells, init_row_left_pos, init_row_top_pos, false, true); 
  draw_rules();
  counter = counter + 1;

  // compute the next generation  
  for (int i = 1; i < cur_cells.length-1; i++) {
    // You will look at 3 adjacent cells. Depending on what
    // colors they have, you will decide the color of the
    // center cell for the next generation.
    int left   = cur_cells[i-1];
    int middle = cur_cells[i];
    int right  = cur_cells[i+1];
    
    // The transformation rule is described in a separate function.
    // Temporarily saves the new state (color) in the new array
    new_cells[i] = apply_rule(left,middle,right);
  }
  
  // Copy the new generation cells to the current generation.
  arrayCopy(new_cells, cur_cells); // initialize
  //cur_cells = new_cells; //[bold]
  // Draws the new row of cells
  draw_cell_row (cur_cells, 
    init_row_left_pos, init_row_top_pos + cellsize * (counter + 1), true, false) ;
}

/////////////////////// cells ///////////////////////////////////////////

 // This draws a row of cells. Topleft corner of the row is x=top, y=left.
void draw_cell_row(int[] cells, int left, int top, Boolean show_counter, Boolean hilite_mouse_over) {
    if (show_counter){
    fill(0);
    text(counter, left - 20, top + 15);
    }
    // Loop through every cell to draw them on screen.
    for (int i = 0; i < cells.length; i++) {
      draw_one_cell(left + i*cellsize, top, cells[i], hilite_mouse_over);
  }
}

 // This draws one cell (white or black) at a given position.
void draw_one_cell(int posx, int posy, int state, Boolean hilite_mouse_over) {
  if (state == 1) fill(255); // white cell if the state is 1
  else fill(0); // black cell if the state is 0
  
  stroke(0); // Default black frame for each cell
  if (hilite_mouse_over) {
    if (mouseOverCell(posx, posy)) {
      stroke(color(150,150,150));
    }
  }
  rect( posx, posy, cellsize, cellsize );
}

/////////////////////// rules ///////////////////////////////////////////

// A rule is to compute the new color of a cell based on the
// current colors of that cell plus its left and right cells.

Rule[] rule;

class Rule {
  String label;
  int state_new = 0;  // 0 is black, 1 is white
  int state_left;
  int state_mid;
  int state_right;
  int posx=100; // positions are used for interactive display of the resulting cell state
  int posy=50; // (posx, posy) is the topleft corner of the cell showing the new state
  
  // Contructor
  Rule(String name, int left, int mid, int right, int newstat) {
    label=name;
    state_left=left;
    state_mid=mid;
    state_right=right;
    state_new=newstat;
  }
  
  void draw() {
    int text_x = posx - cellsize - 50;
    int row_y = posy - round(cellsize*1.5);
    fill(0);
    textSize(12);
    text(label, text_x, row_y + 15);
    draw_one_cell(posx-cellsize, row_y, state_left, false);
    draw_one_cell(posx, row_y, state_mid, false);
    draw_one_cell(posx+cellsize, row_y, state_right, false);
    draw_one_cell(posx, posy, state_new, true);
  }
 }
 
 // Here we have 8 rules.
 void init_rules(){
    rule = new Rule[8];
    rule[0]=new Rule("Rule 01", 1,1,1,0);
    rule[1]=new Rule("Rule 02", 1,1,0,1);
    rule[2]=new Rule("Rule 03", 1,0,1,0);
    rule[3]=new Rule("Rule 04", 1,0,0,1);
    rule[4]=new Rule("Rule 05", 0,1,1,1);
    rule[5]=new Rule("Rule 06", 0,1,0,0);
    rule[6]=new Rule("Rule 07", 0,0,1,1);
    rule[7]=new Rule("Rule 08", 0,0,0,0);
    for (int i = 0; i < rule.length; i++) {
      rule[i].posy = round(cellsize * 2.5) + i * cellsize * 3;   
    }
 }


// Computes the new state of a cell from its previous state and two adjacent cells
int apply_rule (int a, int b, int c) {
    int result=0;
    for (int i = 0; i < rule.length; i++) {
      if (rule[i].state_left == a && rule[i].state_mid == b && rule[i].state_right == c){
        result = rule[i].state_new;
      }
    }
    return result;
}
  
void draw_rules () {
  for (int i = 0; i < rule.length; i++) {
    rule[i].draw();
  }
}


/////////////////////// mouse ///////////////////////////////////////////

// This returns the id of the rule if the mouse is inside the cell for its new state.
// If nothing is hit, returns -1.
int mouseOverRule() {
  int hit=-1;
  for (int i = 0; i < rule.length; i++) {
    if (mouseOverCell(rule[i].posx, rule[i].posy)){
      hit = i;
    }}
  return hit;
}

// This returns the id of the cell in the initial row if the mouse is inside the cell.
// If nothing is hit, returns -1. It uses hard-coded positions.
int mouseOverInitCell() {
  int hit=-1;
  int left;
  int top;
  for (int i = 0; i < init_cells.length; i++) {
    if (mouseOverCell(init_row_left_pos + i*cellsize, init_row_top_pos)){
      hit = i;
    }}
  return hit;
}

Boolean mouseOverCell(int xloc, int yloc){
  int x=mouseX;
  int y=mouseY;
  return x>xloc && x<xloc+cellsize && y>yloc && y<yloc + cellsize;
  }
  
void mousePressed() {
  int hit = mouseOverRule();
  if(hit!=-1) {
    rule[hit].state_new=(rule[hit].state_new + 1) % 2;  // flip the state
    reset_flag =1; 
  }
  
  hit = mouseOverInitCell();
  if(hit!=-1) {
    init_cells[hit]=(init_cells[hit] + 1) % 2;  // flip the state
    reset_flag =1; 
  }
}

