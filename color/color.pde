//final int WIDTH =640;
//final int HEIGHT =480;
//final int Number=45;
//int loc;
PImage img;
float r,g,b;
//float r,g,b;
//PImage pic[];


/*void Color (){
  int ImageArray[]= new int[Number];
}*/


//displaysetting
//void settings(){
  
//  //size(WIDTH,HEIGHT);
//  //pic = new PImage[Number];
//  img = loadImage("pic01.jpg");
//}
void setup(){
 size(640,360);
 ////photoread
 //  for(int i = 0,j=1; i<Number; i++,j++){
 //   String str;
 //   if(i<9){
 //     str = "data/pic0" + j + ".jpg";
 //   } else{
 //      str = "data/pic" + j + ".jpg";
 //   }
 //   pic[i] = loadImage(str,"jpg");
 //  }
   img = loadImage("pic12.jpg");
  // image(img,img.width/2,img.height/2);
   getColor();
   
   
}

//photoup
void draw(){
     image(img,img.width/2,img.height/2);

  //for(int i = 0, x=0, y=0; i<Number; i++,x++){
  //    if(i!=0 && i % 7 ==0){
  //      y++;
  //      x=0;
  //    }
  //    image(pic[i],x*WIDTH/7,y*HEIGHT/7,WIDTH/7,HEIGHT/7);
  //  }
}
//colorread
void getColor(){

   loadPixels();
   
//  //for(int index = 0,img;)
  int redCount = 0;
  int blueCount = 0;
  int greenCount = 0;
  for(int y=0; y<img.height; y++){
     for(int x=0; x<img.width; x++){
        int loc  = x+y*img.width;
        
        
       
//      //color new_color = color(red(loc),255-green(loc),255-blue(loc));
//      //set(i,j);
      //pixels rgb
      r= red(img.pixels[loc]);
      g= green(img.pixels[loc]);
      b= blue(img.pixels[loc]);
      
      //if(r != 255 && g != 255 && b != 255){
      //  println(r,g,b);
      //}
        if(r>=130 && g<100 && b<100){
            redCount += 1;
           // println(redCount);
        
        }else if(r<100 && b >= 130 && g<100 ){
          blueCount += 1;
          //println(blueCount);
        } else if (r<100 && b < 100 && g>=130 ){
          greenCount += 1;
         // println(greenCount);
        }
       
//    }
//  }
    
     updatePixels();
  }
 }
 
        if(redCount>blueCount){
          println("this is red");
        }else if(blueCount>greenCount){
          println("this is blue");
        }else {
          println("this is green");
        }
}