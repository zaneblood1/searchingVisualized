import java.util.PriorityQueue;
import java.util.Collections;
import java.util.List;
import java.util.LinkedList;
import java.util.Queue;
import java.util.Stack;
import java.util.concurrent.ThreadLocalRandom;
import java.util.Arrays;
import java.lang.reflect.Array;
import java.util.Arrays;
import java.util.NoSuchElementException;

PFont f;

float wide=1000;
float tall=800;
float w = 200;
float h = tall/5;

float x1 = wide-w;
float y1 = 0;
float x2 = wide-w;
float y2 = h;
float x3 = wide-w;
float y3 = 2*h;
float x4 = wide-w;
float y4 = 3*h;
float x5 = wide-w;
float y5 = 4*h;
//float x6 = wide-w;
//float y6 = 5*h;
//float x7 = wide-w;
//float y7 = 6*h;

Thread tBFS;
Thread tDFS;
Thread tBFSpq;
Thread tDJK;

int delayT=20;

int windowWide=800;
int windowTall=800;
int rows=20;
int cols=20;

int targetX=ThreadLocalRandom.current().nextInt(0, windowWide/cols);
int targetY=ThreadLocalRandom.current().nextInt(0, windowTall/rows);
int startX=ThreadLocalRandom.current().nextInt(0, windowWide/cols);
int startY=ThreadLocalRandom.current().nextInt(0, windowTall/rows);

int numBlocks=500;
String[][]map=new String[windowTall/rows][windowWide/cols];
HashMap<List<Integer>, Boolean> visited=new HashMap<>();

List<List<Integer>> dijkstraPath;                                                                                                                                                                                                              ";

void setup(){
  
  size(1000, 800);
  
  f = createFont("Arial",16,true);
  
  for (int i=0; i<numBlocks; i++){
    int first=ThreadLocalRandom.current().nextInt(0, windowTall/rows);
    int second=ThreadLocalRandom.current().nextInt(0, windowWide/cols);
    //The below if statement makes sure that the starte and end are not set as obstacles
    if((first!=startX || second!=startY) && (first!=targetX || second!=targetY)){
      map[first][second]="Grey";
    }
  }
  
  for(int x=0; x<map[0].length; x++){
    for(int y=0; y<map.length; y++){
        if(x==targetX && y==targetY){
            map[x][y]="Red";
        }
        if(map[x][y]!="Grey" && map[x][y]!="White" && map[x][y]!="Red"){
            map[x][y]="Blue";
        }
        if(x==startX && y==startY){
            map[x][y]="White"; 
        }
      }
    }
}

