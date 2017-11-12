PImage[] img = new PImage[3];
PImage img1;
PImage[] imgcf = new PImage[3];

//Look Up Table
int[] Src = new int[255];
int[][] Dst = new int[2][10000];

float r,g,b;
int[] p = new int[5];//{topleft, top, topright, left, center}
int[][] la = new int[640][480];
int min = 10000;
int count=0;
int[][] Scount = new int[2][256];

void setup(){
  frameRate(30);
  img[0] = loadImage("pic01.jpg");
  img[1] = loadImage("pic02.jpg");
  img[2] = loadImage("pic03.jpg");
   size(1000, 800);
  img[0].loadPixels();
  img[1].loadPixels();
  img[2].loadPixels();
  loadPixels();
    
  imgcf[0] = createImage(img[0].width, img[0].height, RGB);
  imgcf[1] = createImage(img[1].width, img[1].height, RGB);
  
  for(int k = 0;k<2;k++){
    for (int x = 0; x < img[0].width; x++) {
      for (int y = 0; y < img[0].height; y++ ) {
        la[x][y]= 0;
      }
    }
    for(int i=0;i<255;i++){
      Dst[k][i] = i;
    }
  
    color c0,c1;
  
    for (int x = 0; x < img[k].width; x++) {
      for (int y = 0; y < img[k].height; y++ ) {
        int loc = x + y*img[k].width;

      
        r = red (img[k].pixels[loc]);
        g = green (img[k].pixels[loc]);
        b = blue (img[k].pixels[loc]);

       if(r < 15 && g < 15 && b <15){
          if(x-1<0 && y-1<0){
            p[0]=0;
            p[1]=0;
            p[2]=0;
            p[3]=0;
            p[4]=la[x][y];
          }
          else if(x+1==img[k].width){
            p[2]=0;
            p[3]=la[x-1][y];
            p[4]=la[x][y];
            if(y-1<0){
              p[0]=0;
              p[1]=0;
            }
            else{
              p[0]=la[x-1][y-1];
              p[1]=la[x][y-1];
            }
          }
          else if(y-1<0){
            p[0]=0;
            p[1]=0;
            p[2]=0;
            p[3]=la[x-1][y];
            p[4]=la[x][y];
          }
          else if(x-1<0){
            p[0]=0;
            p[1]=la[x][y-1];
            p[2]=la[x+1][y-1];
            p[3]=0;
            p[4]=la[x][y];
          }
          else{
            p[0]=la[x-1][y-1];
            p[1]=la[x][y-1];
            p[2]=la[x+1][y-1];
            p[3]=la[x-1][y];
            p[4]=la[x][y];
          }
          if(p[0] == 0 && p[1]==0 && p[2]==0 && p[3]==0){
            count = count+1;
            la[x][y] = count;
          }
          else{
            min = 30000;
            for(int i=0; i<5; i++){
              if(p[i]<min && p[i] != 0){
                min = p[i];
              }
            }
          for(int i=0; i<5; i++){
            if(p[i]!=min && p[i] != 0){
              Dst[k][p[i]] = min;
            }
          }
          la[x][y] = min;
          }
        }
      }  
    }
  
  
    for(int i=255;i>=0;i--){
      for (int x = 0; x < img[k].width; x++) {
        for (int y = 0; y < img[k].height; y++ ) {
          if(la[x][y] == i){
            la[x][y] = Dst[k][i];
          }
        }
      }
    
  }
  
  
    for(int i=255;i>=0;i--){
      for (int x = 0; x < img[k].width; x++) {
        for (int y = 0; y < img[k].height; y++ ) {
          if(la[x][y] == i){
            Scount[k][255-i] = Scount[k][255-i]+1;
          }
        }
      }
    }
  
    int c = 0;
    for(int i=255;i>=0;i--){
      
      if(Scount[k][i] > 30 ){
        println("pic["+k+"]-"+c+ "=" +Scount[k][i]);
        c =c+1;
      }
      
    }
  
    for(int i=255;i>=0;i--){
      for (int x = 0; x < img[k].width; x++) {
        for (int y = 0; y < img[k].height; y++ ) {
          int loc = x + y*img[k].width;
          if(la[x][y] == i){
            if(k==0){
              if(i==0){
                 c0 = color(255,255,255);
              }
              else{
                c0 = color(255,i,255-i*20);
              }
              imgcf[0].pixels[loc] = c0;
            }
            else{
              if(i==0){
                 c1 = color(255,255,255);
              }
              else if(i==91){
                c1 = color(0,255,255);
              }

              else if(i == 92){
                c1 = color(255,0,0);
              }
              else if(i==116){
                c1 = color(255,255,0);
              }
              else if(i==206){
                c1 = color(0,255,0);
              }
              else if(i==210){
                c1 = color(100,100,100);
              }
              else if(i==174){
               c1 = color(100,200,200);
              }
              else if(i==179){
               c1 = color(0,0,255);
              }
              else{
                 c1 = color(0,0,0);
              }
              imgcf[1].pixels[loc] = c1;
              imgcf[2].pixels[loc] =c1;
            }
          
        }
      }
     }
    }
  }
  imgcf[0].save("data/pic01.jpg");
  imgcf[1].save("data/pic02.jpg");
  imgcf[2].save("data/pic03.jpg");
}

void draw(){
  
  image(img[0], 0, 0, 320, 240);
  image(img[1], 0, 240, 320, 240);
  image(imgcf[0], 320, 0, 320, 240);
  image(imgcf[1], 320, 240, 320, 240);
  
}