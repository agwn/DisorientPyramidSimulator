class Edge {
  public int m_strip;
  public boolean m_visible;

  public int m_offset;
  public int m_length;

  public int m_name;
  public int m_startNode;
  public int m_endNode;

  public color m_defaultColor;

  // For LED Tree edges
  // @param name Name of the edge
  // @param strip Strip number (0-7, one for each bb8 output)
  // @param offset 
  // @param startNode Vertex that the edge starts at
  // @param endNode Vertex that the edge ends at
  Edge(int name, int strip, int offset, int startNode, int endNode, boolean visible) {
    m_name = name;
    m_strip = strip;
    m_visible = visible;
    m_offset = offset;
    m_length = 30;  // For simplicity
    m_startNode = startNode;
    m_endNode = endNode;

    m_defaultColor = color(random(60, 255), random(60, 255), random(60, 255));  //delme
  }

  void draw(color[] imageData, int offset) {
    if (m_visible) {
      for (int i = 0; i < m_length; i++) { 

        // Calculate the location based on the end points
        float x = Nodes.get(m_startNode).m_posX - (Nodes.get(m_startNode).m_posX - Nodes.get(m_endNode).m_posX)/m_length*i;
        float y = Nodes.get(m_startNode).m_posY - (Nodes.get(m_startNode).m_posY - Nodes.get(m_endNode).m_posY)/m_length*i;
        float z = Nodes.get(m_startNode).m_posZ - (Nodes.get(m_startNode).m_posZ - Nodes.get(m_endNode).m_posZ)/m_length*i;

        // set the color based on the image data
        color c = imageData[offset+(m_strip + (m_offset + i)*(faces*strips))];
        //color c = m_defaultColor;

        // Draw the individual LEDs
        pushMatrix();
        translate(x, y, z);
        stroke(c);
        fill(c);
        //scale(rad);
        ellipse(0, 0, .04, .04);
        //point(0, 0);
        popMatrix();
      }
    }
  }
}

