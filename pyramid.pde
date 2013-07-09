void drawPyramid() {
  stroke(32);
  fill(32);

  for (int i=4; i>0; i--) {
    for (int j=0; j<4; j++) {
      pushMatrix();
      rotateY(PI/2*j);
      translate(D, 0, 0);

      pushMatrix();
      translate(((4-i)*(B+C)), 0, D-.05);
      // draw side panel
      beginShape();
      vertex(0, 0, 0);
      vertex(B, 0, 0);
      vertex(B, -i, 0);
      vertex(0, -i, 0);
      endShape();
      popMatrix();

      pushMatrix();
      if (i < 4) {
        translate((4-i)*(B+C), 0, 0);
        beginShape();
        vertex(0, -(i-.75), -D);
        vertex(B, -(i-.75), -D);
        vertex(B, -(i-.75), D);
        vertex(0, -(i-.75), D);
        endShape();
        translate(-C, 0, 0);
        beginShape();
        vertex(0, -(i), -D);
        vertex(C, -(i), -D);
        vertex(C, -(i), D);
        vertex(0, -(i), D);
        endShape();
      } 
      else {
        translate((4-i)*(B+C), 0, 0);
        beginShape();
        vertex(0, -(i), -D);
        vertex(B, -(i), -D);
        vertex(B, -(i), D);
        vertex(0, -(i), D);
        endShape();
        translate(-(D), 0, 0);
        beginShape();
        vertex(0, -(i), -D);
        vertex(C, -(i), -D);
        vertex(C, -(i), D);
        vertex(0, -(i), D);
        endShape();
      }
      popMatrix();

      pushMatrix();
      translate((4-i)*(B+C), 0, -(D-.05));
      beginShape();
      vertex(0, 0, 0);
      vertex(B, 0, 0);
      vertex(B, -i, 0);
      vertex(0, -i, 0);
      endShape();
      popMatrix();
      popMatrix();
    }
  }
}