void draw(){
  
  for(int j=0; j<=windowWide-cols; j=j+cols){
    for(int i=0; i<=windowTall-rows; i=i+rows){
      
      if(map[i/rows][j/cols]=="Yellow"){
        //println("TRIGGERED");
        fill(218, 165, 32);
        rect(i, j, cols, rows);
      }
      
      if(map[i/rows][j/cols]=="Grey"){
        fill(0);
        rect(i, j, cols, rows);
      }
      
      if(map[i/rows][j/cols]=="White"){
        fill(255);
        rect(i, j, cols, rows);
      }
      
      if(map[i/rows][j/cols]=="Red"){
        fill(255, 0, 0);
        rect(i, j, cols, rows);
      }
      
      if(map[i/rows][j/cols]=="Green"){
        fill(0, 255, 0);
        rect(i, j, cols, rows);
      }
      
      if(map[i/rows][j/cols]=="Blue"){
        fill(127, 0, 255);
        rect(i, j, cols, rows);
      }
      
      if(map[i/rows][j/cols]=="Purple"){
        fill(0, 153, 153);
        rect(i, j, cols, rows);
      }
      
    }
  }
  
  if(tBFS==null || !tBFS.isAlive()){
  //Create a thread t that runs quicksort
  tBFS=new Thread(){
      public void run(){
        BFS(map);
      }
   };
}

  if(tDFS==null || !tDFS.isAlive()){
    //Create a thread t that runs quicksort
    tDFS=new Thread(){
        public void run(){
          DFS(map);
        }
     };
  }
  
  if(tBFSpq==null || !tBFSpq.isAlive()){
    //Create a thread t that runs quicksort
    tBFSpq=new Thread(){
        public void run(){
          pQueueSearch(map);
        }
     };
  }
  
  if(tDJK==null || !tDJK.isAlive()){
    //Create a thread t that runs quicksort
    tDJK=new Thread(){
        public void run(){
          dijkstraPath=shortestPath(Arrays.asList(startX, startY), Arrays.asList(targetX, targetY));
        }
     };
  }
  
  fill(0,0,255);
  rect(x1,y1,w,h);
  textFont(f,16);                  // STEP 3 Specify font to be used
  fill(0, 255, 0);                         // STEP 4 Specify font color
  text("New Map",x1+w/3.8,y1+h/2);   // STEP 5 Display Text
  
  //fill(0,0,255);
  //rect(x2,y2,w,h);
  //textFont(f,16);                  // STEP 3 Specify font to be used
  //fill(0, 255, 0);                         // STEP 4 Specify font color
  //text("Custom Map",x2+w/3,y2+h/2);   // STEP 5 Display Text
  
  //fill(0,0,255);
  //rect(x3,y3,w,h);
  //textFont(f,16);                  // STEP 3 Specify font to be used
  //fill(0, 255, 0);                         // STEP 4 Specify font color
  //text("Print Map",x3+w/3,y3+h/2);   // STEP 5 Display Text
   
  fill(0,0,255);
  rect(x2,y2,w,h);
  textFont(f,16);                  // STEP 3 Specify font to be used
  fill(0, 255, 0);                         // STEP 4 Specify font color
  text("Depth First Search",x2+w/6,y2+h/2);   // STEP 5 Display Text
  fill(0, 255, 0);                         // STEP 4 Specify font color
  text("(Stack)",x2+w/3,y2+((3*h)/4.5));   // STEP 5 Display Text
   
  fill(0,0,255);
  rect(x3,y3,w,h);
  textFont(f,16);                  // STEP 3 Specify font to be used
  fill(0, 255, 0);                         // STEP 4 Specify font color
  text("Breadth First Search",x3+w/8,y3+h/2);   // STEP 5 Display Text
  text("(Queue)",x3+w/3,y3+((3*h)/4.5));   // STEP 5 Display Text
   
  fill(0,0,255);
  rect(x4,y4,w,h);
  textFont(f,16);                  // STEP 3 Specify font to be used
  fill(0, 255, 0);                         // STEP 4 Specify font color
  text("Breadth First Search", x4+w/7, y4+h/2);   // STEP 5 Display Text
  text("(Priority Queue)",x4+w/4.5, y4+((3*h)/4.5));
   
  fill(0,0,255);
  rect(x5,y5,w,h);
  textFont(f,16);                  // STEP 3 Specify font to be used
  fill(0, 255, 0);                         // STEP 4 Specify font color
  text("Dijkstra's",x5+w/3,y5+h/2);   // STEP 5 Display Text
  text("Shortest Path",x5+w/3.8,y5+((3*h)/4.5));   // STEP 5 Display Text
  
  if(mousePressed){
 
    if(mouseX>x1 && mouseX <x1+w && mouseY>y1 && mouseY <y1+h
        && (tBFS==null || !tBFS.isAlive()) && (tDFS==null || !tDFS.isAlive()) && (tBFSpq==null || !tBFSpq.isAlive())
        && (tDJK==null || !tDJK.isAlive())){
          
       println("New Map!");
       
       targetX=ThreadLocalRandom.current().nextInt(0, windowWide/cols);
       targetY=ThreadLocalRandom.current().nextInt(0, windowTall/rows);
       startX=ThreadLocalRandom.current().nextInt(0, windowWide/cols);
       startY=ThreadLocalRandom.current().nextInt(0, windowTall/rows);
       
       map=new String[windowTall/rows][windowWide/cols];
       visited=new HashMap<List<Integer>, Boolean>();
       
       for (int i=0; i<numBlocks; i++){
          int first=ThreadLocalRandom.current().nextInt(0, windowTall/rows);
          int second=ThreadLocalRandom.current().nextInt(0, windowWide/cols);
          //The below if statement makes sure that the starte and end are not set as obstacles
          if((first!=startX || second!=startY) && (first!=targetX || second!=targetY)){
            map[first][second]="Grey";
          }
        }
  
      for(int x=0; x<map[0].length; x++){
        for(int y=0; y<map.length; y++){
            if(x==targetX && y==targetY){
                map[x][y]="Red";
            }
            if(map[x][y]!="Grey" && map[x][y]!="White" && map[x][y]!="Red"){
                map[x][y]="Blue";
            }
            if(x==startX && y==startY){
                map[x][y]="White"; 
            }
          }
        }
        
      }
      
     if(mouseX>x2 && mouseX<x2+w && mouseY>y2 && mouseY <y2+h
         && (tBFS==null || !tBFS.isAlive()) && (tDFS==null || !tDFS.isAlive()) && (tBFSpq==null || !tBFSpq.isAlive())
         && (tDJK==null || !tDJK.isAlive())){
       //in the above if statement add the conditions that all of the named program threads
       //are either null or not alive
       cleanMap();
       println("DFS!");
       try{tDFS.start();}catch(Exception e){};
      }
    
     if(mouseX>x3 && mouseX <x3+w && mouseY>y3 && mouseY <y3+h
         && (tBFS==null || !tBFS.isAlive()) && (tDFS==null || !tDFS.isAlive()) && (tBFSpq==null || !tBFSpq.isAlive())
         && (tDJK==null || !tDJK.isAlive())){
         cleanMap();
         println("BFS!");
         try{tBFS.start();}catch(Exception e){};
      }
      
      if(mouseX>x4 && mouseX <x4+w && mouseY>y4 && mouseY <y4+h
         && (tBFS==null || !tBFS.isAlive()) && (tDFS==null || !tDFS.isAlive()) && (tBFSpq==null || !tBFSpq.isAlive())
         && (tDJK==null || !tDJK.isAlive())){
       cleanMap();
       println("BFSpq!");
       try{tBFSpq.start();}catch(Exception e){};
      }
      
     //if(mouseX>x3 && mouseX <x3+w && mouseY>y3 && mouseY <y3+h
     //    && (tBFS==null || !tBFS.isAlive()) && (tDFS==null || !tDFS.isAlive()) && (tBFSpq==null || !tBFSpq.isAlive())
     //    && (tDJK==null || !tDJK.isAlive())){
     //    for(int i=0; i<map.length; i++){
     //        for(int j=0;j<map[0].length; j++){
     //            if(map[i][j]=="Blue" || map[i][j]=="Yellow" || map[i][j]=="Green"){print("U");}
     //            else if(map[i][j]=="White"){print("W");}
     //            else if(map[i][j]=="Grey"){print("B");}
     //            else if(map[i][j]=="Red"){print("R");}
     //        }
     //    }
     // }
      
      if(mouseX>x5 && mouseX <x5+w && mouseY>y5 && mouseY <y5+h
         && (tBFS==null || !tBFS.isAlive()) && (tDFS==null || !tDFS.isAlive()) && (tBFSpq==null || !tBFSpq.isAlive())
         && (tDJK==null || !tDJK.isAlive())){
       //in the above if statement add the conditions that all of the named program threads
       //are either null or not alive
       cleanMap();
       println("Dijkstra!");
       try{tDJK.start();}catch(Exception e){};
      }
      
      //if(mouseX>x2 && mouseX<x2+w && mouseY>y2 && mouseY<y2+h
      //   && (tBFS==null || !tBFS.isAlive()) && (tDFS==null || !tDFS.isAlive()) && (tBFSpq==null || !tBFSpq.isAlive())
      //   && (tDJK==null || !tDJK.isAlive())){
      // //in the above if statement add the conditions that all of the named program threads
      // //are either null or not alive
      // println("Custom Map!");
      // //if(custom.length()!=(windowWide/cols)*(windowTall/rows)){println("Custom map not adequate size...");}
      //   int r=0;
      //   int i=0;
      //   while(i<custom.length()){
      //     int c=0;
      //     while(c<map[0].length){
      //       if(custom.charAt(i)=='U'){map[r][c]="Blue";}
      //       else if(custom.charAt(i)=='B'){map[r][c]="Grey";}
      //       else if(custom.charAt(i)=='W'){map[r][c]="White";}
      //       else if(custom.charAt(i)=='R' || custom.charAt(i)=='G'){map[r][c]="Red";}
      //       c++;
      //       i++;
      //     }
      //     r++;
      //   }
      // redraw();
      //}
    }
  }

