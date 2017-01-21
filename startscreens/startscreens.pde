import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;


int status = 1;
PFont titleFont;
int waitTime;

String numPlayers = "OVER 9000";

boolean playerOneFound, playerTwoFound;

float titleX = width/2, titleY = -100;
float subX = 800, subY = 1000;

float faceFoundTextX = 800, faceFoundTextY = 450;

void setup() {
  size(1600, 900);

  titleFont = createFont("pixelated.ttf", 64);

  smooth();
  Ani.init(this);
}





void draw() {

  background(0, 0, 0);


  if (playerOneFound && playerTwoFound) {
    status = 1;
  } else {
     status = 0;
  }


  switch(status) {
  case 0: 

    // Title 
    Ani.to(this, 1.0, "titleX", width/2);
    Ani.to(this, 1.0, "titleY", height/2 - 50);
    textSize(64);
    textFont(titleFont);
    textAlign(CENTER, CENTER);
    text("Welcome.", titleX, titleY);

    waitTime++;

    // Subtitle
    if (waitTime > 100) {
      //Ani.to(this, 1.0, "subX", width/2);
      Ani.to(this, 1.0, "subY", height/1.8);
      textSize(24);
      text("Find a friend and face the screen to get started", subX, subY);
      
      
          Ani.to(this, 1.0, "faceFoundTextX", width/2);
    Ani.to(this, 1.0, "faceFoundTextY", 800);
    textAlign(CENTER, CENTER);

    textFont(titleFont);
    textSize(24);

    text(numPlayers + " of 2 people found", faceFoundTextX, faceFoundTextY);
    }


    break;
  case 1: 
    println("Countdown");  // Prints "One"
    
    int s = millis();
    println(s);


    break;
  case 2:
    println("Game");
    break;
  }
}


void mousePressed() {
  playerOneFound = true;
  playerTwoFound = true;
  
}

void mouseReleased() {
  
    playerOneFound = false;
  playerTwoFound = false;
}