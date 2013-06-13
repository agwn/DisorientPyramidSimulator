import hypermedia.net.*;
import java.util.concurrent.*;
import java.util.*;

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


int ledsPerStrip = 32*5;
int strips = 40;
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

List<Node> Nodes;
List<Edge> Edges;
Fixture tree;

Boolean mappingMode = false;
int segmentX = 0;
int segmentY = 0;
int segmentLen = 32;

void setup() {
//  size(1680, 1050, OPENGL);
  size(640, 480, OPENGL);
  colorMode(RGB, 255);
  frameRate(60);
  
  // Turn on vsync to prevent tearing
//// For Processing 1.5.1
//  PGraphicsOpenGL pgl = (PGraphicsOpenGL) g; //processing graphics object
//  GL gl = pgl.beginGL(); //begin opengl
//  gl.setSwapInterval(2); //set vertical sync on
//  pgl.endGL(); //end opengl

//// For Processing 2.0
  GL gl = g.beginPGL().gl;
  gl.setSwapInterval(2); //set vertical sync on
  g.endPGL();

  //size(1680, 1000, OPENGL);
  pCamera = new PeasyCam(this, 0, 1.2, 0, 4);
  pCamera.setMinimumDistance(2);
  pCamera.setMaximumDistance(10);
  pCamera.setWheelScale(.5);

//  pCamera.rotateX(-.1);
  pCamera.rotateY(1.6);
//  pCamera.rotateZ(3);
  pCamera.rotateZ(3.14159);
  
  // Fix the front clipping plane
  float fov = PI/3.0;
  float cameraZ = (height/2.0) / tan(fov/2.0);
  perspective(fov, float(width)/float(height), 
            cameraZ/1000.0, cameraZ*10.0);
  
  newImageQueue = new ArrayBlockingQueue(2);

  imageHud = new ImageHud(20, height-160-20, strips, ledsPerStrip);

  udp = new UDP( this, 58083 );
  udp.listen( true );

  defineNodes();
  defineEdges();
  tree = new Fixture(Edges);

  mesh=(TriangleMesh)new STLReader().loadBinary(sketchPath("data/Citizen Extras_Female 03_low.stl"),STLReader.TRIANGLEMESH);
  gfx=new ToxiclibsSupport(this);

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
    println("Packet header mismatch. Expected 1, got " + data[0]);
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

float rot = 0;

void draw() {
  // Rotate slowly
//  pCamera.setRotations(0,rot+=.011,3.14159);

  
  background(color(0,0,20));
  
  // Draw a person for scale
  pushMatrix();
    stroke(color(0));
    fill(color(50,0,50));
  
    scale(.011,.011,.011);
    rotate(-3.14159/2,1,0,0);
    translate(-100,-80,0);
    rotate(3.14159/1.5,0,0,1);
    gfx.mesh(mesh);
  popMatrix();
  
  // Draw the ground
  drawGround();
    
  if (currentImage != null) {
    // draw the same tree three times, later we should make 3 trees.
//    for(int i = 0; i < 3; i++) {
    int i = 0;
      pushMatrix();
        rotate(3.14159*2/3*i,0,1,0);
        translate(-1.52,0,0);
        rotate(-3.14159/6,0,1,0);
        tree.draw(currentImage);
      popMatrix();
//    }
  }

  imageHud.draw();

  if (newImageQueue.size() > 0) {
    color[] newImage = (color[])newImageQueue.remove();

    imageHud.update(newImage);
    currentImage = newImage;
  }
}



