// Share this between the transmitter and simulator.

// naming scheme 0xABCD A=box B=strip
void defineNodes() {
  Nodes = new LinkedList<Node>();

  int nodeCnt = 0;

  // nodes for panel
  for (int i=0; i<panelCnt; i++) {
    for (int j=0; j<stripsPerPanel; j++) {
      //for (int k=0; k<(panelMaxHeight+1); k++) {
      for (int k=panelMaxHeight; k>=0; k--) {
        Nodes.add(new Node(nodeCnt, i*(pWidth+pSpacing)+j*sSpacing, -k*pHeight, 0));
        nodeCnt++;
      }
    }
  }

  /* // nodes for left panel
   float lPanelOffset = (panelCnt)*(pWidth + pSpacing);
   for (int i=0; i<panelCnt; i++) {
   for (int j=0; j<stripsPerPanel; j++) {
   //for (int k=0; k<(panelMaxHeight+1); k++) {
   for (int k=panelMaxHeight; k>=0; k--) {
   Nodes.add(new Node(nodeCnt, lPanelOffset - (i*(pWidth+pSpacing)+j*sSpacing), -k*pHeight, 0));
   nodeCnt++;
   }
   }
   }
   */

  println(Nodes.size());
}


void defineEdges() {
  lEdges = new LinkedList<Edge>();
  rEdges = new LinkedList<Edge>();

  int nodeCnt = 0;
  int edgeCnt = 0;

  // right panel edges
  for (int i=0; i<panelCnt; i++) {
    for (int j=0; j<stripsPerPanel; j++) {
      for (int k=0; k<(panelMaxHeight+1); k++) {
        int nodeID = nodeCnt;
        println("Edge from "+str(nodeID)+" to "+str(nodeID+1)+" ("+str(i)+","+str(j)+","+str(k)+")");
        if (k<i) {
          rEdges.add(new Edge(0, (i*stripsPerPanel+j), k*ledsPerMeter, nodeID, nodeID+1, false));
          edgeCnt++;
        } 
        else if (k<panelMaxHeight) {
          rEdges.add(new Edge(0, (i*stripsPerPanel+j), k*ledsPerMeter, nodeID, nodeID+1, true));
          edgeCnt++;
        }
        nodeCnt++;
      }
      println();
    }
    println();
  }

  nodeCnt = 0;
  //nodeCnt = nodeCnt - 1;

  // left panel edges
  for (int i=(panelCnt-1); i>=0; i--) {
    for (int j=(stripsPerPanel-1); j>=0; j--) {
      for (int k=0; k<(panelMaxHeight+1); k++) {
        int nodeID = nodeCnt;
        println("Edge from "+str(nodeID)+" to "+str(nodeID+1)+" ("+str(i)+","+str(j)+","+str(k)+")");
        if (k<(panelMaxHeight-(i+1))) {
          lEdges.add(new Edge(0, (i*stripsPerPanel+j), k*ledsPerMeter, nodeID, nodeID+1, false));
          edgeCnt++;
        } 
        else if (k<panelMaxHeight) {
          lEdges.add(new Edge(0, (i*stripsPerPanel+j), k*ledsPerMeter, nodeID, nodeID+1, true));
          edgeCnt++;
        }
        nodeCnt++;
      }
      println();
    }
    println();
  }

  print(str(lEdges.size())+" left edges plus "+str(rEdges.size())+" right edges = ");
  println(edgeCnt);
}

