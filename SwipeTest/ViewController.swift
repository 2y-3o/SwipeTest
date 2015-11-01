//
//  ViewController.swift
//  SwipeTest
//
//  Created by Ayano Ohya on 2015/08/02.
//  Copyright (c) 2015年 Ayano Ohya. All rights reserved.
//

import UIKit
import Photos
import ImageIO

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    var photoAssets = [PHAsset]()
    
    var imageIndex: Int = 0
    
    var myImagePicker: UIImagePickerController!
    @IBOutlet var myImageView: UIImageView!
    
    
    
    @IBOutlet weak var photoSetBtn: UIButton!
    
    func addSwipeRecognizer() {
        var swipeLeft = UISwipeGestureRecognizer(target: self, action: "swipeleft")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "swiperight")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        
        var swipeUp = UISwipeGestureRecognizer(target: self, action: "swipeup")
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        
        var swipeDown = UISwipeGestureRecognizer(target: self, action: "swipedown")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        
        self.myImageView.addGestureRecognizer(swipeLeft)
        self.myImageView.addGestureRecognizer(swipeRight)
        self.myImageView.addGestureRecognizer(swipeUp)
        self.myImageView.addGestureRecognizer(swipeDown)
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
    func swipeup(){
        NSLog("上にスワイプしました")
        
    }
    func swipedown(){
        
        NSLog("下にスワイプしました")
        
    }
    
    private func getAllPhotosInfo(){
        photoAssets = []
        
        var options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        
        //画像を全て取得
        var assets: PHFetchResult = PHAsset.fetchAssetsWithMediaType(.Image, options: nil)
        assets.enumerateObjectsUsingBlock { (asset,index, stop) -> Void in
            self.photoAssets.append(asset as! PHAsset)
            
        }
        println(photoAssets)
        let manager: PHImageManager = PHImageManager()
        manager.requestImageForAsset(photoAssets[imageIndex],targetSize: CGSizeMake(10, 10), contentMode: .AspectFit , options: nil) { (image, info) -> Void in
            
            //取得したimageをUIImageViewなどで表示する
            self.myImageView!.image = image
            
        }
        
        
        
    }
    
    @IBAction func tapedPhotoBtn(sender: UIButton) {
        
        // フォトライブラリが使用可能か？
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            
            // フォトライブラリの選択画面を表示
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(picker, animated: true, completion: nil)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Select a Image"
        
        myImageView = UIImageView(frame: self.view.bounds)
        
        // インスタンス生成
        myImagePicker = UIImagePickerController()
        
        // デリゲート設定
        myImagePicker.delegate = self
        
        // 画像の取得先はフォトライブラリ
        myImagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        // 画像取得後の編集を不可に
        myImagePicker.allowsEditing = false
        
        self.addSwipeRecognizer()
        
        self.getAllPhotosInfo()
        
        myImageView.userInteractionEnabled = true
    }
    
//    override func viewDidAppear(animated: Bool) {
//        self.presentViewController(myImagePicker, animated: true, completion: nil)
//        
//    }
//    
    /**
    画像が選択された時に呼ばれる.
    */
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        //選択された画像を取得.
        var myImage: AnyObject?  = info[UIImagePickerControllerOriginalImage]
        
        //選択された画像を表示するViewControllerを生成.
        let secondViewController = SecondViewController()
        
        //選択された画像を表示するViewContorllerにセットする.
        secondViewController.mySelectedImage = myImage as! UIImage
        
        myImagePicker.pushViewController(secondViewController, animated: true)
        
    }    /**
    画像選択がキャンセルされた時に呼ばれる.
    */
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        // モーダルビューを閉じる
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    


    
//    var imeage: UIImage = UIImage()
//    
//    var dataArray: [NSDate]=[]
//    
//    var photoArray:[NSData]=[]
//    var photoNumber = 0
    