void DFS(String[][] grid){
  
  println("DFS started");
  Stack<List<Integer>> stack=new Stack<List<Integer>>();
  visited=new HashMap<>();
  
  List<Integer> temp=new ArrayList<>();
  temp.add(startX);
  temp.add(startY);
  
  stack.add(temp);
  boolean running=true;
  
  while(!stack.isEmpty() && running){
  
  List<Integer>coord=stack.pop();
  int r=coord.get(0);
  int c=coord.get(1);
  println(coord);
  
  //paint the square yellow once on it
  if(grid[coord.get(0)][coord.get(1)]!="Grey" && grid[coord.get(0)][coord.get(1)]!="White"){
     grid[coord.get(0)][coord.get(1)]="Yellow";
  }
  try {Thread.sleep(delayT);}catch(Exception e){};
  redraw();
  
  //paint the square green if it is the target
  if(coord.get(0)==targetX && coord.get(1)==targetY){
    grid[coord.get(0)][coord.get(1)]="Green";
    try {Thread.sleep(delayT);}catch(Exception e){};
    redraw();
    running=false;
    }

    
  if(coord.get(0)+1<windowTall/rows && visited.get(Arrays.asList(r+1, c))==null && grid[r][c]!="Grey"){
      List<Integer> temp2=new ArrayList<>();
      temp2.add(r+1);
      temp2.add(c);
      visited.put(Arrays.asList(r+1, c), true);
      stack.push(temp2);
    }
    
  if(coord.get(0)-1>=0 && visited.get(Arrays.asList(r-1, c))==null && grid[r][c]!="Grey"){
      List<Integer> temp3=new ArrayList<>();
      temp3.add(r-1);
      temp3.add(c);
      visited.put(Arrays.asList(r-1, c), true);
      stack.push(temp3);
    }
    
  if(coord.get(1)-1>=0 && visited.get(Arrays.asList(r, c-1))==null && grid[r][c]!="Grey"){
      List<Integer> temp1=new ArrayList<>();
      temp1.add(r);
      temp1.add(c-1);
      visited.put(Arrays.asList(r, c-1), true);
      stack.push(temp1);
    }
    
  if(coord.get(1)+1<windowWide/cols && visited.get(Arrays.asList(r, c+1))==null && grid[r][c]!="Grey"){
      List<Integer> temp4=new ArrayList<>();
      temp4.add(r);
      temp4.add(c+1);
      visited.put(Arrays.asList(r, c+1), true);
      stack.push(temp4);
    }
  }
}

