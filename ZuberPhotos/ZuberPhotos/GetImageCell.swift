//
//  GetImageCell.swift
//  swiftPickMore
//
//  Created by duzhe on 15/10/16.
//  Copyright © 2015年 duzhe. All rights reserved.
//

import UIKit
import AssetsLibrary

class GetImageCell: UICollectionViewCell {
    
    var imageView:UIImageView!

    
    var handleSelect:(()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.imageView = UIImageView(frame:CGRectZero)
        self.addSubview(self.imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.imageView.frame = self.bounds
    }
    
    func update(image:ZuberImage){
        self.imageView.image = UIImage(CGImage: image.asset.aspectRatioThumbnail().takeUnretainedValue())  //thumbnail().takeUnretainedValue()
    }
    
    
}
