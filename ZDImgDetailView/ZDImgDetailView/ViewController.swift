//
//  ViewController.swift
//  ZDImgDetailView
//
//  Created by william on 16/5/6.
//  Copyright © 2016年 william. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let pic  = ZDImgDetail(imageName:"pic.jpg", frame: view.bounds);
        pic.singleBlock = {
            if  self.view.backgroundColor == UIColor.redColor() {
                self.view.backgroundColor = UIColor.blueColor();
            }else{
                 self.view.backgroundColor = UIColor.redColor();
            }
           
        }
        view .addSubview(pic);
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

