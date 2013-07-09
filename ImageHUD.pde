class ImageHud {
  PImage img;
  float x;
  float y;
  
  ImageHud(float x_, float y_, int w_, int h_) {
    x = x_;
    y = y_;
    img = new PImage(w_,h_);
  }
  
  void update(color[] imageData) {
    img.loadPixels();
    for (int i = 0; i < strips*ledsPerStrip; i++) {
      img.pixels[i] = imageData[i];
    }
    img.updatePixels();
  }
  
  void draw() {
    pCamera.beginHUD();
      image(img, x, y);
    pCamera.endHUD();
  }
}