void BFS(String[][] grid){
  
  println("BFS started");
  Queue<List<Integer>> q=new LinkedList<List<Integer>>();
  visited=new HashMap<>();
  
  List<Integer> temp=new ArrayList<>();
  temp.add(startX);
  temp.add(startY);
  
  q.add(temp);
  boolean running=true;
  
  while(!q.isEmpty() && running){
  
  List<Integer>coord=q.poll();
  int r=coord.get(0);
  int c=coord.get(1);
  println(coord);
  
  //paint the square yellow once on it
  if(grid[coord.get(0)][coord.get(1)]!="Grey" && grid[coord.get(0)][coord.get(1)]!="White"){
     grid[coord.get(0)][coord.get(1)]="Yellow";
  }
  try {Thread.sleep(delayT);}catch(Exception e){};
  redraw();
  
  //paint the square green if it is the target
  if(coord.get(0)==targetX && coord.get(1)==targetY){
    grid[coord.get(0)][coord.get(1)]="Green";
    try {Thread.sleep(delayT);}catch(Exception e){};
    redraw();
    running=false;
    }

    
  if(coord.get(0)+1<windowTall/rows && visited.get(Arrays.asList(r+1, c))==null && grid[r][c]!="Grey"){
      List<Integer> temp2=new ArrayList<>();
      temp2.add(r+1);
      temp2.add(c);
      visited.put(Arrays.asList(r+1, c), true);
      q.add(temp2);
    }
    
  if(coord.get(0)-1>=0 && visited.get(Arrays.asList(r-1, c))==null && grid[r][c]!="Grey"){
      List<Integer> temp3=new ArrayList<>();
      temp3.add(r-1);
      temp3.add(c);
      visited.put(Arrays.asList(r-1, c), true);
      q.add(temp3);
    }
    
  if(coord.get(1)-1>=0 && visited.get(Arrays.asList(r, c-1))==null && grid[r][c]!="Grey"){
      List<Integer> temp1=new ArrayList<>();
      temp1.add(r);
      temp1.add(c-1);
      visited.put(Arrays.asList(r, c-1), true);
      q.add(temp1);
    }
    
  if(coord.get(1)+1<windowWide/cols && visited.get(Arrays.asList(r, c+1))==null && grid[r][c]!="Grey"){
      List<Integer> temp4=new ArrayList<>();
      temp4.add(r);
      temp4.add(c+1);
      visited.put(Arrays.asList(r, c+1), true);
      q.add(temp4);
    }
  }
}

