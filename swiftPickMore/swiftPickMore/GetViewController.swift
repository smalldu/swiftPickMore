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
        
        for item in selected{
            imageArray.append(item)
        }
        initCollectionView();//防止报野指针的错误  内存溢出
        if self.collectionView != nil {
            self.collectionView.reloadData()
        }
        print(self.collectionView)
    
       // self.collectionView.reloadItemsAtIndexPaths(self.collectionView.indexPathsForVisibleItems())
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "viewPhotos"{
            
           let vc = segue.destinationViewController as! ViewController
           vc.photoDelegate = self
            
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return imageArray.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! GetImageCell;
        cell.update(imageArray[indexPath.row])
        return cell;
        
    }

    
}
