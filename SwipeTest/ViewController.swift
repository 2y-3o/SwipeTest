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
    
    //TODO: PHAssetを使うとdeleteをした時にアラートが出てしまうので別のクラスを使う
    var photoAssets = [PHAsset]()
    
    // 削除する写真を入れるための配列
    var deletePhotoAssets = [PHAsset]()
    
    var imageIndex: Int = 0
    
    var myImagePicker: UIImagePickerController!
    @IBOutlet var myImageView: UIImageView!
    
     @IBOutlet weak var photoSetBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Select a Image"
        
        //        myImageView = UIImageView(frame: self.view.bounds)
        
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
        self.myImageView!.image = getAssetThumbnail(photoAssets[imageIndex])
        //self.getAllPhotosInfo()
        
        
    }
    func swiperight(){
        NSLog("右にスワイプしました")
        // self.deleteFirstImage()
        self.addDeletePhotos()
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
        
        //写真の順番
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        
        //画像を全て取得(false古い順、true新しい順)
        // TODO: falseとtrueを変えても、写真の降順が変わらないのでなおす
        var assets: PHFetchResult = PHAsset.fetchAssetsWithMediaType(.Image, options: nil)
        assets.enumerateObjectsUsingBlock { (asset,index, stop) -> Void in
            self.photoAssets.append(asset as! PHAsset)
        }
        
        println(photoAssets)
        let manager: PHImageManager = PHImageManager()
        manager.requestImageForAsset(photoAssets[imageIndex],targetSize: CGSizeMake(10, 10), contentMode: .AspectFit , options: nil) { (image, info) -> Void in
            //取得したimageをUIImageViewなどで表示する
            self.myImageView!.image = self.getAssetThumbnail(self.photoAssets[self.imageIndex])
        }
    }
    
    
    //アルバム表示
    @IBAction func tapedPhotoBtn() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            // フォトライブラリの画像・写真選択画面を表示
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .PhotoLibrary
            imagePickerController.allowsEditing = true
            imagePickerController.delegate = self
            presentViewController(imagePickerController, animated: true, completion: nil)
        }
    }
    
    //アルバムの画像が選択された時によばれる
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        //もし選択された画像が空じゃなかったら
        if info[UIImagePickerControllerOriginalImage] != nil {
            let image:UIImage = info[UIImagePickerControllerOriginalImage]  as! UIImage
            myImageView.image = image
            
            
        }
        //allowsEditingがtrueの場合 UIImagePickerControllerEditedImage
        //閉じる処理
        picker.dismissViewControllerAnimated(true, completion: nil);
    }
    

    // 画像選択がキャンセルされた時に呼ばれる.
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        // モーダルビューを閉じる
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    
    @IBAction func deleteImages() {
        
        // TODO: - 選んだ写真が入っているdeletePhotoAssets配列を一括で削除するコードに変える
        let delTargetAsset = photoAssets.first as PHAsset?
        if delTargetAsset != nil {
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({ () -> Void in
                // 削除などの変更はこのblocks内でリクエストする
                PHAssetChangeRequest.deleteAssets(self.deletePhotoAssets)
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

    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.defaultManager()
        var option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.synchronous = true
        manager.requestImageForAsset(asset, targetSize: CGSize(width: 100.0, height: 100.0), contentMode: .AspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result
        })
        return thumbnail
    }
    
    func addDeletePhotos() {
        // 今一番配列の上にある写真アセットを取得
        let delTargetAsset = photoAssets.first as PHAsset?
        deletePhotoAssets.append(delTargetAsset!)
    }
    
    
    
}