void pQueueSearch(String[][] grid){
  
  println("pQueueSearch started");
  PriorityQueue<List<Integer>> pq=new PriorityQueue<List<Integer>>((a,b)->((int)Math.sqrt((int)Math.pow(a.get(0)-targetX, 2)+(int)Math.pow(a.get(1)-targetY, 2))-(int)Math.sqrt((int)Math.pow(b.get(0)-targetX, 2)+(int)Math.pow(b.get(1)-targetY, 2))));
  visited=new HashMap<>();
  
  List<Integer> temp=new ArrayList<>();
  temp.add(startX);
  temp.add(startY);
  
  pq.add(temp);
  boolean running=true;
  
  while(!pq.isEmpty() && running){
  
  List<Integer>coord=pq.poll();
  int r=coord.get(0);
  int c=coord.get(1);
  println(coord);
  
  //paint the square yellow once on it
  if(grid[coord.get(0)][coord.get(1)]!="Grey" && grid[coord.get(0)][coord.get(1)]!="White"){
     grid[coord.get(0)][coord.get(1)]="Yellow";
  }
  try {Thread.sleep(delayT);}catch(Exception e){};
  redraw();
  
  //paint the square green if it is the target
  if(coord.get(0)==targetX && coord.get(1)==targetY){
    grid[coord.get(0)][coord.get(1)]="Green";
    try {Thread.sleep(delayT);}catch(Exception e){};
    redraw();
    running=false;
    }

    
  if(coord.get(0)+1<windowTall/rows && visited.get(Arrays.asList(r+1, c))==null && grid[r][c]!="Grey"){
      List<Integer> temp2=new ArrayList<>();
      temp2.add(r+1);
      temp2.add(c);
      visited.put(Arrays.asList(r+1, c), true);
      pq.add(temp2);
    }
    
  if(coord.get(0)-1>=0 && visited.get(Arrays.asList(r-1, c))==null && grid[r][c]!="Grey"){
      List<Integer> temp3=new ArrayList<>();
      temp3.add(r-1);
      temp3.add(c);
      visited.put(Arrays.asList(r-1, c), true);
      pq.add(temp3);
    }
    
  if(coord.get(1)-1>=0 && visited.get(Arrays.asList(r, c-1))==null && grid[r][c]!="Grey"){
      List<Integer> temp1=new ArrayList<>();
      temp1.add(r);
      temp1.add(c-1);
      visited.put(Arrays.asList(r, c-1), true);
      pq.add(temp1);
    }
    
  if(coord.get(1)+1<windowWide/cols && visited.get(Arrays.asList(r, c+1))==null && grid[r][c]!="Grey"){
      List<Integer> temp4=new ArrayList<>();
      temp4.add(r);
      temp4.add(c+1);
      visited.put(Arrays.asList(r, c+1), true);
      pq.add(temp4);
    }
  }
}

