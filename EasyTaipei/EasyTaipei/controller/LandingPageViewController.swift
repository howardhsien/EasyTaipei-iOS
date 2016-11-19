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
  
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        jsonParser.getDataWithCompletionHandler(.Toilet,completion: {
            if let tabBarVC = self.storyboard?.instantiateViewControllerWithIdentifier("TabBarController") as? TabBarController{
                //                if let window =  (UIApplication.sharedApplication().delegate as? AppDelegate)?.window {
                //                    UIView.transitionWithView(window, duration: 0.5, options: .TransitionFlipFromBottom, animations: {window.rootViewController = tabBarVC}, completion:nil )
                //
                //                }
                //
                //                (UIApplication.sharedApplication().delegate as? AppDelegate)?.
                self.presentViewController(tabBarVC, animated: true, completion: nil)
            }
        })

    
    }


}
