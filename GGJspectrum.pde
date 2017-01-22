import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

/* 
 SUP DOGE!
 This is a global game jam 2017 game!
 More dox coming soon :D
 @authors Walter Lim, Sam Hunt
 Special thanks to Patrick Tuohy
 */

import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import javax.swing.*;      // Java Swing

Capture video;
OpenCV opencv;
Ball ball;

// Variables for game
int paddleLeftPosition = 300; //Initial Position of left paddle.
int paddleRightPosition = 300; //Initial position of right paddle.
float speed = 3; //Determines speed of paddles.
boolean wpress = false; //?
int leftState = 0; //State of left paddle, 0 is still, -1 is moving up, 1 is moving down.
int rightState = 0; //State of right paddle, 0 is still, -1 is moving up, 1 is moving down.
int lScore = 0; //Score of left player.
int rScore = 0; //Score of right player.
float boost = 0;
float boostTimer; 
ArrayList<Ball> balls = new ArrayList<Ball>();

// Variables for onboarding
int status = 0;
PFont titleFont;
int waitTime;
int numPlayers = 0;
int elapsedTime;
boolean playerOneFound, playerTwoFound, starting;
float titleX = width/2, titleY = -100;
float subX = 800, subY = 1000;
float faceFoundTextX = 800, faceFoundTextY = 450;
float countDownY = 400;
boolean beginGameTimer;
boolean startingCd;
int scale = 4;

PImage smaller;
void setup() {
  size(1600, 900);
  
  frameRate(60);
  
  
 
  
  // begin video stuff and
 // video = new Capture(this, 800, 600);

 // video.start();
  // end video stuff
  
  video = new Capture(this,640, 480);
  video.start();
  
  
  opencv = new OpenCV(this, video.width/scale, video.height/scale);
  
  
    // Which "cascade" are we going to use?
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE); 
 
  // Make scaled down image
  smaller = createImage(opencv.width,opencv.height,RGB);
  
  
  

  //begin game initialization and other crap - SPAWN THE BALLS!!
  balls.add(new Ball(400, 300, 10));

  // StartScreen Init
  titleFont = createFont("pixelated.ttf", 64);
  //smooth();
  Ani.init(this);
  

 
  
}

void draw() {
  println(frameRate);

  
   opencv.loadImage(smaller);
  Rectangle[] faces = opencv.detect();
  // Detect Players
  
  if (faces.length == 2){
    playerOneFound = true;
    playerTwoFound = true;
    
  }

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
     // numPlayers = faces.length;

      text(numPlayers + " of 2 people found", faceFoundTextX, faceFoundTextY);
      starting = false;
      beginGameTimer = true;
    }


    break;
  case 1: 
  
//numPlayers = faces.length;
    if (beginGameTimer == true) {
      background(0, 0, 0);
      elapsedTime = 0;
     
    }
    beginGameTimer = false;
    // countdown from 3.. 2.. 1..

    elapsedTime++;

if (elapsedTime < 100){
  textSize(64);
  text("Get Ready!", width/2, height/2);
  textSize(24);
  text("Move your head to control the paddle", width/2, height/2 - 200);
  
}
    if (elapsedTime == 100) {
      background(0, 0, 0);
      textSize(32);
textSize(64);
      text("3", width/2, height/2);
      textSize(24);
      text("Move your head to control the paddle", width/2, height/2 - 200);
    } else if (elapsedTime == 200) {
      background(0, 0, 0);
      textSize(64);
      text("2", width/2, height/2);
      textSize(24);
      text("Move your head to control the paddle", width/2, height/2 - 200);
    } else if (elapsedTime == 300) {
      background(0, 0, 0);
      textSize(64);
      text("1", width/2, height/2);
      textSize(24);
      text("Move your head to control the paddle", width/2, height/2 - 200);
    } else if (elapsedTime == 400) {
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



    ///////////////////////////////GAME CODE///////////////////////////////////

    // begin video processing parts
    scale(2);
    rectMode(CENTER);
    background(0, 0, 0);
    //opencv.loadImage(video);
   
   // image(smaller, 0, 0 ); // draw the video - we will remove this after testing
    //noFill();
    //stroke(0, 255, 0);
    //strokeWeight(3);
    color(0, 0, 0);
    
    //println(faces.length);

    for (int i = 0; i < faces.length; i++) { // for every face on screen...
      //  println(faces[i].x + "," + faces[i].y);
      //rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    } // end
    if (faces.length == 2) {
      fill(color(255));
      rect(15, (faces[0].y * 2), 10, 100); // draw
      rect(780, (faces[1].y * 2), 10, 100); // draw
      paddleLeftPosition = faces[0].y;
      paddleRightPosition = faces[1].y;
      //println("left paddle position is " + faces[0].y);
      //println("ball position is " + ball.x , ball.y);
    }

    for (int g = 0; g < balls.size(); g++) {
      Ball part = balls.get(g);
      part.update();
      part.render();
    }

    fill(color(255, 255, 255, 125));
    rect(400, 0, 4, 450); // draw middle line

    //begin text draw stuff
    textSize(40);
    fill(color(255));
    text(lScore, 20, 40);
    text(rScore, 760, 40);
    //end text draw stuff

    //begin boost segment
    if ((0 < boost) && (millis() < boostTimer + 2000)) {
      //boost
    } else {
      boost = 0;
    }
    //end boost segment
    // end void draw




    break;
  }
}







//Changes score. 0 for a left score, 1 for a right score and 2 to reset.
void Score(int i) {
  switch (i) {
  case 0:
    lScore += 1;
    balls.add(new Ball(400, 300, 10));
    break;
  case 1:
    rScore += 1;
    balls.add(new Ball(400, 300, 10));
    break;
  case 2:
    lScore = 0;
    rScore = 0;
    break;
  }
  for (int g = 0; g < balls.size(); g++) {
    Ball part = balls.get(g);
    part.x = 400;
    part.y = 225;
    part.d = part.startDirection();
  }
}


void captureEvent(Capture c) {
  video.read();
    // Make smaller image
  smaller.copy(video,0,0,video.width,video.height,0,0,smaller.width,smaller.height);
  smaller.updatePixels();
  
}

void mouseClicked() {
  println("mouse: " + mouseX, mouseY);
    playerOneFound = true;
  playerTwoFound = true;
}