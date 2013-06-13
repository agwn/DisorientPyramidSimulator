class DemoTransmitter extends Thread {
  
  int animationStep = 0;
  
  color[] MakeDemoFrame() {
    int image_size = strips*ledsPerStrip;
  
    color[] imageData = new color[image_size];
  
    for (int i = 0; i < imageData.length; i++) {
      if (animationStep == i%3) {
        imageData[i] = color(255, 255, 255);
      }
      else {
        imageData[i] = color(0, 0, 0);
      }
    }
    
    animationStep = (animationStep + 1)%3;
  
    return imageData;
  }
  
  color[] MakeMappingFrame() {
    int image_size = strips*ledsPerStrip;
  
    color[] imageData = new color[image_size];
  
    for (int i = 0; i < imageData.length; i++) {
      imageData[i] = color(0, 0, 0);
    }
    
    for (int i = 0; i < segmentLen; i++) {
      imageData[segmentX + (segmentY + i)*strips] = color(255,255,255);
    }
    
    animationStep = (animationStep + 1)%3;
  
    return imageData;
  }
  
  void run() {
    while(demoMode) {
      try {
        if (newImageQueue.size() < 1) {
          color imageData[];
          if (mappingMode) {
            imageData = MakeMappingFrame();
          }
          else {
            imageData = MakeDemoFrame();
          }
          newImageQueue.put(imageData);
        }
        Thread.sleep(0);
      } 
      catch( InterruptedException e ) {
        println("Interrupted Exception caught");
      }
    }
  }
}
