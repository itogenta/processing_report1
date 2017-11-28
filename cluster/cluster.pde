//for load file
String[] lines;
int line_index = 0;

int sampleN = 45;
int clusterN = 3;

PVector [] sample = new PVector [sampleN];
int [] cluster = new int [sampleN];
int [] prevCluster = new int [sampleN];

PVector [] center = new PVector [clusterN];

boolean key_pressed_sign;

//画像の面積
float[] picsarea = {9787, 9862, 4779, 8037, 5472, 7675, 10507, 11551, 6605, 6508,
                  5420, 4373, 1497, 2918, 3265, 42254, 6001, 14421, 9575, 5841,
                  12424, 15009, 11512, 8514, 6576, 13392, 10165, 17195, 1815, 4019,
                  4437, 1492, 5368, 1339, 3187, 6399, 641, 7, 1447, 7590,
                  5033, 2308, 1719, 855, 19969};
                  
//グリーンの平均値
float[] picsred = {23, 24, 39, 28, 32, 24, 28, 23, 24, 22,
                 18, 16, 14, 23, 27, 125, 55, 102, 84, 65,
                 76, 102, 75, 71, 65, 98, 78, 115, 23, 39,
                 95, 181, 99, 116, 175, 119, 111, 168, 181, 109,
                 128, 127, 105, 108, 135};           

PImage[] pics = new PImage[sampleN];

void setup(){
  size(800, 800, P2D);
  smooth();
  rectMode(CENTER);
  
  //load data();
  
  for(int i = 0, j = 1; i < sampleN; i++, j++){
    String picspath;
    if(i < 9){
      picspath = "pic0" + j + ".jpg";
    }
    else{
      picspath = "pic" + j + ".jpg";
    }
    pics[i] = loadImage(picspath);
//    picsarea[i] = picsarea[i] / 120;
//    picsred[i] = picsred[i] * 5;
    picsarea[i] = picsarea[i] / 109;
    picsred[i] = picsred[i] * 4;
  }
  
  for(int i = 0; i < sampleN; i++) {
    sample[i] = new PVector(picsarea[i], picsred[i]);
  }
  
  for(int i = 0; i < clusterN; i++){
    center[i] = new PVector(random(10, width-10), random(10, height-10));
  }
    
  for(int i = 0; i < sampleN; i++){
    cluster[i] = i % clusterN;
    prevCluster[i] = -1;
  }
  
  key_pressed_sign = false;
}

void draw(){
  background(0);
  
  if(key_pressed_sign == true){
    clustering();
    key_pressed_sign = false;
  }
  
  for(int i = 0; i < sampleN; i++){
    pushMatrix();
    if(cluster[i] == 0)stroke(255, 0, 0);
    else if(cluster[i] == 1)stroke(255, 255, 0);
    else if(cluster[i] == 2)stroke(0, 255, 255);
    
    noFill();
    rect(sample[i].x, sample[i].y, 20, 20);
//    image(pics[i], sample[i].x, sample[i].y, 20, 20);
    popMatrix();
  }
  
  for(int i = 0; i < clusterN; i++){
    pushMatrix();
    if(i == 0)fill(255, 0, 0);
    else if(i == 1)fill(255, 255, 0);
    else if(i == 2)fill(0, 255, 255);
    
    noStroke();
    ellipse(center[i].x, center[i].y, 30, 30);
    popMatrix();
  }
}

void clustering(){
  boolean e = false;
  
  for(int i = 0; i < sampleN; i++){
    if(prevCluster[i] != cluster[i]){
      e = true;
    }
  }
  
  if(e == true){
    for(int i = 0; i < sampleN; i++){
      prevCluster[i] = cluster[i];
    }
    
    for(int i = 0; i < sampleN; i++){
      int max_cluster = -1;
      float max_value = width*height;
      
      for(int j = 0; j < clusterN; j++){
        if(max_value > PVector.dist(sample[i], center[j])){
          max_value = PVector.dist(sample[i], center[j]);
          max_cluster = j;
        }
      }
      cluster[i] = max_cluster;
    }
    
    for(int j = 0; j < clusterN; j++){
      int cn = 0;
      float cx = 0;
      float cy = 0;
      
      for(int i = 0; i < sampleN; i++){
        if(cluster[i] == j){
          cx = cx + sample[i].x;
          cy = cy + sample[i].y;
          cn++;
        }
      }
      
      if(cn != 0){
        center[j].x = cx/cn;
        center[j].y = cy/cn;
      }
    }
  }
}

void keyPressed(){
  key_pressed_sign = true;
}