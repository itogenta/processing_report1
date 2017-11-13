import gab.opencv.*;
import java.io.*;

PrintWriter output;

final int WIDTH =640;//幅の設定
final int HEIGHT =480;//縦の設定
final int Number=45;//画像の枚数の設定

float r,g,b,h,s;
PImage Img[] = new PImage[45];
int[] ImgNum = new int[45];
int[] myPhotoWidth = new int[45];
int[] myPhotoHeight = new int[45];
PImage Imagepics[] = new PImage[45];

//画面の設定
void settings(){
  
size(WIDTH,HEIGHT);
Imagepics = new PImage[Number];
}
void setup(){
  output =createWriter("color.txt");
  for(int i = 0,j=1; i<Number; i++,j++){
    String str = setImageName(i, j);
   
    Img[i] = loadImage(str);
    myPhotoWidth[i] = Img[i].width; //画像サイズ（幅）を取得
    myPhotoHeight[i] = Img[i].height; //画像サイズ（高さ）を取得
    ImgNum[i] = i;
    
    Imagepics[i] = loadImage(str); 
  }
    
    //画像を７＊７で出力するためのもの
    for(int i = 0, x=0, y=0; i<Number; i++,x++){
      if(i!=0 && i % 7 ==0){
        y++;
        x=0;
      }
      image(Imagepics[i],x*WIDTH/7,y*HEIGHT/7,WIDTH/7,HEIGHT/7);
  }
  getColor();
}
  //画像の出力
String setImageName(int i, int j){
  String str;
  //pic01.jpg~pic09.jpg
   if(i<9){
      str = "data/pic0" +str(j) + ".jpg";
   //pic10.jpg~pic45.jpg
    } else{
       str = "data/pic" + str(j) + ".jpg";
    }
  return str;
}

//出力
void draw(){
}

//色を抽出する関数
void getColor(){
  //赤、青、緑のカウント
  int redCount = 0;
  int blueCount = 0;
  int greenCount = 0;

  for(int i=0; i<Number; i++){
    output.println("pic"+str(i+1));
    loadPixels();
    //画像の縦横のピクセル値の読み取り
    for(int y=0; y<myPhotoHeight[i]; y++){
      for(int x=0; x<myPhotoWidth[i]; x++){
           int loc  = x+y*myPhotoWidth[i];
      
       h= hue(Img[i].pixels[loc]);
       s= saturation(Img[i].pixels[loc]);
       b= brightness(Img[i].pixels[loc]);
  
 //色の閾値の設定
   
    if(s!=0){
    if(h !=0){
         if(h>0 && h<60){
           redCount += 1;
         }else if(h>=60 && h<130 ){
           greenCount +=1;
         } else {
           blueCount += 1;
         }
        }
      }
      }
      
      }
      updatePixels();
      
      //色の出力結果
       //処理結果をファイルへ出力
      if(redCount>blueCount  && redCount>greenCount ){
          System.out.println("This is RED");
          output.print("This is RED");
        }else if(blueCount>greenCount && blueCount>redCount ){
          System.out.println("This is BLUE");
          output.print("This is BLUE");
        }else {
          System.out.println("This is GREEN");
           output.print("This is GREEN");
    }
   
    output.println("");
  }
  output.flush();
  output.close();
  
}