//Skecth image OUTPUT

final int WIDTH =640;
final int HEIGHT =480;
final int Number=45;
PImage pic[];

void settings(){
  size(WIDTH,HEIGHT);
  
  pic = new PImage[Number];
}

void setup(){
  //photo load
  
  for(int i = 0,j=1; i<Number; i++,j++){
    String str;
    if(i<9){
      str = "data/pic0" + j + ".jpg";
    } else{
       str = "data/pic" + j + ".jpg";
    }
    pic[i] = loadImage(str,"jpg");
    
  }
    
    //photoup
    for(int i = 0, x=0, y=0; i<Number; i++,x++){
      if(i!=0 && i % 7 ==0){
        y++;
        x=0;
      }
      image(pic[i],x*WIDTH/7,y*HEIGHT/7,WIDTH/7,HEIGHT/7);
    }
  }


void draw(){
}