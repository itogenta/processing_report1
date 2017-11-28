# -*- coding: utf-8 -*-
import cv2
#Ipythonで表示用の設定
import matplotlib.pyplot as plt
import math
import sys
#画像読込
in_img1 = cv2.imread("./sikaku.jpg",1) #処理用
in_img2 = cv2.imread("./sikaku.jpg",1) #表示用
if in_img1 is None or in_img2 is None:
    print "error"
    sys.exit()
#グレイ画像へ変換
gray_img   = cv2.cvtColor(in_img1, cv2.COLOR_BGR2GRAY)

#２値化
ret,thresh = cv2.threshold(gray_img,127,255,0)
#輪郭抽出
image, contours, hierarchy = cv2.findContours(thresh,cv2.RETR_TREE,cv2.CHAIN_APPROX_SIMPLE)
#ID:5の輪郭をオーバレイ


#ID:5のオブジェクトのモーメント算出

in_img2 = cv2.drawContours(in_img2, contours, 1, (0,255,0), 3)
cnt = contours[1]
M   = cv2.moments(cnt)

#ID:5のオブジェクトの面積
area = cv2.contourArea(cnt)

#ID:5のオブジェクトの重心
#cx = int(M['m10']/M['m00'])
#cy = int(M['m01']/M['m00'])
 

#ID:5のオブジェクトのペリメータ（周囲長）
perimeter = cv2.arcLength(cnt,True)


#OpenCVがBGRなのでRGBに変換
disp_out_img = cv2.cvtColor(in_img2, cv2.COLOR_BGR2RGB)
#画像表示
plt.figure(figsize=(6,6))
plt.imshow(disp_out_img)



#print "pic01" ,"\n"
print "面積：", area, "\n" #モーメントM['m00']も面積
#print "重心(Xg,Yg）：", cx, cy, "\n" 
#print "ペリメータ：", perimeter, "\n"
print "円形度:", 4 * math.pi * area / pow(perimeter,2)
print "\n"  
