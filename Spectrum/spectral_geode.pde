import peasy.*;

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Minim minim;
AudioInput in;
BeatDetect beat;
PeasyCam cam;

void setup(){
  size(1000, 1000, P3D);
  
  cam = new PeasyCam(this, 500);
  
  minim = new Minim(this);
  in = minim.getLineIn();
  
  beat = new BeatDetect();
  beat.setSensitivity(500);
}

float t = 0;

void draw(){
  if (t > 255){ t = 15; };
  
  beat.detect(in.mix);
  
  background(0);
  
  //cam.rotateY(0.10);
  //cam.rotateX(0.05);
  
  cam.beginHUD();
  
  int halfWidth = width/2;
  int halfHeight = height/2;
  
  translate(halfWidth, halfHeight);
  //noFill();
  stroke(255);

  beginShape();
  
  for (float theta = 0; theta <= 2 * PI; theta += 0.1){
    float rad = r(
        theta * 1.2,  // theta
        1.15,      // a
        1.15,      // b
        random(1, 150),      // m
        0.175,      // n1
        (sin(t) * 45) * in.mix.get(round(theta)),      // n2
        (sin(t) * 45) * in.mix.get(round(theta))       // n3
      );
    float x = rad * cos(theta);
    float y = rad * sin(theta);
    
    // Limit max size with random number
    x = (x > halfWidth - 50) ? random(200, (halfWidth - 50)) : x;
    y = (y > halfWidth - 50) ? random(200, (halfWidth - 50)) : y;
    x = (x < -(halfWidth - 50)) ? random(-(halfWidth - 50), -200) : x;
    y = (y < -(halfWidth - 50)) ? random(-(halfWidth - 50), -200) : y;
    
    // Hard limit max size
    //x = (x > halfWidth - 50) ? (halfWidth - 50) : x;
    //y = (y > halfWidth - 50) ? (halfWidth - 50) : y;
    //x = (x < -(halfWidth - 50)) ? -(halfWidth - 50) : x;
    //y = (y < -(halfWidth - 50)) ? -(halfWidth - 50) : y;
    
    fill(random(t, 255), random(t, 255), random(155, 255));
    //stroke(random(t, 255), random(t, 255), random(t, 255));
    vertex(x, y);
    
    endShape();
  }

  cam.endHUD();
  
  t += 0.1;
  
  if (beat.isOnset()) background(255);
}

float r(float theta, float a, float b, float m, float n1, float n2, float n3){
  float A = pow(abs(((cos((m * theta) / 4.0))) / a), n2);
  float B = pow(abs(((sin((m * theta) / 4.0))) / b), n3);
  
  return pow((A + B), -1.0/n1);
}
