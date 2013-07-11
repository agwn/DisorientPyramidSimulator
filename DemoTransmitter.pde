class DemoTransmitter extends Thread {

  int animationStep = 0;
  final int spacing = 8; 

  color[] MakeDemoFrame() {
    int image_size = strips*ledsPerStrip;

    color[] imageData = new color[image_size];

    for (int i = 0; i < strips; i++) {
      for (int j=0; j < ledsPerStrip; j++) {
        int loc = j*strips+i;

        if (animationStep == (j%spacing)) {
          imageData[loc] = color(0, 0, 255);
        }
        else {
          imageData[loc] = color(0, 0, 0);
        }
      }
    }

    animationStep = (animationStep + 1)%spacing;

    return imageData;
  }

  DemoTransmitter() {
  }

  void run() {
    while (demoMode) {
      try {
        if (newImageQueue.size() < 1) {
          color imageData[] = MakeDemoFrame();
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

