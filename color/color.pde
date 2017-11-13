import gab.opencv.*;
import java.io.*;

final int WIDTH =640;//幅の設定
final int HEIGHT =480;//縦の設定
final int Number=45;//画像の枚数の設定

float r,g,b;
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
    loadPixels();
    //画像の縦横のピクセル値の読み取り
    for(int y=0; y<myPhotoHeight[i]; y++){
      for(int x=0; x<myPhotoWidth[i]; x++){
           int loc  = x+y*myPhotoWidth[i];
      
       r= red(Img[i].pixels[loc]);
       g= green(Img[i].pixels[loc]);
       b= blue(Img[i].pixels[loc]);
 
 //色の閾値の設定
         if(r>=135  && g<75 && b<75){
           redCount += 1;
         }else if(r<75 && b >= 135 && g<75 ){
           blueCount += 1;
         } else if (r<75 && b < 75 && g>=135 ){
           greenCount += 1;
         }
        }
      }
      updatePixels();
      
      //色の出力結果
      try{
      System.setOut(new PrintStream(new FileOutputStream("color.txt")));
      if(redCount>blueCount){
          System.out.println("this is red");
        }else if(blueCount>greenCount){
          System.out.println("this is blue");
        }else {
          System.out.println("this is green");
    }
      }catch(Exception e){
        e.printStackTrace();
      }
    
  }
  //処理結果をファイルへ出力
  
  
}