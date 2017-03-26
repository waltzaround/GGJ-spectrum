import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;
import ddf.minim.*;
import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import javax.swing.*;      // Java Swing
/* 
 SUP DOGE!
 This is a global game jam 2017 game!
 More dox coming soon :D
 @authors Walter Lim, Sam Hunt
 Special thanks to Patrick Tuohy
 */


Minim minim;
AudioPlayer musicintro;
AudioPlayer musicgame;
AudioPlayer musicend;
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
  
  
 
  
  // begin video stuff and
 // video = new Capture(this, 800, 600);

 // video.start();
  // end video stuff
  
 // video = new Capture(this,640, 480);
 // video.start();
  
  
 // opencv = new OpenCV(this, video.width/scale, video.height/scale);
  
  
    // Which "cascade" are we going to use?
 // opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE); 
 
  // Make scaled down image
 // smaller = createImage(opencv.width,opencv.height,RGB);
  
  
  

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

  if (playerOneFound && playerTwoFound && !starting) {
    status = 1;
  } else if (playerOneFound && playerTwoFound && starting) {
    status = 2;
  } else if (!playerOneFound && !starting) {
    status = 0;
  } 
  
  
  if (rScore >= 20 || lScore >= 20){
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
      Ani.to(this, 1.0, "faceFoundTextY", 800);
      textAlign(CENTER, CENTER);

      textFont(titleFont);
      textSize(24);
   //   numPlayers = faces.length;

      text(numPlayers + " of 2 people found", faceFoundTextX, faceFoundTextY);
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
  
  musicintro.mute();
  musicgame.unmute();
  //musicend.mute();
  musicend.pause();
 
    background(0, 0, 0);

    if ((!playerOneFound || !playerTwoFound) && starting) {
      textSize(20);
      textAlign(CENTER, CENTER);
      text("Player Lost. Reposition on screen", width/2, height/2 - 200);
    }


    textSize(64);



    ///////////////////////////////GAME CODE///////////////////////////////////

  background(255);

  fill(128,128,128);
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
      fill(random(0,128),random(0,128),random(0,128));
      diamHit = random(75,150);
      ellipse(x,y,diamHit,diamHit);
      rectSize = rectSize-10;
      rectSize = constrain(rectSize, 10,150);      
    } 

    // if ball hits wall, change direction of X
    else if (x < 25) {
      speedX = speedX * -1.1;
      x = x + speedX;
      leftColor = 0;
    }

    else {     
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
    background(0,0,0);
    text("Game over", width/2, height/2);

      musicintro.mute();
  musicgame.unmute();
  
  if (!musicend.isPlaying()){
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
  smaller.copy(video,0,0,video.width,video.height,0,0,smaller.width,smaller.height);
  smaller.updatePixels();
  
}

void mouseClicked() {
  println("mouse: " + mouseX, mouseY);
    playerOneFound = true;
  playerTwoFound = true;
 // lScore = 20;
}