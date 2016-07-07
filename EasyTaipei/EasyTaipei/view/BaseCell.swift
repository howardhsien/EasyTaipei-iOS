//
//  VideoCell.swift
//  youtube
//
//  Created by Brian Voong on 6/3/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

