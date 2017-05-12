import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;
import ddf.minim.*;
import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import javax.swing.*;
import KinectPV2.*;


/* 
 SUP DOGE!
 This is a global game jam 2017 game!
 More dox coming soon :D
 @authors Walter Lim, Sam Hunt
 */


Minim minim;
AudioPlayer musicintro;
AudioPlayer musicgame;
AudioPlayer musicend;
Capture video;
Ball ball;
KinectPV2 kinect;


boolean foundUsers = false;
int numPlayersDetected = 0;
float potato;



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
int elapsedTime;
boolean starting;
float titleX = width/2, titleY = 600;
float subX = width/2, subY = 600;
float faceFoundTextX = 800, faceFoundTextY = 450;
float countDownY = 400;
boolean beginGameTimer;
boolean startingCd;
int scale = 2;



// Game Variables
float x = 150;
float y = 150;
float speedX = random(3, 5);
float speedY = random(3, 5);
int leftColor = 128;
int rightColor = 128;
int diam;
int rectSize = 150;
float diamHit;
boolean gameStart = true;



PImage smaller;
void setup() {


  // Kinect stuffs
  kinect = new KinectPV2(this);

  kinect.enableBodyTrackImg(true);
  kinect.enableDepthMaskImg(true);
  kinect.enableSkeletonDepthMap(true);

  kinect.init();

  // Game stuff
  diam = 20;
  ellipse(x, y, diam, diam);










  // size(width, height);
  fullScreen();

  frameRate(60);

  // begin audio stuff
  minim = new Minim(this);
  musicintro = minim.loadFile("musicintro.mp3");
  musicgame = minim.loadFile("musicgame.wav");
  musicend = minim.loadFile("musicend.wav");
  //end audio stuff

  //begin game initialization and other crap - SPAWN THE BALLS!!
  balls.add(new Ball(400, 300, 10));

  // StartScreen Init
  titleFont = createFont("pixelated.ttf", 64);
  //smooth();
  Ani.init(this);

  musicintro.loop();
  musicgame.loop();
  // musicend.loop();
  musicintro.mute();
  musicgame.mute();
  // musicend.mute();
  musicend.pause();
}

