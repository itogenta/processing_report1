import gab.opencv.*;
OpenCV cv;

PrintWriter output;

final int WIDTH = 640;
final int HEIGHT = 480;
final int picsNumber = 45;

PImage[] pics = new PImage[picsNumber];
PImage[] picsbin = new PImage[picsNumber];

int[] picarea = new int[picsNumber];
int[] picsgreen = new int[picsNumber];

//画面の設定
void settings(){

  size(WIDTH,HEIGHT);

}


void setup(){
  output = createWriter("area.txt"); 
  
  //画像の読み込み
  for(int i = 0, j = 1; i < picsNumber; i++, j++){
    String str;
    if(i < 9){
      str = "pic0" + j + ".jpg";
    }
    else{
      str = "pic" + j + ".jpg";
    }
    pics[i] = loadImage(str);
    pics[i].loadPixels();
    image(pics[0], 0, 0, WIDTH/2, HEIGHT/2);
    
    //二値化
    cv = new OpenCV(this, pics[i]);
    cv.gray();
    cv.threshold(160); 
    picsbin[i] = cv.getOutput();
    
    //面積
    int sum = 0;
    for (int y = 0; y < picsbin[i].height; y++) {
      for (int x = 0; x < picsbin[i].width; x++) {
        if (picsbin[i].pixels[x + y*picsbin[i].width] == color(0)) {
          sum++;
        }
      }
    }
    picarea[i] = sum;
    println("picarea[" + i + "] = " + picarea[i]);
    
    output.print("picarea[" + i + "] = " + picarea[i]);
    output.println("");
    
    //色情報の取得(緑の平均)
    int count = 1;
    int green = 0;
    int green_sum = 0;
    for(int w = 0; w < pics[i].width; w++){
      for(int h = 0; h < pics[i].height; h++){
        color c = pics[i].get(h, w);
        int r = (int)red(c);
        int g = (int)green(c);
        int b = (int)blue(c);
        
        if(r != 255 && g != 255 && b != 255){
          green = green + r;
          count++;
        }
        green_sum = green / count;
      }
    }
    picsgreen[i] = green_sum;
    println("picsgreen[" + i + "] = " + picsgreen[i]);
    output.print("picsgreen[" + i + "] = " + picsgreen[i]);
    output.println("");
  }
  output.flush();
  output.close();
}

void draw(){
  //画像表示
  for(int i = 0, x = 0, y = 0; i < picsNumber; i++, x++){
    if(i != 0 && i % 7 == 0){
      y++;
      x = 0;
    }
    image(pics[i], x * WIDTH / 7, y * HEIGHT / 7, WIDTH / 7, HEIGHT / 7);
  }
}