
void drawPyramid() {
  pushStyle();
  strokeWeight(1);
  stroke(0);
  fill(32);

  pushMatrix();
  rotateY(PI/2);
  beginShape();
  vertex(-cWidth, -pHeights[0], -cWidth);
  vertex(cWidth, -pHeights[0], -cWidth);
  vertex(cWidth, -pHeights[0], cWidth);
  vertex(-cWidth, -pHeights[0], cWidth);
  endShape();
  beginShape();
  vertex(-cWidth, -pHeights[1], -cWidth);
  vertex(cWidth, -pHeights[1], -cWidth);
  vertex(cWidth, -pHeights[1], cWidth);
  vertex(-cWidth, -pHeights[1], cWidth);
  endShape();
  popMatrix();

  for (int j=0; j<4; j++) {  // quadrant
    for (int i=0; i<(panelCnt+1); i++) {
      pushMatrix();
      rotateY(PI/2*j);
      translate(cWidth, 0, 0);

      // draw side panel
      pushMatrix();
      if (0 == i) {
        translate(0, 0, cWidth-.05);
      } 
      else {
        translate(i*pWidth+(i-1)*pSpacing, 0, cWidth-.05);
      }
      beginShape();
      vertex(0, 0, 0);
      vertex(pWidth, 0, 0);
      vertex(pWidth, -pHeights[i], 0);
      vertex(0, -pHeights[i], 0);
      endShape();
      popMatrix();

      // draw right panel
      pushMatrix();
      if (0 == i) {
        translate(0, 0, -(cWidth-.05));
      } 
      else {
        translate(i*pWidth+(i-1)*pSpacing, 0, -(cWidth-.05));
      }
      beginShape();
      vertex(0, 0, 0);
      vertex(pWidth, 0, 0);
      vertex(pWidth, -pHeights[i], 0);
      vertex(0, -pHeights[i], 0);
      endShape();
      popMatrix();

      // draw center
      pushMatrix();
      if (i>0) {
        translate(i*pWidth+(i-1)*pSpacing, 0, 0);
      }
      beginShape();
      vertex(0, -fHeights[i], -cWidth);
      vertex(pWidth, -fHeights[i], -cWidth);
      vertex(pWidth, -fHeights[i], cWidth);
      vertex(0, -fHeights[i], cWidth);
      endShape();

      if (i>0) {
        translate(-pSpacing, 0, 0);
        beginShape();
        vertex(0, -pHeights[i], -cWidth);
        vertex(pSpacing, -pHeights[i], -cWidth);
        vertex(pSpacing, -pHeights[i], cWidth);
        vertex(0, -pHeights[i], cWidth);
        endShape();
      }
      popMatrix();

      popMatrix();
    }
  }
  popStyle();
}
