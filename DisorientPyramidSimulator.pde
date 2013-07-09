import hypermedia.net.*;
import java.util.concurrent.*;

import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;
import processing.opengl.*;
import javax.media.opengl.GL;

import toxi.geom.*;
import toxi.geom.mesh.*;

import toxi.processing.*;

TriangleMesh mesh;
ToxiclibsSupport gfx;

//// Share this between the transmitter and simulator.
float A = 0.25;  // padding
float B = 1;  // panel width
float C = .5;  // spacing
float D = 1.5;

int ledsPerStrip = 30*4;
int strips = 16;
int packetLength = strips*ledsPerStrip*3 + 1;

Boolean demoMode = true;
BlockingQueue newImageQueue;

UDP udp;
PeasyCam pCamera;

ImageHud imageHud;
DemoTransmitter demoTransmitter;

int animationStep = 0;
int maxConvertedByte = 0;

int BOX0=0;
int BOX1=8;

List<Node> Nodes;
List<Edge> Edges;

Fixture Panel;

void setup() {
  size(1200, 600, OPENGL);
  //size(720, 600, OPENGL);
  colorMode(RGB, 255);
  frameRate(30);

  // Turn on vsync to prevent tearing
  PGraphicsOpenGL pgl = (PGraphicsOpenGL) g; //processing graphics object
  GL gl = pgl.beginGL(); //begin opengl
  gl.setSwapInterval(2); //set vertical sync on
  pgl.endGL(); //end opengl

  //size(1680, 1000, OPENGL);
  pCamera = new PeasyCam(this, 0, 0, 0, 5);
  pCamera.setMinimumDistance(12);
  pCamera.setMaximumDistance(20);
  pCamera.setWheelScale(.5);

  pCamera.rotateY(PI/4);
  pCamera.rotateX(PI/16);
  //pCamera.rotateZ(-PI/4);
  //pCamera.rotateX(-(3.14159/2.1));
  //  pCamera.rotateY(1.6);
  //  pCamera.rotateZ(3.14159);

  // Fix the front clipping plane
  float fov = PI/3.0;
  float cameraZ = (height/2.0) / tan(fov/2.0);
  perspective(fov, float(width)/float(height), 
  cameraZ/1000.0, cameraZ*10.0);

  newImageQueue = new ArrayBlockingQueue(2);

  imageHud = new ImageHud(20, height-160-20, strips, ledsPerStrip);

  udp = new UDP( this, 58082 );
  udp.listen( true );

  defineNodes();
  defineEdges();

  Panel = new Fixture(Edges);

  //mesh=(TriangleMesh)new STLReader().loadBinary(sketchPath("data/Citizen Extras_Female 03.stl"),STLReader.TRIANGLEMESH);
  //gfx=new ToxiclibsSupport(this);

  demoTransmitter = new DemoTransmitter();
  demoTransmitter.start();
}


int convertByte(byte b) {
  int c = (b<0) ? 256+b : b;

  if (c > maxConvertedByte) {
    maxConvertedByte = c;
    println("Max Converted Byte is now " + c);
  }  

  return c;
}

void receive(byte[] data, String ip, int port) {  
  //println(" new datas!");
  if (demoMode) {
    println("Started receiving data from " + ip + ". Demo mode disabled.");
    demoMode = false;
  }

  if (data[0] == 2) {
    // We got a new mode, so copy it out
    String modeName = new String(data);

    return;
  }

  if (data[0] != 1) {
    println("Packet eader mismatch. Expected 1, got " + data[0]);
    return;
  }

  if (data.length != packetLength) {
    println("Packet size mismatch. Expected "+packetLength+", got " + data.length);
    return;
  }

  if (newImageQueue.size() > 0) {
    println("Buffer full, dropping frame!");
    return;
  }

  color[] newImage = new color[strips*ledsPerStrip];

  for (int i=0; i< strips*ledsPerStrip; i++) {
    // Processing doesn't like it when you call the color function while in an event
    // go figure
    newImage[i] = (int)(0xff<<24 | convertByte(data[i*3 + 1])<<16) | (convertByte(data[i*3 + 2])<<8) | (convertByte(data[i*3 + 3]));
  }
  try { 
    newImageQueue.put(newImage);
  } 
  catch( InterruptedException e ) {
    println("Interrupted Exception caught");
  }
}

color[] currentImage = null;

void draw() {
  
  background(color(0, 0, 20));

  // Draw the ground
  drawGround();
  
  // Draw the pyramid
  drawPyramid();

  if (currentImage != null) {
    // draw the same panel 4 time for mock up.
    pushMatrix();
    translate(D+.125,0,D);
    Panel.draw(currentImage);
    popMatrix();

    pushMatrix();
    translate(D,0,D+.125);
    rotateY(-PI/2);
    Panel.draw(currentImage);
    popMatrix();

    pushMatrix();
    translate(-(D+.125),0,D);
    rotateY(-PI);
    Panel.draw(currentImage);
    popMatrix();

    pushMatrix();
    translate(D,0,-(D+.125));
    rotateY(PI/2);
    Panel.draw(currentImage);
    popMatrix();
  }

  imageHud.draw();

  if (newImageQueue.size() > 0) {
    color[] newImage = (color[])newImageQueue.remove();

    imageHud.update(newImage);
    currentImage = newImage;
  }

  // Draw a person for scale
  //  pushMatrix();
  //    stroke(color(0));
  //    fill(color(50,0,50));
  //  
  //    scale(.011,.011,.011);
  //    rotate(-3.14159/2,1,0,0);
  //    translate(-100,-80,0);
  //    rotate(3.14159/1.5,0,0,1);
  //    gfx.mesh(mesh);
  //  popMatrix();


}

