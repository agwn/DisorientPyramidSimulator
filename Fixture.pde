class Fixture {

  public List<Segment> m_segments;
  
  Fixture(List<Segment> segments) {
    m_segments = segments;
    
    for (Segment seg : segments);
  }
  
  void draw(color[] imageData) {
    for (Segment segment : m_segments) { 
      segment.draw(imageData);
    }
  }
}

