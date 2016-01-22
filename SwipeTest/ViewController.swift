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
import Koloda
import pop

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,
KolodaViewDataSource,KolodaViewDelegate {
    
    //TODO: PHAssetを使うとdeleteをした時にアラートが出てしまうので別のクラスを使う
    var photoAssets: [PHAsset] = []
    var stackedAssets: [PHAsset] = []
    var imageIndex: Int = 0
    var photonumber: Int = 0
    var number: Int = 0
    let ud = NSUserDefaults.standardUserDefaults()
    

    
    @IBOutlet var myImageView: UIImageView!
    //@IBOurlet weak var photoSetButtonItem!
    @IBOutlet var kolodaView: KolodaView!
    @IBOutlet var NO_button: UIButton!
    @IBOutlet var YES_button: UIButton!
    @IBOutlet var revertButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet weak var photoSetBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deleteButton.enabled = false
        revertButton.enabled = false
        
        self.title = "Select a Image"
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        self.setUpButtons()
        self.getAllPhotosInfo()
        
        //initなどでNSNotification登録
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "update:", name: "dummy", object: nil)

        
    }
    
    //関数で受け取った時のアクションを定義
    func update(notification: NSNotification)  {
         if let userInfo = notification.userInfo {
             let result = userInfo["value"]! as! String
             print("受信した数値：\(result)")
            switch(result){
            case "rightAction":
                deleteButton.enabled = true
                revertButton.enabled = true
                photonumber = photonumber + 1
                break
            case "leftAction":
                revertButton.enabled = true
                photonumber = photonumber + 1
            
                break

            default :
                break
            }
            
            
        }
    }
    
    
    func setUpButtons() {
        NO_button.layer.cornerRadius = NO_button.bounds.width / 2.0
        YES_button.layer.cornerRadius = YES_button.bounds.width / 2.0
        revertButton.layer.cornerRadius = revertButton.bounds.width / 2.0
        deleteButton.layer.cornerRadius = deleteButton.bounds.width / 2.0
        NO_button.clipsToBounds = true
        YES_button.clipsToBounds = true
        revertButton.clipsToBounds = true
        deleteButton.clipsToBounds = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - kolodaViewDataSource
    func kolodaNumberOfCards(koloda: KolodaView) -> UInt {
        return UInt(self.photoAssets.count)
    }
    
    func kolodaViewForCardAtIndex(koloda: KolodaView, index: UInt) -> UIView {
        print(index)
        let imageView = UIImageView(image: self.getAssetThumbnail(self.photoAssets[Int(index)]))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.backgroundColor = UIColor.whiteColor()
        //imageView.setNeedsDisplay()
        return imageView
    }
    
    
    func kolodaViewForCardOverlayAtIndex(koloda: KolodaView, index: UInt) -> OverlayView? {
        return NSBundle.mainBundle().loadNibNamed("OverlayView", owner: self, options: nil)[0] as? OverlayView
    }
    
    //MARK: - KolodaViewDelegate
    func kolodaDidSwipedCardAtIndex(koloda: KolodaView, index: UInt, direction: SwipeResultDirection) {
        
        NSLog("%d番目のカードがスワイプされました", index)
        NSLog("カード == %@", koloda)
        
        if direction == SwipeResultDirection.Right {
            self.stackedAssets.append(self.photoAssets[Int(index)])
            
//            ud.setObject(stackedAssets, forKey: "stackedAssets")
            var data:NSData = NSData()
            data = NSKeyedArchiver.archivedDataWithRootObject(stackedAssets)
            NSUserDefaults.standardUserDefaults().setObject(data, forKey: "stackedAssets")
        }
        //NSLog("方向 == %@", direction.hashValue)
        ud.setInteger(Int(index + 1), forKey: "number")
        ud.synchronize()
        
        // TODO: 削除ボタンを押したときにちゃんとなるようにする
    }
    
    func kolodaDidRunOutOfCards(koloda: KolodaView) {
        //Example: reloading
        ud.setInteger(0, forKey: "number")
        kolodaView.resetCurrentCardNumber()
        getAllPhotosInfo()
        
    }
    
    func kolodaDidSelectCardAtIndex(koloda: KolodaView, index: UInt) {
        print("Tapped")
    }
    
    func kolodaWShouldApplyAppearAnimarion(koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaShouldMoveBackgroundCard(koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaBackgroundCardAnimation(koloda: KolodaView) -> POPPropertyAnimation? {
        return nil
    }
    
    private func getAllPhotosInfo(){
        photoAssets = []
        
        // TODO: 今古い順なので順番を変えられるように
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let assets: PHFetchResult = PHAsset.fetchAssetsWithMediaType(.Image, options: nil)
        assets.enumerateObjectsUsingBlock { (asset, index, stop) -> Void in
            self.photoAssets.append(asset as! PHAsset)
        }
        
        number = ud.integerForKey("number")
        
        print(self.photoAssets.count)
        /*
        for var i = 0; i < number; i++ {
            self.stackedAssets.append(self.photoAssets[i])
        }
*/
        //前回行った作業の続きからできるようにした
        for var j = 0; j < number; j++ {
            self.photoAssets.removeFirst()
        }
        
        //上のfor文のnumberの値がカメラロールで指定した画像になるようにしなくちゃいけない
        //上の2つのうち上の方のfor文は必要なのかきく。stackedAssetsに入れるのは削除するやつだけじゃないのか、別に削除しないでとばすだけだから→解決
        
        // print(photoAssets)
        let manager: PHImageManager = PHImageManager()
        manager.requestImageForAsset(photoAssets[imageIndex],targetSize: CGSizeMake(500, 500), contentMode: .AspectFit , options: nil) { (image, info) -> Void in
            //取得したimageをUIImageViewなどで表示する
            //self.myImageView!.image = self.getAssetThumbnail(self.photoAssets[self.imageIndex])
        }
        
        if stackedAssets.count > 0 {
            deleteButton.enabled = true
        }
    }
    
    @IBAction func tapedPhotoBtn() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            // フォトライブラリの画像・写真選択画面を表示
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .PhotoLibrary
            imagePickerController.allowsEditing = false
            imagePickerController.delegate = self
            presentViewController(imagePickerController, animated: true, completion: nil)
        }
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print(self.photoAssets[0])
        
        print("=======================")
        print(info)
        
    }
    /*
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, info: [String : AnyObject]?) {
        
        print(info)
        
        if info![UIImagePickerControllerOriginalImage] != nil {
            let image: UIImage = info![UIImagePickerControllerOriginalImage] as! UIImage
            
            
            
            /*
            for asset in self.photoAssets {
            if asset == info
            }
            */
            
        }
        print(info)
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
*/
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - Private
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.defaultManager()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.synchronous = true
        manager.requestImageForAsset(asset, targetSize: CGSize(width: 560.0, height: 560.0), contentMode: .AspectFit, options: option, resultHandler: {(result, info)->Void in thumbnail = result!
        })
        return thumbnail
    }
    
    @IBAction func tapYES() {
        kolodaView?.swipe(SwipeResultDirection.Right)
        deleteButton.enabled = true
        revertButton.enabled = true

    }
    
    @IBAction func tapNO() {
        kolodaView?.swipe(SwipeResultDirection.Left)
        revertButton.enabled = true
        
    }
    
    @IBAction func tapRevert() {
        kolodaView?.revertAction()
        self.stackedAssets.removeLast()
        
    }
    
    @IBAction func deleteStackedImages() {
        
        // print(self.stackedAssets)
        let  data: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("stackedAssets")
        stackedAssets =  NSKeyedUnarchiver.unarchiveObjectWithData(data as! NSData) as! [PHAsset]
//        stackedAssets = ud.arrayForKey("stackedAssets") as! [PHAsset]
      
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({ () -> Void in
            PHAssetChangeRequest.deleteAssets(self.stackedAssets)
            }, completionHandler: { ( success, error) -> Void in
                
                print("削除完了")
                if error != nil {
                    print(error)
                }else {
                    self.kolodaView?.reloadData()
                    self.ud.setInteger(0, forKey: "number")
                    self.ud.synchronize()
                }
                //self.getAllPhotoInfo()
                
        })
        
        deleteButton.enabled = false
    }
    
    @IBAction func backToTop(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
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
    */
    
}
