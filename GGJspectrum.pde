/* 
SUP DOGE!
This is a global game jam 2017 game!
More dox coming soon :D
@authors Walter Lim, Sam Hunt
*/

import gab.opencv.*;
import processing.video.*;
import java.awt.*;

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


void setup() {
  size(1600, 900);
  // begin video stuff and
  video = new Capture(this, 800/2, 600/2);
  opencv = new OpenCV(this, 800/2, 600/2);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  video.start();
  // end video stuff
  
  //begin game initialization and other crap - SPAWN THE BALLS!!
  ball = new Ball (400, 300, 2); // x, y, speed values - we need to define ball !
  
  
  
}

void draw() {
  
  // begin video processing parts
  scale(2);
  background(0,0,0);
  opencv.loadImage(video);
  //image(video, 0, 0 ); // draw the video - we will remove this after testing
  //noFill();
  //stroke(0, 255, 0);
  //strokeWeight(3);
  color(0,0,0);
  Rectangle[] faces = opencv.detect();
  println(faces.length);

  for (int i = 0; i < faces.length; i++) { // for every face on screen...
    println(faces[i].x + "," + faces[i].y);
    //rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
  } // end
   if (faces.length == 2) {
  fill(color(255));
  rect(30, (faces[0].y * 2), 10, 100); // draw
  rect(720, (faces[1].y * 2), 10, 100); // draw
  paddleLeftPosition = faces[0].y;
  paddleRightPosition = faces[1].y;
  }
  
    ball.update(); // update pos
  ball.render(); // draw balls :D
    fill(color(255,255,255,125));
  rect(400,0,4,450); // draw middle line
  
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
} // end void draw

//Changes score. 0 for a left score, 1 for a right score and 2 to reset.
void Score(int i) {
  switch (i) {
  case 0:
    lScore += 1;
    break;
  case 1:
    rScore += 1;
    break;
  case 2:
    lScore = 0;
    rScore = 0;
    break;
  }
  ball.x = 400;
  ball.y = 300;
  ball.d = ball.startDirection();
}


void captureEvent(Capture c) {
  c.read();
}