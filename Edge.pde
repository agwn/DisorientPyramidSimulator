import javax.media.opengl.*;
import javax.media.opengl.glu.*;
import com.sun.opengl.util.*;
import processing.opengl.*;
import java.nio.*;

class Edge {
  public int m_strip;
  public boolean m_visible;

  public int m_offset;
  public int m_length;

  public int m_name;
  public int m_startNode;
  public int m_endNode;

//  public float[] m_positions;

  FloatBuffer m_vbuffer;
  FloatBuffer m_cbuffer;

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

//    computeLightPositions();
    computeLightPositionsGL();
  }

//  void computeLightPositions() {
//    m_positions = new float[m_length*3];
//
//    // just pre-compute the positions of each LED.
//    for (int i = 0; i < m_length; i++) {
//      float x = Nodes.get(m_startNode).m_posX - (Nodes.get(m_startNode).m_posX - Nodes.get(m_endNode).m_posX)/m_length*i;
//      float y = Nodes.get(m_startNode).m_posY - (Nodes.get(m_startNode).m_posY - Nodes.get(m_endNode).m_posY)/m_length*i;
//      float z = Nodes.get(m_startNode).m_posZ - (Nodes.get(m_startNode).m_posZ - Nodes.get(m_endNode).m_posZ)/m_length*i;
//
//      m_positions[i*3 + 0] = x;
//      m_positions[i*3 + 1] = y;
//      m_positions[i*3 + 2] = z;
//    }
//  }

  void computeLightPositionsGL() {
    PGraphicsOpenGL pgl = (PGraphicsOpenGL) g;  // g may change
    GL gl = pgl.beginGL();  // always use the GL object returned by beginGL

    m_vbuffer = BufferUtil.newFloatBuffer(m_length * 3);
    m_cbuffer = BufferUtil.newFloatBuffer(m_length * 3);

    for (int i = 0; i < m_length; i++) {
      float x = Nodes.get(m_startNode).m_posX - (Nodes.get(m_startNode).m_posX - Nodes.get(m_endNode).m_posX)/m_length*i;
      float y = Nodes.get(m_startNode).m_posY - (Nodes.get(m_startNode).m_posY - Nodes.get(m_endNode).m_posY)/m_length*i;
      float z = Nodes.get(m_startNode).m_posZ - (Nodes.get(m_startNode).m_posZ - Nodes.get(m_endNode).m_posZ)/m_length*i;

      // random x,y
      m_vbuffer.put(x);
      m_vbuffer.put(y);
      m_vbuffer.put(z);

    }
    m_vbuffer.rewind();

    pgl.endGL();
  }

//  void drawPoints(color[] imageData, int offset) {
//    pushStyle();
//    strokeWeight(2);
//
//    for (int i = 0; i < m_length; i++) { 
//      // set the color based on the image data
//      color c = imageData[offset+(m_strip + (m_offset + i)*(faces*strips))];
//      stroke(c);
//
//      // Draw the individual LEDs
//      pushMatrix();
//      translate(m_positions[i*3 + 0], m_positions[i*3 + 1], m_positions[i*3 + 2]);
//      //          ellipse(0, 0, .04, .04);
//      point(0, 0);
//      popMatrix();
//    }
//    popStyle();
//  }

  void drawPointsGL(color[] imageData, int offset) {
    float scale = 1.0 / 255.0;
    // Upload the new color data
    for (int i = 0; i < m_length; i++) { 
      // set the color based on the image data
      color c = imageData[offset+(m_strip + (m_offset + i)*(faces*strips))];
      // White color by default
      m_cbuffer.put(red(c) * scale);
      m_cbuffer.put(green(c) * scale);
      m_cbuffer.put(blue(c) * scale);
    }
    m_cbuffer.rewind();

    
    PGraphicsOpenGL pgl = (PGraphicsOpenGL) g;  // g may change
    GL gl = pgl.beginGL();  // always use the GL object returned by beginGL

    gl.glEnableClientState(GL.GL_VERTEX_ARRAY);
    gl.glVertexPointer(3, GL.GL_FLOAT, 0, m_vbuffer);

    gl.glEnableClientState(GL.GL_COLOR_ARRAY);
    gl.glColorPointer(3, GL.GL_FLOAT, 0, m_cbuffer);
    

    gl.glPushMatrix();
      gl.glPointSize(2);
      gl.glDrawArrays(GL.GL_POINTS, 0, m_length);
    gl.glPopMatrix();

    gl.glDisableClientState(GL.GL_VERTEX_ARRAY);
    gl.glDisableClientState(GL.GL_COLOR_ARRAY);

    pgl.endGL();
  }

  void draw(color[] imageData, int offset) {
    if (m_visible) {
      drawPointsGL(imageData, offset);
    }
  }
}

