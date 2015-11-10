//
//  CompareViewController.swift
//  SwipeTest
//
//  Created by Ayano Ohya on 2015/08/04.
//  Copyright (c) 2015年 Ayano Ohya. All rights reserved.
//

import UIKit
import Photos
import ImageIO

class CompareViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
        var photoAssets = [PHAsset]()
        
        var imageIndex: Int = 0
        var imageIndex2: Int = 0
    
    @IBOutlet weak var photoSetBtn: UIButton!
    
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var imageView2: UIImageView!
    
    

    
//    @IBAction func tapedPhotoBtn(sender: UIButton) {
//        
//        // フォトライブラリが使用可能か？
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
//            
//            // フォトライブラリの選択画面を表示
//            let picker = UIImagePickerController()
//            picker.delegate = self
//            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
//            self.presentViewController(picker, animated: true, completion: nil)
//        }
//        
//    }
//
//    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addSwipeRecognizer()
        
        self.getAllPhotosInfo()
        self.getAllPhotosInfo2()
        
        imageView.userInteractionEnabled = true
        imageView2.userInteractionEnabled = true
        


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addSwipeRecognizer() {
        var swipeLeft = UISwipeGestureRecognizer(target: self, action: "swipeleft")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "swiperight")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        
        var swipeLeft2 = UISwipeGestureRecognizer(target: self, action: "swipeleft2")
        swipeLeft2.direction = UISwipeGestureRecognizerDirection.Left
        
        var swipeRight2 = UISwipeGestureRecognizer(target: self, action: "swiperight2")
        swipeRight2.direction = UISwipeGestureRecognizerDirection.Right
        
        
        self.imageView.addGestureRecognizer(swipeLeft)
        self.imageView.addGestureRecognizer(swipeRight)
        self.imageView2.addGestureRecognizer(swipeLeft2)
        self.imageView2.addGestureRecognizer(swipeRight2)
    }
    func swipeleft(){
        NSLog("左にスワイプしました")
        imageIndex = imageIndex + 1
        self.getAllPhotosInfo()
        
    }
    func swiperight(){
        NSLog("右にスワイプしました")
        self.deleteFirstImage()
    }
    
    func swipeleft2(){
        NSLog("左にスワイプしました")
        imageIndex = imageIndex + 1
        self.getAllPhotosInfo2()
        
    }
    func swiperight2(){
        NSLog("右にスワイプしました")
        self.deleteFirstImage()
    }

    private func getAllPhotosInfo(){
        photoAssets = []
        
        //ソート条件を指定
        var options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        
        //画像を全て取得
        var assets: PHFetchResult = PHAsset.fetchAssetsWithMediaType(.Image, options: nil)
        assets.enumerateObjectsUsingBlock { (asset,index, stop) -> Void in
            self.photoAssets.append(asset as! PHAsset)
            
        }
        println(photoAssets)
        let manager: PHImageManager = PHImageManager()
        manager.requestImageForAsset(photoAssets[imageIndex],targetSize: CGSizeMake(100, 100), contentMode: .AspectFill , options: nil) { (image, info) -> Void in
            //取得したimageをUIImageViewなどで表示する
            self.imageView.image = image
        }
        
    }
    
    private func getAllPhotosInfo2(){
        photoAssets = []
        
        //ソート条件を指定
        var options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        
        //画像を全て取得
        var assets: PHFetchResult = PHAsset.fetchAssetsWithMediaType(.Image, options: nil)
        assets.enumerateObjectsUsingBlock { (asset,index, stop) -> Void in
            self.photoAssets.append(asset as! PHAsset)
            
        }
        println(photoAssets)
        let manager: PHImageManager = PHImageManager()
        manager.requestImageForAsset(photoAssets[imageIndex],targetSize: CGSizeMake(100, 100), contentMode: .AspectFill , options: nil) { (image, info) -> Void in
            //取得したimageをUIImageViewなどで表示する
            self.imageView2.image = image
        }
    }
    
    
    
    
    private func deleteFirstImage() {
        let delTargetAsset = photoAssets.first as PHAsset?
        if delTargetAsset != nil {
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({ () -> Void in
                // 削除などの変更はこのblocks内でリクエストする
               PHAssetChangeRequest.deleteAssets([delTargetAsset!])
                }, completionHandler: { (success, error) -> Void in
                    // 完了時の処理をここに記述
                    self.getAllPhotosInfo()
            })
        }
        
        
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
}

