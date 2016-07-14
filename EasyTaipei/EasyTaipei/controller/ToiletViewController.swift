//
//  ToiletViewController.swift
//  EasyTaipei
//
//  Created by howard hsien on 2016/7/5.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit

class ToiletViewController: UIViewController {
    var mapViewController :MapViewController?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        TrackingManager.log(event:classDebugInfo+#function)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        mapViewController = segue.destinationViewController as? MapViewController
        mapViewController?.showInfoType(dataType: .Toilet)
    }
}
