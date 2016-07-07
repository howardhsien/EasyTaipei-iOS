//
//  LandingPageViewController.swift
//  EasyTaipei
//
//  Created by howard hsien on 2016/7/7.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit



class LandingPageViewController: UIViewController {
    var jsonParser = JSONParser.sharedInstance()
    override func viewDidLoad() {
        super.viewDidLoad()
        jsonParser.getDataWithCompletionHandler(.Toilet,completion: {
            if let tabBarVC = self.storyboard?.instantiateViewControllerWithIdentifier("TabBarController") as? TabBarController{
                self.presentViewController(tabBarVC, animated: true, completion: nil)
            }
        })

    }


}