void draw() {



  // Kinect tracking

  //get the skeletons as an Arraylist of KSkeletons
  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonDepthMap();

  //obtain an ArrayList of the users currently being tracked
  ArrayList<PImage> bodyTrackList = kinect.getBodyTrackUser();

  //iterate through all the users
  for (int i = 0; i < bodyTrackList.size(); i++) {
    PImage bodyTrackImg = (PImage)bodyTrackList.get(i);
    if (i <= 2)
      image(bodyTrackImg, 320 + 240*i, 0, 320, 240);
    else
      image(bodyTrackImg, 320 + 240*(i - 3), 424, 320, 240 );
  }
  numPlayersDetected = kinect.getNumOfUsers();

  for (int i = 0; i < skeletonArray.size(); i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    //if the skeleton is being tracked compute the skleton joints
    if (skeleton.isTracked()) {
      KJoint[] joints = skeleton.getJoints();

      color col  = skeleton.getIndexColor();
      fill(col);
      stroke(col);

      drawBody(joints);
      drawHandState(joints[KinectPV2.JointType_HandRight]);
      drawHandState(joints[KinectPV2.JointType_HandLeft]);
      potato = (joints[KinectPV2.JointType_Head].getY()); // change between X and Y to change dimension that user has to traverse - Z isnt implemented in this libarary but we could use grayscale to figure that out
    }
  }
  

  


  if (numPlayersDetected == 2 && !starting) {
    status = 1;
  } else if (numPlayersDetected == 2 && starting) {
    status = 2;
  } else if (numPlayersDetected <=1 && !starting) {
    status = 0;
  } 


  if (rScore >= 20 || lScore >= 20) {
    status = 3;
  }



  switch(status) {
  case 0: 
    musicintro.unmute();
    musicgame.mute();
    musicend.mute();
    musicend.pause();
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
      Ani.to(this, 1.0, "subX", width/2);
      Ani.to(this, 1.0, "subY", height/1.8);
      textSize(24);
      text("Find a friend and face the screen to get started", subX, subY);


      Ani.to(this, 1.0, "faceFoundTextX", width/2);
      Ani.to(this, 1.0, "faceFoundTextY", height/1.5);
      textAlign(CENTER, CENTER);

      textFont(titleFont);
      textSize(24);
      //   numPlayers = faces.length;

      text(numPlayersDetected + " of 2 people found", faceFoundTextX, faceFoundTextY);
      starting = false;
      beginGameTimer = true;
    }


    break;
  case 1: 

    if (beginGameTimer == true) {
      background(0, 0, 0);
      elapsedTime = 0;
    }
    beginGameTimer = false;
    // countdown from 3.. 2.. 1..

    elapsedTime++;

    if (elapsedTime < 100) {
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
  
//  if(skeletonArray.size() == 1) {
   
//    skeletonArray.size(1).
    
 // }

    musicintro.mute();
    musicgame.unmute();
    //musicend.mute();
    musicend.pause();

    background(0, 0, 0);

    if ((numPlayersDetected < 2) && starting) {
      textSize(20);
      textAlign(CENTER, CENTER);
      text("Player Lost. Reposition on screen", width/2, height/2 - 200);
    }


    textSize(64);



    ///////////////////////////////GAME CODE///////////////////////////////////

    background(255);

    fill(128, 128, 128);
    diam = 20;
    ellipse(x, y, diam, diam);

    fill(leftColor);
    rect(0, 0, 20, height);
    fill(rightColor);
    rect(width-30, mouseY-rectSize/2, 10, rectSize);


    if (gameStart) {

      x = x + speedX;
      y = y + speedY;

      // if ball hits movable bar, invert X direction and apply effects
      if ( x > width-30 && x < width -20 && y > mouseY-rectSize/2 && y < mouseY+rectSize/2 ) {
        speedX = (speedX + 1) * -1;
        x = x + speedX;
        rightColor = 0;
        fill(random(0, 128), random(0, 128), random(0, 128));
        diamHit = random(75, 150);
        ellipse(x, y, diamHit, diamHit);
        rectSize = rectSize-10;
        rectSize = constrain(rectSize, 10, 150);
      } 

      // if ball hits wall, change direction of X
      else if (x < 25) {
        speedX = speedX * -1.1;
        x = x + speedX;
        leftColor = 0;
      } else {     
        leftColor = 128;
        rightColor = 128;
      }
      // resets things if you lose
      if (x > width) { 
        //  gameStart = false;
        x = 150;
        y = 150; 
        speedX = random(3, 5);
        speedY = random(3, 5);
        rectSize = 150;
      }


      // if ball hits up or down, change direction of Y   
      if ( y > height || y < 0 ) {
        speedY = speedY * -1;
        y = y + speedY;
      }
    }


    break;

  case 3: 
    background(0, 0, 0);
    text("Game over", width/2, height/2);

    musicintro.mute();
    musicgame.unmute();

    if (!musicend.isPlaying()) {
      musicend.unmute();
      musicend.rewind();
      //  musicend.play(1);
    }




    textSize(20);
    fill(color(255));
    text(lScore, ((width/2) -40), ((height/2) + 60));
    text(rScore, ((width/2) +40), ((height/2) + 60));


    break;
  }
}








