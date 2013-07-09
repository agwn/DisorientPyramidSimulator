void drawGround() {
  stroke(92, 51);
  fill(92, 51);
  
  int tilefactor = 50;
  float bound = 50;

  for (int x = 0; x < tilefactor; x++) {
    for (int y = 0; y < tilefactor; y++) {
      pushMatrix();
      translate(0, -0.5, 0);
      
      translate(bound/tilefactor*x-bound/2, 0, bound/tilefactor*y-bound/2);
      
      beginShape();
      vertex(0,                .55, 0               );
      vertex(bound/tilefactor, .55, 0               );
      vertex(bound/tilefactor, .55, bound/tilefactor);
      vertex(0,                .55, bound/tilefactor);
      endShape();
      popMatrix();
    }
  }
}
