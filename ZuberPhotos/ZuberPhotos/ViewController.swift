//
//  ViewController.swift
//  swiftPickMore
//
//  Created by duzhe on 15/10/15.
//  Copyright © 2015年 duzhe. All rights reserved.
//

import UIKit
import AssetsLibrary

protocol PassPhotosDelegate{
    func passPhotos(selected:[ZuberImage])
}

class ViewController: UIViewController ,UICollectionViewDataSource,UICollectionViewDelegate{

    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var cancelBtnItem:UIBarButtonItem!
    @IBOutlet weak var confirmBtnItem:UIBarButtonItem!
    
    
    var photoDelegate:PassPhotosDelegate?
    var assetsLibrary:ALAssetsLibrary!
    var currentAlbum:ALAssetsGroup?
    var tempZuber:ZuberImage!
    var count:Int = 0;
    var selectedImage:[ZuberImage] = []
    
    
    var imageArray:[ZuberImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "请选择图片"
        initCollectionView()
        getGroupList()
        self.confirmBtnItem.enabled = false
    }

    func initCollectionView(){
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection =  UICollectionViewScrollDirection.Vertical
        let itemWidth = SCREEN_WIDTH/4 - 6
        let itemHeight:CGFloat = 100.0
        flowLayout.itemSize = CGSize(width: itemWidth , height: itemHeight)
        flowLayout.minimumLineSpacing = 2 //上下间隔
        flowLayout.minimumInteritemSpacing = 2 //左右间隔
        
        self.collectionView.collectionViewLayout = flowLayout
        self.collectionView.backgroundColor = UIColor.clearColor()
        //注册
        self.collectionView.registerClass(ZuberImageCell.self,forCellWithReuseIdentifier:"cell")
        //设置代理
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return imageArray.count
    }
    
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ZuberImageCell;
        cell.update(imageArray[indexPath.row])
        cell.handleSelect={
            if cell.isSelect{
                if self.count > 0{
                   self.count--
                }
                self.imageArray[indexPath.row].isSelect = false
                
            }else{
                self.count++
                self.imageArray[indexPath.row].isSelect = true
            }
            
            if(self.count > 0){
                self.title = "已选择\(self.count)张图片"
                self.confirmBtnItem.enabled = true
            }else{
                self.title = "请选择图片"
                self.confirmBtnItem.enabled = false
            }
        }
        return cell;
        
    }
    
    @IBAction func cancelClick(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    @IBAction func confirmClick(sender: UIBarButtonItem) {
        selectedImage=[]
        for  item in imageArray{
            if item.isSelect {
                selectedImage.append(item)
            }
        }
        photoDelegate?.passPhotos(selectedImage)
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
}

extension ViewController{
    
    func getGroupList(){
        
        let listGroupBlock:ALAssetsLibraryGroupsEnumerationResultsBlock = {(group,stop)->Void in
            
            let  onlyPhotosFilter = ALAssetsFilter.allPhotos()  //获取所有图
            if let group=group{
                
                group.setAssetsFilter(onlyPhotosFilter)
                
                if group.numberOfAssets() > 0{
                
                    self.showOhoto(group)
                    
                }else{
                    
                    
                }
            }
        }
        getAssetsLibrary().enumerateGroupsWithTypes(ALAssetsGroupSavedPhotos, usingBlock: listGroupBlock, failureBlock: nil)
    }
    
    
    func getAssetsLibrary()->ALAssetsLibrary{
        
        struct Singleton{
            static var onceToken : dispatch_once_t = 0
            static var single:ALAssetsLibrary?
        }
        dispatch_once(&Singleton.onceToken,{
            Singleton.single=ALAssetsLibrary()
        })
        return Singleton.single!
        
    }
    
    func showOhoto(photos:ALAssetsGroup){
        
        if (currentAlbum == nil || currentAlbum?.valueForProperty(ALAssetsGroupPropertyName).isEqualToString(photos.valueForProperty(ALAssetsGroupPropertyName) as! String) != nil){
            
            self.currentAlbum = photos
            imageArray = []
            
            let assetsEnumerationBlock:ALAssetsGroupEnumerationResultsBlock = { (result,index,stop) in
                
                if (result != nil) {
                    self.tempZuber = ZuberImage()
                    self.tempZuber.asset = result
                    self.tempZuber.isSelect = false
                    self.imageArray.append(self.tempZuber)
                    self.collectionView.reloadData()
                    self.assetsLibrary = nil
                    self.currentAlbum = nil
                }else{
                    
                }
            }
            let  onlyPhotosFilter = ALAssetsFilter.allPhotos()
            self.currentAlbum?.setAssetsFilter(onlyPhotosFilter)
            self.currentAlbum?.enumerateAssetsUsingBlock(assetsEnumerationBlock)
        }
        
    }

    
}

