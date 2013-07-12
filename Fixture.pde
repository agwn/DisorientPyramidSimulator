class Fixture {

  public List<Edge> m_edges;
  
  Fixture(List<Edge> edges) {
    m_edges = edges;
  }
  
  void draw(color[] imageData, int offset) {
    for (Edge edge : m_edges) { 
      edge.draw(imageData, offset);
    }
  }
}

