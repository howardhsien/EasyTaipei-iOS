//
//  YoubikeViewController.swift
//  EasyTaipei
//
//  Created by howard hsien on 2016/7/5.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit

class YoubikeViewController: UIViewController {
    
    var mapViewController :MapViewController?
    @IBAction func refreshAction(sender: AnyObject) {
        mapViewController?.reloadData()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let mapVC = segue.destinationViewController as? MapViewController{
            self.mapViewController = mapVC
            mapVC.showInfoType(dataType: .Youbike)
            
        }
    }
}
