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
    if ((y - r) <= 45) { //extra brackets necessary?
      y = 55;
      Collide(true);
    } else if ((y + r) >= 555) {
      y = 545;
      Collide(true);
    }
    if (((10 < x) && (x < 20)) && ((paddleLeftPosition - 50 < y) && (y < paddleLeftPosition + 50))) {
      x = 41 + r; // fiddle with this to calibrate paddle bounce
      Collide(false);
      Angle(paddleRightPosition);
    } else if (((1590 < x) && (x < 1580)) && ((paddleRightPosition - 50 < y) && (y < paddleRightPosition + 50))) {
      x = 644 - r;
      Collide(false);
      Angle(paddleLeftPosition);
    } else if (805 < x) {
      Score(0);
    } else if (x < -5) {
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
      println("boost");
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