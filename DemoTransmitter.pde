
// regular color() does things that aren't thread-safe, which results in random color flashes on the screen.
// This was tracked down by Justin after lots of frustration on the original dome simulator...
// Note that this version only handles 0-255 RGB based colors.
int safeColor(int r, int g, int b) {
  r = min(255,max(0,r));
  g = min(255,max(0,g));
  b = min(255,max(0,b));
  
  return (0xFF << 24) + (r << 16) + (g << 8) + (b << 0);
}

class DemoTransmitter extends Thread {

  int animationStep = 0;
  final int spacing = 10; 

  color[] MakeDemoFrame() {
    int image_size = faces*strips*ledsPerStrip;

    color[] imageData = new color[image_size];
    for (int i = 0; i < faces*strips; i++) {
      for (int j=0; j < ledsPerStrip; j++) {
        int loc = j*(faces*strips) +i;

        if (animationStep == (j%spacing)) {
          imageData[loc] = safeColor(0,0,255);
        }
        else {
          imageData[loc] = safeColor(0, 0, 0);
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

