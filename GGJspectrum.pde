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

void setup() {
  size(1600, 900);
  video = new Capture(this, 800/2, 600/2);
  opencv = new OpenCV(this, 800/2, 600/2);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  video.start();
}

void draw() {
  scale(2);
  background(0,0,0);
  opencv.loadImage(video);

  image(video, 0, 0 );

  //noFill();
  //stroke(0, 255, 0);
  //strokeWeight(3);
   color(0,0,0);
  Rectangle[] faces = opencv.detect();
  println(faces.length);

  for (int i = 0; i < faces.length; i++) {
    println(faces[i].x + "," + faces[i].y);
    //rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
  }
   if (faces.length == 1) {
  color(255,255,255);
  rect(30, (faces[0].y * 2), 10, 100); // draw
  //rect(100, (faces[1].y * 2), 10, 100); // draw
  }
  
}

void captureEvent(Capture c) {
  c.read();
}