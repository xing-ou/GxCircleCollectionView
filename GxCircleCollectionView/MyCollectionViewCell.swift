//
//  MyCollectionViewCell.swift
//  GxCircleCollectionView
//
//  Created by cxria on 16/10/13.
//  Copyright © 2016年 yushilive. All rights reserved.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    
    var mylabel :UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.red
        return label
    }()
    
    var myImageView:UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override  init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(myImageView)
        self.backgroundColor = UIColor.blue
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addSubview(myImageView)
        self.backgroundColor = UIColor.blue
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //mylabel.frame = self.bounds
        myImageView.frame = self.bounds
        
    }
}
