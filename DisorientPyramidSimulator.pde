import hypermedia.net.*;
import java.util.concurrent.*;

import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;
import processing.opengl.*;
import javax.media.opengl.GL;

//import toxi.geom.*;
//import toxi.geom.mesh.*;

//import toxi.processing.*;

//TriangleMesh mesh;
//ToxiclibsSupport gfx;

int FRAMERATE = 15;

//// Share this between the transmitter and simulator.
int stripsPerPanel = 8;
int ledsPerMeter = 30;

float pWidth = 3.0;  // panel width
float cWidth = 6.0;

int panelCnt = 4;
int maxPanelCnt = 7;
int panelHeights[] = {
  maxPanelCnt, 5, 3, 1
};
//float pHeight = 3.0;  // panel step height
float pHeights[] = {
  21, 21, 14, 7, 3
};
float pSpacing = 3.0;  // spacing
float pSpaces[] = {
  0, pSpacing, pSpacing, pSpacing, pSpacing
};
float pHeight = 3.0;
float fHeights[] = {
  14, 14, 10.5, 5, 0.5
};
float sSpacing = pWidth/float(stripsPerPanel);
float sPadding = sSpacing/2.0;  // padding

int ledsPerStrip = maxPanelCnt*ledsPerMeter;
int strips = panelCnt*stripsPerPanel;
int faces = 2;
int ledsTotal = panelCnt*stripsPerPanel*maxPanelCnt*ledsPerMeter;
int packetLength = faces*ledsTotal*3 + 1;

Boolean demoMode = true;
BlockingQueue newImageQueue;

UDP udp;
PeasyCam pCamera;

ImageHud imageHud;
DemoTransmitter demoTransmitter;

int animationStep = 0;
int maxConvertedByte = 0;

int BOX0=0;  // right panel
int BOX1=8;  // left panel

List<Node> Nodes;
List<Edge> rEdges;
List<Edge> lEdges;

Fixture rPanel;
Fixture lPanel;

void setup() {
  size(1100, 550, OPENGL);
  colorMode(RGB, 255);
  frameRate(FRAMERATE);

  // Turn on vsync to prevent tearing
  PGraphicsOpenGL pgl = (PGraphicsOpenGL) g; //processing graphics object
  GL gl = pgl.beginGL(); //begin opengl
  gl.setSwapInterval(2); //set vertical sync on
  pgl.endGL(); //end opengl

  //size(1680, 1000, OPENGL);
  pCamera = new PeasyCam(this, 0, -8.0, 0, 45);
  pCamera.setMinimumDistance(20);
  pCamera.setMaximumDistance(80);
  pCamera.setWheelScale(0.25);
  pCamera.setYawRotationMode();

  //pCamera.rotateZ(-PI/4);
  pCamera.rotateY(PI/4);
  //pCamera.rotateX(PI/32);

  // Fix the front clipping plane
  float fov = PI/3.0;
  float cameraZ = (height/2.0) / tan(fov/2.0);
  perspective(fov, float(width)/float(height), cameraZ/100.0, cameraZ*10.0);

  newImageQueue = new ArrayBlockingQueue(2);

  imageHud = new ImageHud(20, height-ledsPerStrip-20, faces*strips, ledsPerStrip);

  udp = new UDP( this, 58082 );
  udp.listen( true );

  defineNodes();
  defineEdges();

  rPanel = new Fixture(rEdges);
  lPanel = new Fixture(lEdges);

  //mesh=(TriangleMesh)new STLReader().loadBinary(sketchPath("data/Citizen Extras_Female 03.stl"), STLReader.TRIANGLEMESH);
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

  color[] newImage = new color[faces*strips*ledsPerStrip];
  for (int i=0; i<faces*strips; i++) {
    for (int j=0; j<ledsPerStrip; j++) {
      int loc = j*(faces*strips) +i;
      // Processing doesn't like it when you call the color function while in an event go figure
      newImage[loc] = (int)(0xff<<24 | convertByte(data[loc*3 + 1])<<16) | (convertByte(data[loc*3 + 2])<<8) | (convertByte(data[loc*3 + 3]));
    }
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
  //drawGround();

  // Draw the pyramid
  drawPyramid();


  if (currentImage != null) {

    // Draw the front right panel
    pushMatrix();
    translate(cWidth+sPadding, 0, cWidth+0.05);
    rPanel.draw(currentImage, strips);
    popMatrix();
    
    // Draw the front left panel
     pushMatrix();
     translate(cWidth+0.05, 0, cWidth+sPadding);
     rotateY(-PI/2);
     lPanel.draw(currentImage, 0);
     popMatrix();
     
     // Draw the back right panel
     pushMatrix();
     translate(cWidth+0.05, 0, -(cWidth+sPadding));
     rotateY(PI/2);
     rPanel.draw(currentImage, strips);
     popMatrix();
     
     // Draw the back left panel
     pushMatrix();
     translate(-(cWidth+sPadding), 0, cWidth+0.05);
     rotateY(-PI);
     lPanel.draw(currentImage, 0);
     popMatrix();
  } 

  imageHud.draw();

  if (newImageQueue.size() > 0) {
    color[] newImage = (color[])newImageQueue.remove();

    imageHud.update(newImage);
    currentImage = newImage;
  }

  // Draw a person for scale
  /*
  pushMatrix();
   stroke(color(0));
   fill(color(50, 0, 50));
   
   scale(.011, .011, .011);
   rotate(-3.14159/2, 1, 0, 0);
   translate(-100, -80, 0);
   rotate(3.14159/1.5, 0, 0, 1);
   gfx.mesh(mesh);
   popMatrix();
   */
}

