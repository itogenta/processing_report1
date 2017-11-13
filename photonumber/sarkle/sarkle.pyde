

int cvFindContours(
          CvArr* image,                        #入力画像(8Bitモノクロ)
          CvMemStorage* storage,        #抽出された輪郭を保存する領域
          CvSeq** first_contour,            # 一番最初の輪郭（ツリー構造を持つ）へのポインタ
          int header_size = sizeog(CvContour),  # シーケンスのヘッダサイズ
          int mode = CV_RETR_LIST,   # 抽出モード
          int method = CV_CHAIN_APPROX_SIMPLE,   # 近似手法
          CvPoint offset = cvPoint(0, 0)  # オフセット
          );
void DrawNextContour(       
                IplImage *img,    #ラベリング結果を描画するIplImage(8Bit3chカラー）
                CvSeq *Contour, #輪郭へのポインタ
                int Level            #輪郭のレベル（階層）
                ){

      #輪郭を描画する色の設定
      CvScalar ContoursColor;

      if ((Level % 2) == 1){
            #白の輪郭の場合、赤で輪郭を描画
            ContoursColor = CV_RGB( 255, 0, 0 );
      }else{
            #黒の輪郭の場合、青で輪郭を描画
            ContoursColor = CV_RGB( 0, 0, 255 );
      }
             
      #輪郭の描画
      cvDrawContours( img, Contour, ContoursColor, ContoursColor, 0, 2);

      #各種輪郭の特徴量の取得
      GetContourFeature(Contour);　#オリジナル関数です。（詳細は後述）

      if (Contour->h_next != NULL)
            #次の輪郭がある場合は次の輪郭を描画
            DrawNextContour(img, Contour->h_next, Level);

      if (Contour->v_next != NULL)
            #子の輪郭がある場合は子の輪郭を描画
            DrawChildContour(img, Contour->v_next, Level + 1);
}


#子の輪郭を描画する。

void DrawChildContour(       
                IplImage *img,    #ラベリング結果を描画するIplImage(8Bit3chカラー）
                CvSeq *Contour, #輪郭へのポインタ
                int Level             #輪郭のレベル（階層）
                ){
             
      #輪郭を描画する色の設定
      CvScalar ContoursColor;

      if ((Level % 2) == 1){
            #白の輪郭の場合、赤で輪郭を描画
            ContoursColor = CV_RGB( 255, 0, 0 );
      }else{
            #黒の輪郭の場合、青で輪郭を描画
            ContoursColor = CV_RGB( 0, 0, 255 );
      }
             
      #輪郭の描画
      cvDrawContours( img, Contour, ContoursColor, ContoursColor, 0, 2);
             
      #各種輪郭の特徴量の取得
      GetContourFeature(Contour); #オリジナル関数です。（詳細は後述）

      if (Contour->h_next != NULL)
            #次の輪郭がある場合は次の輪郭を描画
            DrawNextContour(img, Contour->h_next, Level);
      if (Contour->v_next != NULL)
            #子の輪郭がある場合は子の輪郭を描画
            DrawChildContour(img, Contour->v_next, Level + 1);
}
  

# # ラベリング処理

void cv_Labelling(                      
             IplImage *src_img,       #入力画像（8Bitモノクロ）
             IplImage *dst_img        #出力画像（8Bit3chカラー）
             ) {
             
      CvMemStorage *storage = cvCreateMemStorage (0);
      CvSeq *contours = NULL;
             
      if (src_img == NULL)   
            return; 
         
      #画像の二値化【判別分析法(大津の二値化)】
      cvThreshold (src_img, src_img, 0, 255, CV_THRESH_BINARY | CV_THRESH_OTSU);

      #輪郭の検出(戻り値は取得した輪郭の全個数)
      int find_contour_num = cvFindContours (
                     src_img,                     #入力画像
                     storage,                      # 抽出された輪郭を保存する領域
                     &contours,                  # 一番外側の輪郭へのポインタへのポインタ
                     sizeof (CvContour),      # シーケンスヘッダのサイズ
                      CV_RETR_TREE,       #抽出モード
                                                      # // CV_RETR_EXTERNAL - 最も外側の輪郭のみ抽出
                                                      # // CV_RETR_LIST - 全ての輪郭を抽出し，リストに追加
                                                      # // CV_RETR_CCOMP - 全ての輪郭を抽出し，
                                                      # // 二つのレベルを持つ階層構造を構成する．
                                                      # // 1番目のレベルは連結成分の外側の境界線，
                                                      # // 2番目のレベルは穴（連結成分の内側に存在する）の境界線．
                                                      # // CV_RETR_TREE - 全ての輪郭を抽出し，
                                                      # // 枝分かれした輪郭を完全に表現する階層構造を構成する．
                     CV_CHAIN_APPROX_NONE    # CV_CHA# IN_APPROX_SIMPLE:輪郭の折れ線の端点を取得
                                                      #              // CV_CHAIN_APPROX_NONE: 輪郭の全ての点を取得
                                                      #              // Teh-Chinチェーンの近似アルゴリズム中の一つを適用する 
                                                      #              // CV_CHAIN_APPROX_TC89_L1
                                                      #              // CV_CHAIN_APPROX_TC89_KCOS
                     );

      if (contours != NULL){
            #処理後画像を０（黒）で初期化
            cvSet(dst_img, CV_RGB( 0, 0, 0 ));
            #輪郭の描画
            DrawNextContour(dst_img, contours, 1);
      }

      #メモリストレージの解放
      cvReleaseMemStorage (&storage);
}
             
             #各種輪郭の特徴量の取得
void GetContourFeature(CvSeq *Contour){
         #面積
         double Area = fabs(cvContourArea(Contour, CV_WHOLE_SEQ));
         #周囲長
         double Perimeter = cvArcLength(Contour);
         #円形度
         double CircleLevel = 4.0 * CV_PI * Area / (Perimeter * Perimeter);

         #傾いていない外接四角形領域（フィレ径）
         CvRect rect = cvBoundingRect(Contour);
         #輪郭を構成する頂点座標を取得
         for ( int i = 0; i < Contour->total; i++){
                  CvPoint *point = CV_GET_SEQ_ELEM (CvPoint, Contour, i);
         }
}