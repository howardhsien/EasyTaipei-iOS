//
//  mrtDetailPanel.swift
//  EasyTaipei
//
//  Created by Eph on 2016/11/16.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit

class MRTDetailPanel: UIView {
    
    @IBOutlet weak var mrtRoute: UILabel!
    
    @IBOutlet weak var estimatedArrivalTime: UILabel!
    
}

extension MRTDetailPanel {
    override class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? UIView
    }
}

