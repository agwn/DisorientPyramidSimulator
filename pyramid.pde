void drawPyramid() {
  stroke(0);
  fill(32);

  for (int i=4; i>0; i--) {
    for (int j=0; j<4; j++) {
      pushMatrix();
      rotateY(PI/2*j);
      translate(cWidth, 0, 0);

      pushMatrix();
      translate(((4-i)*(pWidth+pSpacing)), 0, cWidth-.05);
      // draw side panel
      beginShape();
      vertex(0, 0, 0);
      vertex(pWidth, 0, 0);
      vertex(pWidth, -i*pHeight, 0);
      vertex(0, -i*pHeight, 0);
      endShape();
      popMatrix();

      pushMatrix();
      if (i < 4) {
        translate((4-i)*(pWidth+pSpacing), 0, 0);
        beginShape();
        vertex(0, -(i-.75)*pHeight, -cWidth);
        vertex(pWidth, -(i-.75)*pHeight, -cWidth);
        vertex(pWidth, -(i-.75)*pHeight, cWidth);
        vertex(0, -(i-.75)*pHeight, cWidth);
        endShape();

        translate(-pSpacing, 0, 0);
        beginShape();
        vertex(0, -(i)*pHeight, -cWidth);
        vertex(pSpacing, -(i)*pHeight, -cWidth);
        vertex(pSpacing, -(i)*pHeight, cWidth);
        vertex(0, -(i)*pHeight, cWidth);
        endShape();

        beginShape();
        vertex(pSpacing, -(i)*pHeight, -cWidth);
        vertex(pSpacing, -(i-.75)*pHeight, -cWidth);
        vertex(pSpacing, -(i-.75)*pHeight, cWidth);
        vertex(pSpacing, -(i)*pHeight, cWidth);
        endShape();
      } 
      else {
        translate((4-i)*(pWidth+pSpacing), 0, 0);
        beginShape();
        vertex(0, -(i)*pHeight, -cWidth);
        vertex(pWidth, -(i)*pHeight, -cWidth);
        vertex(pWidth, -(i)*pHeight, cWidth);
        vertex(0, -(i)*pHeight, cWidth);
        endShape();
        translate(-(cWidth), 0, 0);

        beginShape();
        vertex(0, -(i)*pHeight, -cWidth);
        vertex(cWidth, -(i)*pHeight, -cWidth);
        vertex(cWidth, -(i)*pHeight, cWidth);
        vertex(0, -(i)*pHeight, cWidth);
        endShape();
      }
      popMatrix();

      pushMatrix();
      translate((4-i)*(pWidth+pSpacing), 0, -(cWidth-.05));
      beginShape();
      vertex(0, 0, 0);
      vertex(pWidth, 0, 0);
      vertex(pWidth, -i*pHeight, 0);
      vertex(0, -i*pHeight, 0);
      endShape();
      popMatrix();
      popMatrix();
    }
  }
}

