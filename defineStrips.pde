// Share this between the transmitter and simulator.

// naming scheme 0xABCD A=box B=strip
void defineNodes() {
  Nodes = new LinkedList<Node>();

  int nodeCnt = 0;
  
  // nodes for left panel
  for (int i=0; i<4; i++) {
    for (int j=0; j<4; j++) {
      for (int k=0; k<(5-i); k++) {
        Nodes.add(new Node(nodeCnt, i*(pWidth+pSpacing)+j*sSpacing, -k*pHeight, 0));
        nodeCnt++;
      }
    }
  }

  println(Nodes.size());
}


void defineEdges() {
  Edges = new LinkedList<Edge>();

  int nodeCnt = 0;
  // left edges
  for (int i=0; i<4; i++) {
    for (int j=0; j<4; j++) {
      for (int k=0; k<(5-i); k++) {
        if (k<(4-i)) {
          int nodeID = nodeCnt;
          println("Edge from "+str(nodeID)+" to "+str(nodeID+1)+" ("+str(i)+","+str(j)+","+str(k)+")");
          Edges.add(new Edge(0, (i*4+j), k*30, nodeID, nodeID+1));
        }
        nodeCnt++;
      }
      println();
    }
    println();
  }

  println(Edges.size());
}

