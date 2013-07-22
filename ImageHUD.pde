class ImageHud {
  PImage img;
  float x;
  float y;

  ImageHud(float x_, float y_, int w_, int h_) {
    x = x_;
    y = y_;
    img = new PImage(w_, h_);
  }

  void update(color[] imageData) {
    img.loadPixels();
    for (int i = 0; i < faces*strips*ledsPerStrip; i++) {
      img.pixels[i] = imageData[i];
    }
    img.updatePixels();
  }

  void draw() {
    pCamera.beginHUD();
    pushStyle();
      stroke(255);
      strokeWeight(2);
      fill(0);
      rect(x,y,img.width, img.height);
      image(img, x, y);
    
      fill(255);
      textSize(24);
      text(frameRate, x + img.width + 4, y + img.height - 10); 
    popStyle();  
    pCamera.endHUD();
  }
}

