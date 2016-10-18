//
//  MyView.swift
//  GxCircleCollectionView
//
//  Created by cxria on 16/10/17.
//  Copyright © 2016年 yushilive. All rights reserved.
//

import UIKit

class MyView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        print("init(frame: CGRect)")
    }
    
   required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("init(frame: CGRect)")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("myview layoutsubview")
    }
    

}
