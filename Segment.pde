class Segment {
  public int m_strip;
  public int m_offset;
  public int m_length;

  public int m_name;
  public int m_startNode;
  public int m_endNode;
  
  // For LED Tree segments
  // @param name Name of the segment
  // @param strip Strip number (0-7, one for each bb8 output)
  // @param offset 
  // @param startNode Node that the segment starts at
  // @param endNode Node that the segment ends at
  Segment(int name, int strip, int offset, int startNode, int endNode) {
    m_name = name;
    m_strip = strip;
    m_offset = offset;
    m_length = 32;  // For simplicity
    m_startNode = startNode;
    m_endNode = endNode;
  }
  
  void draw() {
    for (int i = 0; i < m_length; i++) { 
  
      // Calculate the location based on the end points
      float x = Nodes.get(m_startNode).m_posX - (Nodes.get(m_startNode).m_posX - Nodes.get(m_endNode).m_posX)/m_length*i;
      float y = Nodes.get(m_startNode).m_posY - (Nodes.get(m_startNode).m_posY - Nodes.get(m_endNode).m_posY)/m_length*i;
      float z = Nodes.get(m_startNode).m_posZ - (Nodes.get(m_startNode).m_posZ - Nodes.get(m_endNode).m_posZ)/m_length*i;
      
      // set the color based on the image data
//      blinkeyLights.get(i).setColor(imageData[i]);
      
      pushMatrix();
        translate(x, y, z);
        stroke(255);
        fill(255);
//        stroke(c);
//        fill(c);
//        //scale(rad);
        //ellipse(0,0,1.5,1.5);
        point(0,0);
       popMatrix();
    }
  }
}