public List<List<Integer>> shortestPath(List<Integer> v, List<Integer> end) {

    // Contains an entry for each node in the frontier set. The priority of
    // a node is the length of the shortest known path from v to the node
    // using only settled nodes except for the last node, which is in F.
    var F= new Heap<List<Integer>>(true);

    // Put in a declaration of the HashMap here, with a suitable name
    // for it and a suitable definition of its meaning --what it contains,
    // etc. See Section 10 point 4 of the A7 handout for help.

    // The HashMap SandF contains the important information about
    // each node in both the settled and frontier set (i.e. the distance
    // from the start node to this node, and the backpointer from this
    // node to the closest node before it):
    HashMap<List<Integer>, Info> SandF= new HashMap<>();

    // Information for the start node:
    Info vInfo= new Info(0, null);

    // Add the start node's information to the SandF collection:
    F.insert(v, 0);
    SandF.put(v, vInfo);

    // Continue the loop while the frontier set is non-empty:
    while (F.size() != 0) {

        // Node f in Frontier with minimum d-value:
        List<Integer> f= F.poll();

        // If we've reached the end node, stop the loop:
        if (f.equals(end)) { return pathToEnd(SandF, end); }
        
        if(f.get(0)+1<windowTall/rows && map[f.get(0)+1][f.get(1)]!="Grey"){
          
            // The neighbor w of f for the given edge we are at:
            List<Integer> w= Arrays.asList(f.get(0)+1, f.get(1));

            // d[w]= d[f] + wgt(f, w);
            int dw= SandF.get(f).dist + 1;

            // Set the backpointer of w to be f:
            Info wInfo= new Info(dw, f);

            // If w is not in S or F:
            if (!SandF.containsKey(w)) {

                // Add w to F:
                F.insert(w, dw);
                
                ///////////////
                if(w.get(0)==targetX && w.get(1)==targetY){
                    map[w.get(0)][w.get(1)]="Green";
                }
                else{
                  map[w.get(0)][w.get(1)]="Purple";
                }
                try {Thread.sleep(delayT);}catch(Exception e){};
                redraw();
                ///////////////

                // Store w's backpointer in SandF:
                SandF.put(w, wInfo);

            }
            // shorter path to w is found:
            else if (dw < SandF.get(w).dist) {

                // Update the priority of w in F:
                F.changePriority(w, dw);
                
                ///////////////
                if(w.get(0)==targetX && w.get(1)==targetY){
                    map[w.get(0)][w.get(1)]="Green";
                }
                else{
                  map[w.get(0)][w.get(1)]="Purple";
                }
                try {Thread.sleep(delayT);}catch(Exception e){};
                redraw();
                ///////////////

                // Update the info about w in SandF:
                SandF.replace(w, wInfo);
            }
        }
        
        if(f.get(1)+1<windowWide/cols && map[f.get(0)][f.get(1)+1]!="Grey"){
          
            // The neighbor w of f for the given edge we are at:
            List<Integer> w= Arrays.asList(f.get(0), f.get(1)+1);

            // d[w]= d[f] + wgt(f, w);
            int dw= SandF.get(f).dist + 1;

            // Set the backpointer of w to be f:
            Info wInfo= new Info(dw, f);

            // If w is not in S or F:
            if (!SandF.containsKey(w)) {

                // Add w to F:
                F.insert(w, dw);
                
                ///////////////
                if(w.get(0)==targetX && w.get(1)==targetY){
                    map[w.get(0)][w.get(1)]="Green";
                }
                else{
                  map[w.get(0)][w.get(1)]="Purple";
                }
                try {Thread.sleep(delayT);}catch(Exception e){};
                redraw();
                ///////////////

                // Store w's backpointer in SandF:
                SandF.put(w, wInfo);

            }
            // shorter path to w is found:
            else if (dw < SandF.get(w).dist) {

                // Update the priority of w in F:
                F.changePriority(w, dw);
                
                ///////////////
                if(w.get(0)==targetX && w.get(1)==targetY){
                    map[w.get(0)][w.get(1)]="Green";
                }
                else{
                  map[w.get(0)][w.get(1)]="Purple";
                }
                try {Thread.sleep(delayT);}catch(Exception e){};
                redraw();
                ///////////////

                // Update the info about w in SandF:
                SandF.replace(w, wInfo);
            }
        }
        
        if(f.get(0)-1>=0 && map[f.get(0)-1][f.get(1)]!="Grey"){
           
            // The neighbor w of f for the given edge we are at:
            List<Integer> w= Arrays.asList(f.get(0)-1, f.get(1));

            // d[w]= d[f] + wgt(f, w);
            int dw= SandF.get(f).dist + 1;

            // Set the backpointer of w to be f:
            Info wInfo= new Info(dw, f);

            // If w is not in S or F:
            if (!SandF.containsKey(w)) {

                // Add w to F:
                F.insert(w, dw);
                
                ///////////////
                if(w.get(0)==targetX && w.get(1)==targetY){
                    map[w.get(0)][w.get(1)]="Green";
                }
                else{
                  map[w.get(0)][w.get(1)]="Purple";
                }
                try {Thread.sleep(delayT);}catch(Exception e){};
                redraw();
                ///////////////

                // Store w's backpointer in SandF:
                SandF.put(w, wInfo);

            }
            // shorter path to w is found:
            else if (dw < SandF.get(w).dist) {

                // Update the priority of w in F:
                F.changePriority(w, dw);
                
                ///////////////
                if(w.get(0)==targetX && w.get(1)==targetY){
                    map[w.get(0)][w.get(1)]="Green";
                }
                else{
                  map[w.get(0)][w.get(1)]="Purple";
                }
                try {Thread.sleep(delayT);}catch(Exception e){};
                redraw();
                ///////////////

                // Update the info about w in SandF:
                SandF.replace(w, wInfo);
            }
        }
        
        if(f.get(1)-1>=0 && map[f.get(0)][f.get(1)-1]!="Grey"){
             
            // The neighbor w of f for the given edge we are at:
            List<Integer> w= Arrays.asList(f.get(0), f.get(1)-1);

            // d[w]= d[f] + wgt(f, w);
            int dw= SandF.get(f).dist + 1;

            // Set the backpointer of w to be f:
            Info wInfo= new Info(dw, f);

            // If w is not in S or F:
            if (!SandF.containsKey(w)) {

                // Add w to F:
                F.insert(w, dw);
                
                ///////////////
                if(w.get(0)==targetX && w.get(1)==targetY){
                    map[w.get(0)][w.get(1)]="Green";
                }
                else{
                  map[w.get(0)][w.get(1)]="Purple";
                }
                try {Thread.sleep(delayT);}catch(Exception e){};
                redraw();
                ///////////////

                // Store w's backpointer in SandF:
                SandF.put(w, wInfo);

            }
            // shorter path to w is found:
            else if (dw < SandF.get(w).dist) {

                // Update the priority of w in F:
                F.changePriority(w, dw);
                
                ///////////////
                if(w.get(0)==targetX && w.get(1)==targetY){
                    map[w.get(0)][w.get(1)]="Green";
                }
                else{
                  map[w.get(0)][w.get(1)]="Purple";
                }
                try {Thread.sleep(delayT);}catch(Exception e){};
                redraw();
                ///////////////

                // Update the info about w in SandF:
                SandF.replace(w, wInfo);
            }
        }
    }

    // Put all your code before this comment. Do not change this comment or return statement
    // no path from v to end.
    return new LinkedList<>();
}

