class Ball {
  float x, y; //Coordinates.
  float d; //Direction.
  float s; //Speed.
  float r; //Radius.
  boolean fresh; //Whether or not the ball has just been generated.

  Ball (float xInit, float yInit, float sInit) {
    x = xInit;
    y = yInit;
    d = startDirection();
    s = sInit;
    r = 5;
  }

  void update () { //Updates object
    //loops d value to contain within 0 to 2PI.
    x += (s + boost)*sin(d); //Updates point by speed (0.25?), defined by d (direction) using a conversion to radians (sin & cos).
    y += (s + boost)*cos(d);
    //Bounces ball off top and bottom lines
    if ((y - r) <= 0) { //extra brackets necessary?
      y = 5;
      Collide(true);
    } else if ((y + r) >= 450) {
      y = 445;
      Collide(true);
    }
    if (((5 < x) && (x < 25)) && ((paddleLeftPosition - 100 < y) && (y < paddleLeftPosition + 100))) {
      x = 25 + r; // fiddle with this to calibrate paddle bounce
      Collide(false);
      Angle(paddleLeftPosition);
    } else if (((710 < x) && (x < 730)) && ((paddleRightPosition - 100 < y) && (y < paddleRightPosition + 100))) {
      x = 710 - r;
      Collide(false);
      Angle(paddleRightPosition);
    } else if (800 < x) {
      Score(0);
    } else if (x < 0) {
      Score(1);
    }

    if (d < 0) {
      d = (2*PI) + d;
    } else if (d > 2*PI) {
      d -= (2*PI);
    }
  }
  void render() { //Renders object
    noStroke();
    fill(255);
    //ellipseMode(RADIUS);
    //ellipse(x, y, r, r);
    rectMode(RADIUS);
    rect(x, y, r, r);
    rectMode(CORNER);
  }
  void Collide(boolean c) { //deals with collision.
    if (c == true) {
      d = PI - d;
    } else {
      d = 2*PI - d;
      s += 0.1;
    }
  }
  void Angle(int i) {
    if ((i + 5 < y) && (y < i + 30)) {
      boost += 1.5;
      boostTimer = millis();
      //println("boost");
    }
    d += (y - (i + 17.5))/66.845;
    if (((9*PI/10) < d) && (x < 400)) {
      d = 9*PI/10;
    } else if ((d < (11*PI/10)) && (400 < x)) {
      d = 11*PI/10;
    } else if (d < 0) {
      d = PI/10;
    } else if ((2*PI) < d) {
      d = 19*PI/10;
    }
  }
  float startDirection() {
    float i = random((PI/4), (7*PI/4));
    if (((3*PI/4) < i) && (i < 5*PI/4)) {
      return startDirection();
    } else {
      return i;
    }
  }
}