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
    var photoAssets = [PHAsset]()
    var stackedAssets = [PHAsset]()
    var imageIndex: Int = 0
    
    
    @IBOutlet var myImageView: UIImageView!
    //@IBOurlet weak var photoSetButtonItem!

    @IBOutlet var kolodaView: KolodaView!
    @IBOutlet var NO_button: UIButton!
    @IBOutlet var YES_button: UIButton!
    @IBOutlet var revertButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet weak var photoSetBtn: UIBarButtonItem!
    @IBOutlet weak var helpBtn: UIBarButtonItem!
    @IBOutlet var deleteImageView: UIImageView!
    
    @IBOutlet var stackedNumberLabel: UILabel!
    
    @IBOutlet var saveview: UIImageView!
    @IBOutlet var dumpview: UIImageView!
    
//    @IBOutlet var titleImageView: UIImageView!
    @IBOutlet var helpImageView: UIImageView!
    
    
    //名前変える
    let label: UILabel  = UILabel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Photton"
        
        self.navigationItem.titleView = UIImageView(image:UIImage(named:"photton3.png"))
        
        
//        self.navigationController?.navigationBar.barTintColor = UIColor(red: 229/255,green: 229/255,blue: 229/255, alpha:1)

        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        self.setUpButtons()
        self.getAllPhotosInfo()
        
        
    }


    
    func setUpButtons() {
        
//        NO_button.layer.cornerRadius = NO_button.bounds.width / 2.0
//        YES_button.layer.cornerRadius = YES_button.bounds.width / 2.0
        revertButton.layer.cornerRadius = revertButton.bounds.width / 2.0
        deleteButton.layer.cornerRadius = deleteButton.bounds.width / 2.0
        NO_button.clipsToBounds = true
        YES_button.clipsToBounds = true
        revertButton.clipsToBounds = true
        deleteButton.clipsToBounds = true
    }
    
    
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        // 画面が消えた時に現在表示しているViewの情報を保存
        let asset = self.photoAssets[kolodaView.currentCardNumber]
        let filename = asset.valueForKey("filename") as? String
        NSUserDefaults.standardUserDefaults().setObject(filename, forKey: "lastCardName")
        NSUserDefaults.standardUserDefaults().synchronize()
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
        print("-----------")
        print(index)
        
        
        let imageView = UIImageView(image: self.getAssetThumbnail(self.photoAssets[Int(index)]))
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.whiteColor()
        //imageView.setNeedsDisplay()
        
