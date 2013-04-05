//// Share this between the transmitter and simulator.


void defineNodes() {
  Nodes = new LinkedList<Node>();
  Nodes.add(new Node(0,      0, -1.414,      0));
  Nodes.add(new Node(1,  1.414,      0,      0));
  Nodes.add(new Node(2,      0,  1.414,      0));
  Nodes.add(new Node(3, -1.414,      0,      0));
  Nodes.add(new Node(4,      0,      0,  1.414));
  Nodes.add(new Node(5,      0,      0, -1.414));
}

void defineSegments() {
  Segments = new LinkedList<Segment>();
  Segments.add(new Segment(0, BOX0 + 0,   0, 0, 1));
  Segments.add(new Segment(0, BOX0 + 0,  34, 1, 2));
  Segments.add(new Segment(0, BOX0 + 0,  68, 2, 3));
  Segments.add(new Segment(0, BOX0 + 0, 102, 3, 0));
  
  Segments.add(new Segment(0, BOX0 + 1,   0, 0, 4));
  Segments.add(new Segment(0, BOX0 + 1,  34, 4, 2));
  Segments.add(new Segment(0, BOX0 + 1,  68, 2, 5));
  Segments.add(new Segment(0, BOX0 + 1, 102, 5, 0));
  
  Segments.add(new Segment(0, BOX0 + 0,   0, 1, 5));
  Segments.add(new Segment(0, BOX0 + 0,  34, 5, 3));
  Segments.add(new Segment(0, BOX0 + 0,  68, 3, 4));
  Segments.add(new Segment(0, BOX0 + 0, 102, 4, 1));
}