//Changes score. 0 for a left score, 1 for a right score and 2 to reset.
void Score(int i) {
  switch (i) {
  case 0:
    lScore += 1;
    // balls.add(new Ball(400, 300, 10));
    break;
  case 1:
    rScore += 1;
    //balls.add(new Ball(400, 300, 10));
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
  smaller.copy(video, 0, 0, video.width, video.height, 0, 0, smaller.width, smaller.height);
  smaller.updatePixels();
}

void mouseClicked() {
  println("mouse: " + mouseX, mouseY);

  // lScore = 20;
}

void drawHandState(KJoint joint) {
  noStroke();
  handState(joint.getState());
  pushMatrix();
  translate(joint.getX(), joint.getY(), joint.getZ());
  ellipse(0, 0, 70, 70);
  popMatrix();
}

void handState(int handState) {
  switch(handState) {
  case KinectPV2.HandState_Open:
    fill(0, 255, 0);
    break;
  case KinectPV2.HandState_Closed:
    fill(255, 0, 0);
    break;
  case KinectPV2.HandState_Lasso:
    fill(0, 0, 255);
    break;
  case KinectPV2.HandState_NotTracked:
    fill(100, 100, 100);
    break;
  }
}


//draw the body
void drawBody(KJoint[] joints) {
  drawBone(joints, KinectPV2.JointType_Head, KinectPV2.JointType_Neck);
  drawBone(joints, KinectPV2.JointType_Neck, KinectPV2.JointType_SpineShoulder);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_SpineMid);
  drawBone(joints, KinectPV2.JointType_SpineMid, KinectPV2.JointType_SpineBase);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderRight);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderLeft);
  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipRight);
  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipLeft);

  // Right Arm
  drawBone(joints, KinectPV2.JointType_ShoulderRight, KinectPV2.JointType_ElbowRight);
  drawBone(joints, KinectPV2.JointType_ElbowRight, KinectPV2.JointType_WristRight);
  drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_HandRight);
  drawBone(joints, KinectPV2.JointType_HandRight, KinectPV2.JointType_HandTipRight);
  drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_ThumbRight);

  // Left Arm
  drawBone(joints, KinectPV2.JointType_ShoulderLeft, KinectPV2.JointType_ElbowLeft);
  drawBone(joints, KinectPV2.JointType_ElbowLeft, KinectPV2.JointType_WristLeft);
  drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_HandLeft);
  drawBone(joints, KinectPV2.JointType_HandLeft, KinectPV2.JointType_HandTipLeft);
  drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_ThumbLeft);

  // Right Leg
  drawBone(joints, KinectPV2.JointType_HipRight, KinectPV2.JointType_KneeRight);
  drawBone(joints, KinectPV2.JointType_KneeRight, KinectPV2.JointType_AnkleRight);
  drawBone(joints, KinectPV2.JointType_AnkleRight, KinectPV2.JointType_FootRight);

  // Left Leg
  drawBone(joints, KinectPV2.JointType_HipLeft, KinectPV2.JointType_KneeLeft);
  drawBone(joints, KinectPV2.JointType_KneeLeft, KinectPV2.JointType_AnkleLeft);
  drawBone(joints, KinectPV2.JointType_AnkleLeft, KinectPV2.JointType_FootLeft);

  //Single joints
  drawJoint(joints, KinectPV2.JointType_HandTipLeft);
  drawJoint(joints, KinectPV2.JointType_HandTipRight);
  drawJoint(joints, KinectPV2.JointType_FootLeft);
  drawJoint(joints, KinectPV2.JointType_FootRight);

  drawJoint(joints, KinectPV2.JointType_ThumbLeft);
  drawJoint(joints, KinectPV2.JointType_ThumbRight);

  drawJoint(joints, KinectPV2.JointType_Head);
}

void drawJoint(KJoint[] joints, int jointType) {
  pushMatrix();
  translate(joints[jointType].getX(), joints[jointType].getY(), joints[jointType].getZ());
  ellipse(0, 0, 25, 25);
  popMatrix();
}

//draw a bone from two joints
void drawBone(KJoint[] joints, int jointType1, int jointType2) {
  pushMatrix();
  translate(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ());
  ellipse(0, 0, 25, 25);
  popMatrix();
  line(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ(), joints[jointType2].getX(), joints[jointType2].getY(), joints[jointType2].getZ());
}