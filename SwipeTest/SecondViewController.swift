//
//  SecondViewController.swift
//  SwipeTest
//
//  Created by Ayano Ohya on 2015/10/11.
//  Copyright (c) 2015年 Ayano Ohya. All rights reserved.
//

import Foundation
import UIKit

class SecondViewController: UIViewController {
    
    var mySelectedImage: UIImage!
    var mySelectedImageView: UIImageView!
    
    override func viewDidLoad() {
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.view.backgroundColor = UIColor.whiteColor()
        
        setImage()
    }
    
    /**
    選択された画像をUIImageViewにセットする.
    */
    func setImage(){
        self.title = "Selected Image"
        
        mySelectedImageView = UIImageView(frame: self.view.bounds)
        mySelectedImageView.contentMode = UIViewContentMode.ScaleAspectFit
        mySelectedImageView.image = mySelectedImage
        self.view.addSubview(mySelectedImageView)
    }
    
}