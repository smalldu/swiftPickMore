//
//  GetViewController.swift
//  swiftPickMore
//
//  Created by duzhe on 15/10/16.
//  Copyright © 2015年 duzhe. All rights reserved.
//

import UIKit
import AssetsLibrary

class GetViewController: UIViewController,PassPhotosDelegate,UICollectionViewDataSource,UICollectionViewDelegate {

    
    var collectionView:UICollectionView!
    
    var imageArray:[ZuberImage] = []
    
    override func viewDidLoad() {
        print("11")
        
        super.viewDidLoad()
        initCollectionView()
    }
    
    func initCollectionView(){
       
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection =  UICollectionViewScrollDirection.Vertical
        let itemWidth = SCREEN_WIDTH/4 - 6
        let itemHeight:CGFloat = 100.0
        flowLayout.itemSize = CGSize(width: itemWidth , height: itemHeight)
        flowLayout.minimumLineSpacing = 2 //上下间隔
        flowLayout.minimumInteritemSpacing = 2 //左右间隔
        collectionView = UICollectionView(frame: CGRectMake(0,100,SCREEN_WIDTH,SCREEN_HEIGHT),collectionViewLayout:flowLayout)

        self.view.addSubview(collectionView)
        self.collectionView.backgroundColor = UIColor.clearColor()
        //注册
        self.collectionView.registerClass(GetImageCell.self,forCellWithReuseIdentifier:"cell")
        //设置代理
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    
    func passPhotos(selected: [ZuberImage]) {
                print("21")
        imageArray = selected

    }
    
    override func viewWillAppear(animated: Bool) {
                print("31")
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "viewPhotos"{
            
           let vc = segue.destinationViewController as! ViewController
           vc.photoDelegate = self
            
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
                print("41")
        return imageArray.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
                print("51")
        print(collectionView)
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! GetImageCell;
        cell.update(imageArray[indexPath.row])
         print("61")
        return cell;
        
    }

    
}
