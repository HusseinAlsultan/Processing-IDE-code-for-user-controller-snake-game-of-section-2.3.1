
ArrayList<Integer> x = new ArrayList<Integer>();            //two arrays for individual snake parts
ArrayList<Integer> y = new ArrayList<Integer>();

int screenWidth = 30, screenHeight = 30, snakePart = 20;    //divide the game window to 30*30 of snake parts, each part is 20 pixel long

int[]x_direction={ 0, 0, 1, -1}, y_direction={ 1, -1, 0, 0};  //arrays for x and y directionmovement for the snake {up,down,right,left}
int direction = 2;                                            //initial direction of the snake is set to the right

int speed = 8;                                               //variable to set the initial speed of the frame rate for the snake
int foodX = 15, foodY = 15;                                   //position of the first piece of food

boolean gameover = false;

import processing.serial.*;                                 // import serial communication library
Serial port;                                                // Create object from Serial class
char val;                                                   // Data received from the serial port

void setup() { 
  
  size(600, 600);                                          //set screen window size in pixels
  x.add(0);                                                //initial values to draw the first part of the snake x(0,0)=0
  y.add(15);                                               //and give it its starting position at 0,300 oixel location y(0,0)=15
  String portName = Serial.list()[0];
  port = new Serial(this, portName, 9600);
}   

void draw() {  
  
  background(252, 240, 3);                        // set backgroung color to Yellow
  
  fill(3, 32, 252);                               //set snake color to Blue
  for (int i = 0; i < x.size(); i++) {            //draw each part of the snake
    rect( x.get(i)* snakePart, y.get(i) * snakePart, snakePart, snakePart); 
  }
  
  if (!gameover) {                                    //the game is running
    fill(219, 11, 11);                                //color of the food (Red)
    ellipse( foodX * snakePart + 10, foodY * snakePart + 10, snakePart, snakePart);     //draw the food
    
    textAlign(LEFT);                            //show Score text on the upper left corner on the screen
    textSize(25);
    fill(0);
    text("SCORE: " + x.size(), 10, 10, width - 20, 50);
    
    if ( frameCount % speed == 0 ) {      //this line will be excuted every "speed" times
      x.add( 0, x.get(0) + x_direction[direction]);    //making the snake to move
      y.add( 0, y.get(0) + y_direction[direction]);
      
      if (x.get(0) < 0 || y.get(0) < 0 || x.get(0) > screenWidth || y.get(0) > screenHeight) {      // check if the snake... 
        gameover = true;      //...outside the screen window then end the game
     }
      
      for ( int i = 1; i < x.size(); i++) {      //check if the snake intersect with itself
        if ( x.get(0) == x.get(i) && y.get(0)== y.get(i)) {
          gameover=true;                         //end the game
        }
      }
      if ( (x.get(0) + 1) == 0 || (y.get(0) + 1) == 0) println("Danger");
      
      if ( x.get(0) == foodX && y.get(0) == foodY) {       //intesection between the snake and the food
        foodX = (int)random(0, screenWidth);               //create new random position for the food
        foodY = (int)random(0, screenHeight);
        
        if ( x.size() % 5 == 0 && speed >= 2) {
          speed -= 1;                                      // every 5 points, speed decrease up to minimum of two
        }                           
      } 
      else { 
        x.remove(x.size()-1);         //remove the last pixel of the snake after each movement 
        y.remove(y.size()-1);         //so it does not become endless
      }
    }
    
  }
  
  else {
    background(252, 240, 3);                        // set backgroung color to Yellow
    fill(0);                                        //show text "GAME OVER"
    textSize(30); 
    textAlign(CENTER); 
    text("GAME OVER \n Your Score is: "+ x.size() +"\n Press ENTER", width/2, height/3);
    gameover = true;
    if (key == ENTER) {
      x.clear(); 
      y.clear(); 
      direction = 2;
      x.add(0);       
      y.add(15);
      speed = 12;
      gameover = false;
    }
  }
  
  if ( port.available() > 0) {        // If data is available,
  val = port.readChar();              // Read it and store it in val
  }       
  else if (val == 'D') {              // If the serial value is 'D' for Down
    direction = 0;
  }
  else if (val == 'U') {              // If the serial value is 'U' for Up
    direction = 1;
  }
  else if (val == 'R') {              // If the serial value is 'R' for Right 
    direction = 2;
  }
  else if (val == 'L') {              // If the serial value is 'L' for Left 
    direction = 3;
  }  
}
