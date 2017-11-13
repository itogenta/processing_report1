//kaku
import processing.pdf.*;

// for load file
String[] lines;
int line_index = 0;

int sampleN = 1000;
int clusterN = 3;//クラスタ数

PVector []sample = new PVector [sampleN];
int []cluster = new int [sampleN];//各点のクラスタ番号
int []prevCluster = new int [sampleN];


PVector []center = new PVector [clusterN];


boolean key_pressed_sign;


void setup() 
{
  size(800, 800, P2D);
  smooth();
  rectMode(CENTER);
  
  //load_data();
  // 座標の指定
  for(int i = 0; i < sampleN; i++)
    sample[i] = new PVector(random(100, width-100), 
                random(100, height-100));
  
  
  for(int i = 0; i < clusterN; i++)
    center[i] = new PVector(random(10, width-10), random(10, height-10));
  
  
  for(int i = 0; i < sampleN; i++)
  {
    cluster[i] = i % clusterN;// 0, 1, 2
    prevCluster[i] = -1;
  } 
  
  key_pressed_sign = false;
}


void draw() 
{
  background(0);

  if(key_pressed_sign == true)  {
     clustering();
    key_pressed_sign = false;
  }


  for(int i = 0; i < sampleN; i++)
  {
    //色の指定
    pushMatrix();
    if(cluster[i]==0)stroke(255,0,0);
    else if(cluster[i]==1)stroke(255,255,0);
    else if(cluster[i]==2)stroke(128,255,255);
    else if(cluster[i]==3)stroke(128,128,255);
    else if(cluster[i]==4)stroke(0,255,255);
    else if(cluster[i]==5)stroke(0,255,0);
    else if(cluster[i]==6)stroke(0,128,255);
    else if(cluster[i]==7)stroke(0,255,128);
    else if(cluster[i]==8)stroke(0,0,255);
    else if(cluster[i]==9)stroke(255,255,255);
  
    noFill();
    rect(sample[i].x, sample[i].y, 20, 20);
    popMatrix();
  }
  
  
  for(int i = 0; i < clusterN; i++)
  {
    //色の指定
    pushMatrix();    
    if(i==0)fill(255,0,0);
    else if(i==1)fill(255,255,0);
    else if(i==2)fill(128,255,255);
    else if(i==3)stroke(128,128,255);
    else if(i==4)stroke(0,255,255);
    else if(i==5)stroke(0,255,0);
    else if(i==6)stroke(0,128,255);
    else if(i==7)stroke(0,255,128);
    else if(i==8)stroke(0,0,255);
    else if(i==9)stroke(255,255,255);
 
    noStroke();
    ellipse(center[i].x, center[i].y, 30, 30);
    popMatrix();
  }
}


void clustering()
{
  boolean e = false;
  
  for(int i = 0; i < sampleN; i++)
  {
    if(prevCluster[i] != cluster[i])
     e = true;
  }
  
  
  if(e == true)
  {
    for(int i = 0; i < sampleN; i++)
      prevCluster[i] = cluster[i];


    for(int i = 0; i < sampleN; i++)
    {
      int max_cluster = -1;
      float max_value = width*height;
      
      //一番類似度の高いクラスタにする(距離が一番近い)
      for(int j = 0; j < clusterN; j++)
      {
        if(max_value > PVector.dist(sample[i], center[j]))
        {
          max_value = PVector.dist(sample[i], center[j]);
          max_cluster = j;
        }
      }
      cluster[i] =  max_cluster;
    }



    //代表ベクトルの再計算
    for(int j = 0; j < clusterN; j++)
    {
      int cn = 0;
      float cx = 0;
      float cy = 0;


      for(int i = 0; i < sampleN; i++)
      {
        if(cluster[i] == j)
        {
          cx = cx + sample[i].x;
          cy = cy + sample[i].y;
          cn++;
        }
      }
      
      
      if(cn != 0)
      {
        center[j].x = cx/cn;
        center[j].y = cy/cn;
      }
    }
  }
}



void keyPressed()
{
  key_pressed_sign = true;
}