/** An instance contains info about a node: <br>
     * the known shortest distance of this node from the start node and <br>
     * its backpointer: the previous node on a shortest path <br>
     * from the first node to this node (null for the start node). */
    private static class Info {
        /** shortest known distance from the start node to this one. */
        private int dist;
        /** backpointer on path (with shortest known distance) from <br>
         * start node to this one */
        private List<Integer> bkptr;

        /** Constructor: an instance with dist d from the start node and<br>
         * backpointer p. */
        private Info(int d, List<Integer> p) {
            dist= d;     // Distance from start node to this one.
            bkptr= p;    // Backpointer on the path (null if start node)
        }

        /** = a representation of this instance. */
        @Override
        public String toString() {
            return "dist " + dist + ", bckptr " + bkptr;
        }
    }

public List<List<Integer>> pathToEnd(HashMap<List<Integer>, Info> SandF, List<Integer >end) {
        List<List<Integer>> path= new LinkedList<>();
        var p= end;
        // invariant: All the nodes from p's successor to node
        // . . . . . .end are in path, in reverse order.
        while (p != null) {
            path.add(0, p);
            if(p.get(0)==startX && p.get(1)==startY){map[p.get(0)][p.get(1)]="White";}
            else if(p.get(0)==targetX && p.get(1)==targetY){map[p.get(0)][p.get(1)]="Green";}
            else{map[p.get(0)][p.get(1)]="Yellow";}
            p= SandF.get(p).bkptr;
            try {Thread.sleep(delayT);}catch(Exception e){};
            redraw();
        }
        return path;
    }

public final class Heap<T> {
  
    protected final boolean isMinHeap;
    protected Pair[] b;
    protected int size;
    protected HashMap<T, Integer> map;

    /** Constructor: an empty heap with capacity 10. <br>
     * It is a min-heap if isMin is true and a max-heap if isMin is false. */
    public Heap(boolean isMin) {
        isMinHeap= isMin;
        b= createPairArray(10);
        map= new HashMap<>();
    }

    /** If size = length of b, double the length of array b. <br>
     * The worst-case time is proportional to the length of b. */
    protected void ensureSpace() {
        if (size == b.length) b= Arrays.copyOf(b, 2 * b.length);
    }

    /** Insert v with priority p to the heap. <br>
     * Throw an illegalArgumentException if v is already in the heap. <br>
     * The expected time is logarithmic and <br>
     * the worst-case time is linear in the size of the heap. */
    public void insert(T v, double p) throws IllegalArgumentException {
        if (map.containsKey(v)) throw new IllegalArgumentException("v already in the heap");

        ensureSpace();
        map.put(v, size);
        b[size]= new Pair(v, p);
        size= size + 1;
        bubbleUp(size - 1);
    }

    /** Return the size of this heap. <br>
     * This operation takes constant time. */
    public int size() {
        return size;
    }

    /** Swap b[h] and b[k]. <br>
     * Precondition: 0 <= h < heap-size, 0 <= k < heap-size. */
    void swap(int h, int k) {
        assert 0 <= h && h < size && 0 <= k && k < size;
        var temp= b[h];
        b[h]= b[k];
        b[k]= temp;
        map.put(b[h].value, h);
        map.put(b[k].value, k);
    }

    /** If a value with priority p1 belongs above a value with priority p2 in the heap, <br>
     * return 1.<br>
     * If priority p1 and priority p2 are the same, return 0. <br>
     * If a value with priority p1 should be below a value with priority p2 in the heap,<br>
     * return -1.<br>
     * This is based on what kind of a heap this is, <br>
     * ... E.g. a min-heap, the value with the smallest priority is in the root.<br>
     * ... E.g. a max-heap, the value with the largest priority is in the root. */
    public int compareTo(double p1, double p2) {
        if (p1 == p2) return 0;
        if (isMinHeap) { return p1 < p2 ? 1 : -1; }
        return p1 > p2 ? 1 : -1;
    }

    /** If b[h] should be above b[k] in the heap, return 1. <br>
     * If b[h]'s priority and b[k]'s priority are the same, return 0. <br>
     * If b[h] should be below b[k] in the heap, return -1. <br>
     * This is based on what kind of a heap this is, <br>
     * ... E.g. a min-heap, the value with the smallest priority is in the root. <br>
     * ... E.g. a max-heap, the value with the largest priority is in the root. */
    public int compareTo(int h, int k) {
        return compareTo(b[h].priority, b[k].priority);
    }

