// Share this between the transmitter and simulator.

// naming scheme 0xABCD A=box B=strip
void defineNodes() {
  Nodes = new LinkedList<Node>();

  int nodeCnt = 0;

  // nodes for left panel
  for (int i=0; i<panelCnt; i++) {
    for (int j=0; j<stripsPerPanel; j++) {
      //for (int k=0; k<(panelMaxHeight+1); k++) {
      for (int k=panelMaxHeight; k>=0; k--) {
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
  for (int i=0; i<panelCnt; i++) {
    for (int j=0; j<stripsPerPanel; j++) {
      for (int k=0; k<(panelMaxHeight+1); k++) {
        int nodeID = nodeCnt;
        println("Edge from "+str(nodeID)+" to "+str(nodeID+1)+" ("+str(i)+","+str(j)+","+str(k)+")");
        if (k<i) {
          Edges.add(new Edge(0, (i*stripsPerPanel+j), k*ledsPerMeter, nodeID, nodeID+1, false));
        } 
        else if (k<panelMaxHeight) {
          Edges.add(new Edge(0, (i*stripsPerPanel+j), k*ledsPerMeter, nodeID, nodeID+1, true));
        }
        nodeCnt++;
      }
      println();
    }
    println();
  }

  println(Edges.size());
}

