//// Share this between the transmitter and simulator.


// Given an iscocoles triangle with side length L=1, like this:
//       a
//      / \ 
//     /   \
//    /  x  \
//   /       \    
//  /_________\  
// b           c
// where x is at (0,0), it follows that:
// a is at (0, 1/(2*cos(30))  ~= (  0,  .577)
// b is at (-.5, -tan(30)/2)  ~= (-.5, -.289)
// c is at (-.5, tan(30)/2)   ~= ( .5, -.289)
float A = .5;
float B = .298;
float C = .577;
float D = .8; // fixme

void defineNodes() {
  Nodes = new LinkedList<Node>();
  Nodes.add(new Node( 0,     0,     0,     C));  // layer 0
  Nodes.add(new Node( 1,    -A,     0,    -B));
  Nodes.add(new Node( 2,     A,     0,    -B));
  Nodes.add(new Node( 3,     0,     D,    -C));  // layer 1
  Nodes.add(new Node( 4,     A,     D,     B));
  Nodes.add(new Node( 5,    -A,     D,     B));
  Nodes.add(new Node( 6,     0,   2*D,     C));  // layer 2
  Nodes.add(new Node( 7,    -A,   2*D,    -B));
  Nodes.add(new Node( 8,     A,   2*D,    -B));
  Nodes.add(new Node( 9,     0,   3*D,    -C));  // layer 3
  Nodes.add(new Node(10,     A,   3*D,     B));
//  Nodes.add(new Node(11,    -A,   3*D,     B));
  
  float zAng = atan((C-B)/D);
  float offZ = 2*D*sin(zAng);
  float offX = 2*D*cos(zAng)*sin(3.14159/3);
  float offY = 2*D*cos(zAng)*cos(3.14159/3);

  Nodes.add(new Node(11,     0+offX,   2*D+offZ,     C-offY));  // layer 4 (note: faced from edge of layer 2-3 connection)
  Nodes.add(new Node(12,    -A+offX,   2*D+offZ,    -B-offY));
  Nodes.add(new Node(13,    -A+offX,   3*D+offZ,     B-offY));
  
  
//  Nodes.add(new Node(0,      0, -1.414,      0));
//  Nodes.add(new Node(1,  1.414,      0,      0));
//  Nodes.add(new Node(2,      0,  1.414,      0));
//  Nodes.add(new Node(3, -1.414,      0,      0));
//  Nodes.add(new Node(4,      0,      0,  1.414));
//  Nodes.add(new Node(5,      0,      0, -1.414));
}

void defineEdges() {
  Edges = new LinkedList<Edge>();
  Edges.add(new Edge(0, BOX0 + 7,  26,  0,  1));   // layer 0
  Edges.add(new Edge(0, BOX0 + 7,  60,  1,  2));
  Edges.add(new Edge(0, BOX0 + 7,  94,  2,  0));

  Edges.add(new Edge(0, BOX0 + 7,  26,  0,  4));   // layer 0-1 connections
  Edges.add(new Edge(0, BOX0 + 7,  60,  0,  5));
  Edges.add(new Edge(0, BOX0 + 7,  26,  1,  5));
  Edges.add(new Edge(0, BOX0 + 7,  60,  1,  3));
  Edges.add(new Edge(0, BOX0 + 7,  26,  2,  3));
  Edges.add(new Edge(0, BOX0 + 7,  60,  2,  4));
  
  Edges.add(new Edge(0, BOX0 + 7,  26,  3,  4));   // layer 1
  Edges.add(new Edge(0, BOX0 + 7,  60,  4,  5));
  Edges.add(new Edge(0, BOX0 + 7,  94,  5,  3));

  Edges.add(new Edge(0, BOX0 + 7,  26,  3,  7));   // layer 1-2 connections
  Edges.add(new Edge(0, BOX0 + 7,  60,  3,  8));
  Edges.add(new Edge(0, BOX0 + 7,  26,  4,  8));
  Edges.add(new Edge(0, BOX0 + 7,  60,  4,  6));
  Edges.add(new Edge(0, BOX0 + 7,  26,  5,  6));
  Edges.add(new Edge(0, BOX0 + 7,  60,  5,  7));

  Edges.add(new Edge(0, BOX0 + 7,  26,  6,  7));   // layer 2
  Edges.add(new Edge(0, BOX0 + 7,  60,  7,  8));
  Edges.add(new Edge(0, BOX0 + 7,  94,  8,  6));
  
  Edges.add(new Edge(0, BOX0 + 7,  26,  6, 10));   // layer 2-3 connections
//  Edges.add(new Edge(0, BOX0 + 7,  60,  6, 11));
//  Edges.add(new Edge(0, BOX0 + 7,  26,  7, 11));
  Edges.add(new Edge(0, BOX0 + 7,  60,  7,  9));
  Edges.add(new Edge(0, BOX0 + 7,  26,  8,  9));
  Edges.add(new Edge(0, BOX0 + 7,  60,  8, 10));

  Edges.add(new Edge(0, BOX0 + 7,  26,  9, 10));   // layer 3 (note:truncated)
//  Edges.add(new Edge(0, BOX0 + 7,  26, 10, 11));
//  Edges.add(new Edge(0, BOX0 + 7,  26, 11,  9));

  Edges.add(new Edge(0, BOX0 + 7,  26,  9, 12));   // layer 2/3-4 connections
  Edges.add(new Edge(0, BOX0 + 7,  60,  9, 13));
  Edges.add(new Edge(0, BOX0 + 7,  26, 10, 13));
  Edges.add(new Edge(0, BOX0 + 7,  60, 10, 11));
  Edges.add(new Edge(0, BOX0 + 7,  26,  8, 11));
  Edges.add(new Edge(0, BOX0 + 7,  60,  8, 12));

  Edges.add(new Edge(0, BOX0 + 7,  26, 11, 12));   // layer 4
  Edges.add(new Edge(0, BOX0 + 7,  60, 12, 13));
  Edges.add(new Edge(0, BOX0 + 7,  94, 13, 11));
  
  println(Edges.size());

  
//  Edges.add(new Edge(0, BOX0 + 7,  26, 0, 1));
//  Edges.add(new Edge(0, BOX0 + 7,  60, 1, 2));
//  Edges.add(new Edge(0, BOX0 + 7,  94, 2, 3));
//  Edges.add(new Edge(0, BOX0 + 7, 128, 3, 0));
//  
//  Edges.add(new Edge(0, BOX0 + 5,  26, 0, 4));
//  Edges.add(new Edge(0, BOX0 + 5,  60, 4, 2));
//  Edges.add(new Edge(0, BOX0 + 5,  94, 2, 5));
//  Edges.add(new Edge(0, BOX0 + 5, 128, 5, 0));
//  
//  Edges.add(new Edge(0, BOX0 + 4,  26, 1, 5));
//  Edges.add(new Edge(0, BOX0 + 4,  60, 5, 3));
//  Edges.add(new Edge(0, BOX0 + 4,  96, 3, 4));
//  Edges.add(new Edge(0, BOX0 + 4, 128, 4, 1));
}

