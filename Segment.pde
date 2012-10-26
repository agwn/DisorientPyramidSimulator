class Segment {
  String m_name;
  List<SubSegment> subSegments;
  PVector m_startPosition;
  PVector m_endPosition;
  boolean rail = false;

  // For rails using the integer "point" system
  Segment(String name, int strip, int offset, int length, int startPoint, int endPoint) {
    m_name = name;
    rail = true;

    SubSegment sub = new SubSegment(name, strip, offset, length, startPoint, endPoint);
    subSegments = new LinkedList<SubSegment>();
    subSegments.add(sub);
  }

  // For Trap segments that span one strip. Negative lengths are strips that run backwards!
  Segment(int num, int strip, int start, int length) {
    SubSegment sub = new SubSegment(num, strip, start, length, 0);
    subSegments = new LinkedList<SubSegment>();
    subSegments.add(sub);
  }

  // For Trap segments that span two strips. Negative lengths are strips that run backwards!
  Segment(int num, int strip1, int start1, int length1, int strip2, int start2, int length2) {
    SubSegment sub1 = new SubSegment(num, strip1, start1, length1, 0);
    SubSegment sub2 = new SubSegment(num, strip2, start2, length2, abs(length1));

    subSegments = new LinkedList<SubSegment>();
    subSegments.add(sub1);
    subSegments.add(sub2);
  }


  void draw() {
    strokeWeight(3);

    if (rail) { // Just draw a line. Much easier.
      SubSegment seg = subSegments.get(0);
      stroke(currentImage[seg.m_strip + strips*seg.m_start]);  
      line(seg.pixel_start_position.x, seg.pixel_start_position.y, seg.pixel_end_position.x, seg.pixel_end_position.y);
    } 
    
    else {

      for (SubSegment seg : subSegments) {
        float amt = 1.0 / abs(seg.m_length);

        for (int x=0; x < abs(seg.m_length); x++) { // Draw all the subsegments!
          float q = amt * x;
          if (seg.m_length < 0) { // Change the strip addressing depending on whether we're going backwards (negative length) or not
            stroke(currentImage[seg.m_strip + strips*seg.m_start + (seg.m_length - x)]);
          } 
          else {
            stroke(currentImage[seg.m_strip + strips*seg.m_start + x]);
          }
          
          PVector point = new PVector(lerp(seg.pixel_start_position.x, seg.pixel_end_position.x, q), lerp(seg.pixel_start_position.y, seg.pixel_end_position.y, q)); 
          point(point.x, point.y);
        }
      }
    }
  }
}