//    private func getAllPhotosInfo(){
//        photoAssets = []
//        
//        var options = PHFetchOptions()
//        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
//        
//        
//        //画像を全て取得
//        var assets: PHFetchResult = PHAsset.fetchAssetsWithMediaType(.Image, options: nil)
//        assets.enumerateObjectsUsingBlock { (asset,index, stop) -> Void in
//            self.photoAssets.append(asset as! PHAsset)
//            
//        }
//        println(photoAssets)
//        let manager: PHImageManager = PHImageManager()
//        manager.requestImageForAsset(photoAssets[imageIndex],targetSize: CGSizeMake(10, 10), contentMode: .AspectFit , options: nil) { (image, info) -> Void in
//            
//            //取得したimageをUIImageViewなどで表示する
//            self.imageView!.image = image
//           
//        }
//        
//        
//        
//    }
//    
//    
    
//    
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
    
//    @IBAction func datePicker(sender: UITextField) {
//        let datePickerView  : UIDatePicker = UIDatePicker()
//        datePickerView.datePickerMode = UIDatePickerMode.Date
//        sender.inputView = datePickerView
//        datePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
//    }
//    
//    func handleDatePicker(sender: UIDatePicker) {
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "yyyy MM dd"
//        
//        
//    }
//    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        
//        return true
//    }
//    
//    func selectBackground() {
//        let imagePickerController: UIImagePickerController = UIImagePickerController()
//        
//        imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
//        imagePickerController.delegate = self
//        imagePickerController.allowsEditing = true
//        
//        self.presentViewController(imagePickerController, animated: true, completion: nil)
//    }
//    
//    func ImagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        
//        image = info[UIImagePickerControllerEditedImage] as! UIImage
//        
//        imageView!.Image = image
//        
//        picker.dismissViewControllerAnimated(true, completion: nil)
//        
//    }
    
    
    
    
    
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//
        // Do any additional setup after loading the view, typically from a nib.
        
//        self.addSwipeRecognizer()
//        
//        self.getAllPhotosInfo()
//        
//    }
    
    //
    // --- photoSelectButton Delegate ---
    //
    
//     func photoSelectButtonTouchDown(sender: AnyObject) {
        
//        
//   func photoSelectButtonTouchDown(sender: AnyObject) {
//        
//        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
//            UIAlertView(title: "警告", message: "Photoライブラリにアクセス出来ません", delegate: nil, cancelButtonTitle: "OK").show()
//        } else {
//            var imagePickerController = UIImagePickerController()
//            
//            // フォトライブラリから選択
//            imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
//            
//            // 編集OFFに設定
//            // これをtrueにすると写真選択時、写真編集画面に移る
//            imagePickerController.allowsEditing = false
//            
//            // デリゲート設定
//            imagePickerController.delegate = self
//            
//            // 選択画面起動
//            self.presentViewController(imagePickerController,animated:true ,completion:nil)
//            
////            // フォトライブラリの選択画面を表示
//            let picker = UIImagePickerController()
//            picker.delegate = self
//            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
//            self.presentViewController(picker, animated: true, completion: nil)
//
//        }
//        
//        
//    }
//    
//    //
//    // --- UIImagePickerDelegate ---
//    //
//    
//    // 写真選択時に呼ばれる
//    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: NSDictionary!) {
//        
//        // イメージ表示
//        var image = info[UIImagePickerControllerOriginalImage] as! UIImage
//        imageView.image = image
//        
//        // 選択画面閉じる
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
//}
//    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
//        extension UIImageExtension {
//            
//            func resize(size: CGSize) -> UIImage {
//                let widthRatio = size.width / self.size.width
//                let heightRatio = size.height / self.size.height
//                let ratio = (widthRatio < heightRatio) ? widthRatio : heightRatio
//                let resizedSize = CGSize(width: (self.size.width * ratio), height: (self.size.height * ratio))
//                UIGraphicsBeginImageContext(resizedSize)
//                drawInRect(CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
//                let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
//                UIGraphicsEndImageContext()
//                return resizedImage
//            }
//            
//            // 比率だけ指定する場合
//            func resize(#ratio: CGFloat) -> UIImage {
//                let resizedSize = CGSize(width: Int(self.size.width * ratio), height: Int(self.size.height * ratio))
//                UIGraphicsBeginImageContext(resizedSize)
//                drawInRect(CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
//                let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
//                UIGraphicsEndImageContext()
//                return resizedImage
//            }
//        }
   }
    
    
}