//        imageView.layer.borderColor = UIColor(red: 27/255, green: 20/255, blue: 100/255, alpha: 1).CGColor
        imageView.layer.borderColor = UIColor.whiteColor().CGColor
        imageView.layer.borderWidth = 3
        imageView.layer.cornerRadius = 25
        
        return imageView
        
        
    }
    
    
    func kolodaViewForCardOverlayAtIndex(koloda: KolodaView, index: UInt) -> OverlayView? {
        return NSBundle.mainBundle().loadNibNamed("OverlayView", owner: self, options: nil)[0] as? OverlayView
    }
    
    //MARK: - KolodaViewDelegate
    func kolodaDidSwipedCardAtIndex(koloda: KolodaView, index: UInt, direction: SwipeResultDirection) {
        if direction == SwipeResultDirection.Right {
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.deleteImageView.transform = CGAffineTransformMakeScale(0.9, 0.9)
                self.deleteButton.transform = CGAffineTransformMakeScale(0.9, 0.9)
                self.stackedNumberLabel.transform = CGAffineTransformMakeScale(0.9, 0.9)
                }, completion: { (Bool) -> Void in
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        self.deleteImageView.transform = CGAffineTransformMakeScale(1.1, 1.1)
                        self.deleteButton.transform = CGAffineTransformMakeScale(1.1, 1.1)
                        self.stackedNumberLabel.transform = CGAffineTransformMakeScale(1.1, 1.1)
                        }, completion: { (Bool) -> Void in
                            self.deleteButton.transform = CGAffineTransformMakeScale(1.0, 1.0)
                            self.deleteImageView.transform = CGAffineTransformMakeScale(1.0, 1.0)
                            self.stackedNumberLabel.transform = CGAffineTransformMakeScale(1.0, 1.0)
                            
                            
                    })

                    
            })
            self.stackedAssets.append(self.photoAssets[Int(index)])
            stackedNumberLabel.text = String(stackedAssets.count)
            
        }
    }
    
    func kolodaDidRunOutOfCards(koloda: KolodaView) {
        //Example: reloading
        // self.photoAssetsからself.stackedAssetsを引く(削除する)
        for var i = 0; i < self.photoAssets.count; i++ {
            
        }
        
        var i = 0
        var removeIndexArray = [Int]()
        for photoAsset in self.photoAssets {
            
            for stackedAsset in self.stackedAssets {
                if photoAsset.valueForKey("filename") as! String == stackedAsset.valueForKey("filename") as! String {
                    // 全部の写真の中から、捨てる用の写真と一致しているものを検索
                    print("削除対象の画像が見つかりました", i, "番目のカードです")
                    removeIndexArray.insert(i, atIndex: 0)
                }
            }
            i++
        }
        
        for index in removeIndexArray {
            self.photoAssets.removeAtIndex(index)
        }
        

        kolodaView.resetCurrentCardNumber()
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
    func kolodaDraggedCard(koloda: KolodaView, finishPercent: CGFloat, direction: SwipeResultDirection) {
        let saveview = UIImageView()
        let dumpview = UIImageView()
        saveview.frame = CGRectMake(145, 13, 150, 100)
        dumpview.frame = CGRectMake(-8, 13, 150, 100)
        
        koloda.viewForCardAtIndex(koloda.currentCardNumber)?.subviews.last?.removeFromSuperview()

        if direction == SwipeResultDirection.Right {
            saveview.image = nil
            let img = UIImage(named:"dump")
            dumpview.image = img
                        dumpview.transform = CGAffineTransformMakeRotation(-45 * CGFloat(M_PI/180))
            koloda.viewForCardAtIndex(koloda.currentCardNumber)?.addSubview(dumpview)
            dumpview.alpha = finishPercent/100.0

        };if direction == SwipeResultDirection.Left{
            dumpview.image = nil
            let img = UIImage(named:"save")
            saveview.image = img
            saveview.transform = CGAffineTransformMakeRotation(45 * CGFloat(M_PI/180))
            koloda.viewForCardAtIndex(koloda.currentCardNumber)?.addSubview(saveview)
            saveview.alpha = finishPercent/100.0
            
        }
    }
    
    //カメラロールから写真を選んだとき
    //MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print(info["filename"])
        
        let ud = NSUserDefaults.standardUserDefaults()
        ud.removeObjectForKey("lastCardName")
        ud.synchronize()
        
        self.getAllPhotosInfo()
        
        for photoAsset in photoAssets {
            let URL = info["UIImagePickerControllerReferenceURL"] as! NSURL
            let fetchResult = PHAsset.fetchAssetsWithALAssetURLs([URL], options: nil)
            let asset = fetchResult.firstObject;
            if photoAsset.valueForKey("filename") as! String == asset?.valueForKey("filename") as! String {
                // 選んだ写真と同じphotoAssetを探す
                print("みーっけ")
                kolodaView.resetCurrentCardNumber()
                break
            }else {
                self.photoAssets.removeFirst()
                self.photoAssets.append(photoAsset)
            }
        }
        
        // TODO: ここから
        picker.dismissViewControllerAnimated(true, completion: nil)
        kolodaView.reloadData()
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - Private
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
    
    @IBAction func tapYES() {
        kolodaView?.swipe(SwipeResultDirection.Right)
        
    }
    
    @IBAction func tapNO() {
        kolodaView?.swipe(SwipeResultDirection.Left)
        
        
    }
    
    @IBAction func tapRevert() {
        kolodaView?.revertAction()
        if photoAssets[kolodaView.currentCardNumber] == stackedAssets.last{
            stackedAssets.removeLast()
        }

    }
    
    @IBAction func deleteStackedImages() {
        
        // print(self.stackedAssets)
        
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({ () -> Void in
            PHAssetChangeRequest.deleteAssets(self.stackedAssets)
            }, completionHandler: { ( success, error) -> Void in
                
                print("削除完了")
                if error != nil {
                    print(error)
                }else {
                    self.kolodaView?.reloadData()
            }
        })
    }
    
    @IBAction func help(){
        
        if (helpImageView.image == nil) {
            let img = UIImage(named:"help")
            helpImageView.image = img
        }else{
            helpImageView.image = nil
            
        }
        
    }
    
    @IBAction func backToTop(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - GetAssets
    private func getAllPhotosInfo(){
        photoAssets = []
        
        // TODO: 今古い順なので順番を変えられるように
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let assets: PHFetchResult = PHAsset.fetchAssetsWithMediaType(.Image, options: nil)
        assets.enumerateObjectsUsingBlock { (asset, index, stop) -> Void in
            self.photoAssets.append(asset as! PHAsset)
        }
        
        let ud = NSUserDefaults.standardUserDefaults()
        let lastAssetString = ud.objectForKey("lastCardName") as? String
        
        var currentNumber: Int = 0
        for lastCard in self.photoAssets {
            print(lastCard.valueForKey("filename"))
            if lastCard.valueForKey("filename") as? String == lastAssetString {
                print("HIT！！！！")
                return;
            }else {
                self.photoAssets.removeFirst()
                self.photoAssets.append(lastCard)
            }
            currentNumber++
        }
        
        //上のfor文のnumberの値がカメラロールで指定した画像になるようにしなくちゃいけない
        //上の2つのうち上の方のfor文は必要なのかきく。stackedAssetsに入れるのは削除するやつだけじゃないのか、別に削除しないでとばすだけだから
        
        let manager: PHImageManager = PHImageManager()
        if currentNumber < photoAssets.count {
            manager.requestImageForAsset(photoAssets[currentNumber],targetSize: CGSizeMake(500, 500), contentMode: .AspectFit , options: nil) { (image, info) -> Void in
                //取得したimageをUIImageViewなどで表示する
                //self.myImageView!.image = self.getAssetThumbnail(self.photoAssets[self.imageIndex])
            }
        }
    }
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.defaultManager()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.synchronous = true
        manager.requestImageForAsset(asset, targetSize: CGSize(width: 560.0, height: 560.0), contentMode: .AspectFit, options: option, resultHandler: {(result, info)->Void in thumbnail = result!
        })
        return thumbnail
    }
    

}
