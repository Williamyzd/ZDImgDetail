//
//  ZDImgDetail.swift
//  swiftTest
//
//  Created by william on 16/5/5.
//  Copyright © 2016年 william. All rights reserved.
//

import UIKit

class ZDImgDetail: UIView,UIGestureRecognizerDelegate {
    class ZDimageView: UIImageView {
        var zoomScale:CGFloat = 1;
        
    }
    var singleBlock:(() -> ())!
    var imgView:ZDimageView!
    override init(frame: CGRect) {
        super.init(frame: frame);
                imgView = ZDimageView(frame: bounds);
                     addGuestures(imgView);
                     addSubview(imgView);

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    convenience init(imageName:String, frame:CGRect){
        self.init(frame:frame);
        if let img = UIImage(named: imageName) {
            imgView.image = img;
            let asize  = resetImgSize(img.size)
            imgView.frame = CGRect(x: 0,y: 0,width: asize.width,height: asize.height);
            imgView.center = center;
        }
    }
    
    
    func addGuestures(aView:UIImageView) {
        //单击
        aView.userInteractionEnabled = true ;
        let asingleTap = UITapGestureRecognizer(target: self, action:#selector(ZDImgDetail.singleTap(_:)));
        asingleTap.numberOfTapsRequired = 1;
        asingleTap.numberOfTouchesRequired = 1;
         asingleTap.delegate = self;
        aView.addGestureRecognizer(asingleTap);
        
        //双击
        let doubleTap  = UITapGestureRecognizer(target: self, action: #selector(ZDImgDetail.zoomTap(_:)))
        doubleTap.numberOfTapsRequired = 2;
       // doubleTap.numberOfTouchesRequired = 2;
        aView.addGestureRecognizer(doubleTap);
        
        //长按
        
        let longPress = UILongPressGestureRecognizer(target: self,action: #selector(longPress(_:)))
        aView.addGestureRecognizer(longPress);
        asingleTap.requireGestureRecognizerToFail(longPress);
        asingleTap.requireGestureRecognizerToFail(doubleTap);
        
        let pan = UIPinchGestureRecognizer(target: self,action:#selector(ZDImgDetail.pinchRecongnize(_:)) )
        
        aView.addGestureRecognizer(pan);
        
    }
    
    func pinchRecongnize(sender:UIPinchGestureRecognizer)  {
        
        switch sender.state  {
        case .Ended:
            print("手势结束")
            if sender.scale > 2.0 {
                imgView.zoomScale = 2.0
            }else if sender.scale < 0.5{
                imgView.zoomScale = 0.5
            }else{
                imgView.zoomScale = sender.scale;
            }
            UIView.animateWithDuration(0.3, animations: {
                self.imgView.transform = CGAffineTransformMakeScale(self.imgView.zoomScale, self.imgView.zoomScale);
            })
        default:
            print("默认情况")
            print("捏合手势开始")
            if sender.scale != 0 {
                imgView.zoomScale = sender.scale;
            }
            UIView.animateWithDuration(0.3, animations: {
                self.imgView.transform = CGAffineTransformMakeScale(self.imgView.zoomScale, self.imgView.zoomScale);
            })

        }
        
        
    }
    func singleTap(sender:UITapGestureRecognizer)  {
        
        if singleBlock != nil {
            singleBlock();
        }else{
            print("没有为闭包赋值") ;
        }
        
        print("单击了");
        
    }
    func zoomTap(sender:UITapGestureRecognizer) {
        
        print("双击啦")
        if imgView.zoomScale != 1 {
          
            imgView.zoomScale = 1;
            UIView.animateWithDuration(0.3, animations: {
               // self.zoomScale = 1 ;
                self.imgView.transform = CGAffineTransformMakeScale(self.imgView.zoomScale, self.imgView.zoomScale);
            })
            
            
        }else{
            imgView.zoomScale = 2;
            UIView.animateWithDuration(0.3, animations: {
                 self.imgView.transform = CGAffineTransformMakeScale(self.imgView.zoomScale, self.imgView.zoomScale);
            })
           
        }
        
        
    }
    func longPress(sender:UILongPressGestureRecognizer)  {
        print("长按啦")
        if sender.state == UIGestureRecognizerState.Began {
            UIImageWriteToSavedPhotosAlbum(imgView.image!, self, #selector(ZDImgDetail.image(_:didFinishSavingWithError:contextInfo:)), nil);
            
        }
        
    }
    
    func image(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject) {
        if didFinishSavingWithError != nil {
             print("保存失败")
        }else{
              print("保存成功")
        }
    }
    
    /*!
     修正图片尺寸
     
     - parameter size: 输入的图片尺寸
     
     - returns: 输出的图片尺寸
     */
    func resetImgSize(size:CGSize) -> CGSize {
        if(size.width == 0 || size.height == 0){
            return CGSizeZero;
        }
        
        
        let xscale = size.width/self.bounds.size.width;
        let yscale = size.height/self.bounds.size.height;
        var rsize:CGSize;
        if(xscale > yscale){
            rsize = CGSizeMake(self.bounds.size.width, size.height / xscale);
        }else{
            rsize = CGSizeMake(size.width / yscale, self.bounds.size.height);
        }
        return rsize;
    
    }
    
}