    /** If h >= size, return.<br>
     * Otherwise, bubble b[h] up the heap to its right place. <br>
     * Precondition: 0 <= h and, if h < size, <br>
     * ... the class invariant is true, except perhaps that <br>
     * ... b[h] belongs above its parent (if h > 0) in the heap. */
    void bubbleUp(int h) {
        while (h > 0) {
            var p= (h - 1) / 2; // p is h's parent
            if (compareTo(h, p) <= 0) return;
            swap(h, p);
            h= p;
        }
    }

    /** If this is a min-heap, return the heap value with lowest priority. <br>
     * If this is a max-heap, return the heap value with highest priority.<br>
     * Do not change the heap. <br>
     * This operation takes constant time. <br>
     * Throw a NoSuchElementException if the heap is empty. */
    public T peek() {
        if (size <= 0) throw new NoSuchElementException("heap is empty");
        return b[0].value;
    }

    /** If h < 0 or size <= h, return.<br>
     * Otherwise, Bubble b[h] down in heap until the class invariant is true. <br>
     * If there is a choice to bubble down to both the left and right children <br>
     * (because their priorities are equal), choose the left child. <br>
     *
     * Precondition: If 0 <= h < size, the class invariant is true except that <br>
     * perhaps b[h] belongs below one or both of its children. */
    void bubbleDown(int h) {
        if (h < 0 || size <= h) return;
        var k= 2 * h + 1;
        // Invariant: k is h's left child and
        // .......... Class invariant is true except that perhaps
        // .......... b[h] belongs below one or both of its children
        while (k < size) { // while b[h] has a child
            // Set uc to the child to bubble with
            var uc= k + 1 == size || compareTo(k, k + 1) >= 0 ? k : k + 1;

            if (compareTo(h, uc) >= 0) return;
            swap(h, uc);
            h= uc;
            k= 2 * h + 1;
        }
    }

    /** If this is a min-heap, remove and return heap value with lowest priority. <br>
     * If this is a max-heap, remove and return heap value with highest priority. <br>
     * Expected time: logarithmic. Worst-case time: linear in the size of the heap.<br>
     * Throw a NoSuchElementException if the heap is empty. */
    public T poll() {
        if (size <= 0) throw new NoSuchElementException("heap is empty");
        var v= b[0].value;
        swap(0, size - 1);
        map.remove(v);
        size= size - 1;
        bubbleDown(0);
        return v;
    }

    /** Change the priority of value v to p. <br>
     * Expected time: logarithmic. Worst-case time: linear in the size of the heap.<br>
     * Throw an IllegalArgumentException if v is not in the heap. */
    public void changePriority(T v, double p) {
        var index= map.get(v);
        if (index == null) throw new IllegalArgumentException("v is not in the heap");
        var oldP= b[index].priority;
        b[index].priority= p;
        var t= compareTo(p, oldP);
        if (t == 0) return;
        if (t < 0) bubbleDown(index);
        else bubbleUp(index);
    }

    /** Return the heap values (only, not the priorities) in form [5, 3, 2]. */
    public String toStringValues() {
        var resb= new StringBuilder("[");
        for (var h= 0; h < size; h= h + 1) {
            if (h > 0) resb.append(", ");
            resb.append(b[h].value);
        }
        return resb.append(']').toString();
    }

    /** Return the heap priorities in form [5.0, 3.0, 2.0]. */
    public String toStringPriorities() {
        var resb= new StringBuilder("[");
        for (var h= 0; h < size; h= h + 1) {
            if (h > 0) resb.append(", ");
            resb.append(b[h].priority);
        }
        return resb.append(']').toString();
    }

    /** Create and return an array of size m. */
    Pair[] createPairArray(int m) {
        return (Pair[]) Array.newInstance(Pair.class, m);
    }

    /** An object of class Pair houses a value and a priority. */
    class Pair {
        /** The value */
        protected T value;
        /** The priority */
        protected double priority;

        /** An instance with value v and priority p. */
        protected Pair(T v, double p) {
            value= v;
            priority= p;
        }

        /** Return a representation of this object. */
        @Override
        public String toString() {
            return "(" + value + ", " + priority + ")";
        }

        /** = "this and ob are of the same class and have equal val and priority fields." */
        @Override
        public boolean equals(Object ob) {
            if (ob == null || getClass() != ob.getClass()) return false;
            var obe= (Pair) ob;
            return value == obe.value && priority == obe.priority;
        }
    }
}

public void cleanMap(){
  for(int x=0; x<map[0].length; x++){
    for(int y=0; y<map.length; y++){
        if(map[x][y]=="Grey"){map[x][y]="Grey";}
        else if(map[x][y]=="Green"){map[x][y]="Red";}
        else if(map[x][y]=="White"){map[x][y]="White";}
        else if(map[x][y]=="Blue" || map[x][y]=="Purple" || map[x][y]=="Yellow"){map[x][y]="Blue";}
        redraw();
    }
  }
}
