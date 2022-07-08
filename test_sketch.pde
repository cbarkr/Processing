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
  size(800, 800, P3D);
  
  cam = new PeasyCam(this, 500);
  
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 1024);
  
  beat = new BeatDetect();
  beat.setSensitivity(400);
}

float t = 0;

void draw(){
  if (t > 255){ t = 0; };
  
  beat.detect(in.mix);
  
  background(0);
  
  //cam.rotateY(0.10);
  //cam.rotateX(0.05);
  
  cam.beginHUD();
  
  translate(width/2, height/2);
  //noFill();
  stroke(255);

  beginShape();
  
  for (float theta = 0; theta <= 2 * PI; theta += 0.1){
    float rad = r(
        theta,  // theta
        1.5,      // a
        1.5,      // b
        sin(theta) * random(1, 30),      // m
        1.5,      // n1
        in.mix.get(round(theta))* 200,      // n2
        in.mix.get(round(theta))* 200       // n3
      );
    float x = rad * cos(theta);
    float y = rad * sin(theta);
    
    fill(random(t, 255), random(1, 255), random(t, 255));
    //stroke(random(1, 255), random(1, 255), random(1, 255));
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
