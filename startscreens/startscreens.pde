import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;


int status = 1;
PFont titleFont;
int waitTime;

String numPlayers = "OVER 9000";

int elaspsedTime;

boolean playerOneFound, playerTwoFound, starting;

float titleX = width/2, titleY = -100;
float subX = 800, subY = 1000;

float faceFoundTextX = 800, faceFoundTextY = 450;
float countDownY = 400;

int startTime, elapsedTimeYes;
boolean beginGameTimer;



void setup() {
  size(1600, 900);

  titleFont = createFont("pixelated.ttf", 64);

  smooth();
  Ani.init(this);

  startTime = millis()/1000;
}





void draw() {


  if (playerOneFound && playerTwoFound && !starting) {
    status = 1;
  } else if (playerOneFound && playerTwoFound && starting) {
    status = 2;
  } else if (!playerOneFound && !starting) {
    status = 0;
  } 


  switch(status) {
  case 0: 
    background(0, 0, 0);
    // Title 
    Ani.to(this, 1.0, "titleX", width/2);
    Ani.to(this, 1.0, "titleY", height/2 - 50);
    textSize(64);
    textFont(titleFont);
    textAlign(CENTER, CENTER);
    text("Welcome.", titleX, titleY);


    //TESTING    

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
      starting = false;
      beginGameTimer = true;
    }


    break;
  case 1: 

    if (beginGameTimer == true) {
      background(0, 0, 0);
      elapsedTimeYes = 0;
    }
    beginGameTimer = false;
    // countdown from 3.. 2.. 1..

    elapsedTimeYes++;

    if (elapsedTimeYes == 100) {
      background(0, 0, 0);
      textSize(32);
      text("3", width/2, height/2);
    } else if (elapsedTimeYes == 200) {
      background(0, 0, 0);
      text("2", width/2, height/2);
    } else if (elapsedTimeYes == 300) {
      background(0, 0, 0);
      text("1", width/2, height/2);
    } else if (elapsedTimeYes == 400) {
      starting = true;
    }


    break;

  case 2:
    background(0, 0, 0);

    if ((!playerOneFound || !playerTwoFound) && starting) {
      textSize(20);
      textAlign(CENTER, CENTER);
      text("Player Lost. Reposition on screen", width/2, height/2 - 200);
    }


    textSize(64);
    text("This is the game! YAAAY", width/2, height/2);
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