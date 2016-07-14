//
//  YoubikeViewController.swift
//  EasyTaipei
//
//  Created by howard hsien on 2016/7/5.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit

enum Lang:String {
    case Chinese = "中"
    case English = "E"
}

class YoubikeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switchLangBarButton.target = self
        switchLangBarButton.action = #selector(switchLangAction)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        TrackingManager.log(event:classDebugInfo+#function)
    }
    
    
    @IBOutlet weak var switchLangBarButton: UIBarButtonItem!
    var currentLang = Lang.Chinese
    
    var mapViewController :MapViewController?
    @IBAction func refreshAction(sender: AnyObject) {
        mapViewController?.reloadData()
        TrackingManager.log(event: classDebugInfo+#function)
    }
    
    func switchLangAction(){
        

        switch currentLang {
        case .Chinese:
            //do sth to change lang to english
            currentLang = .English
            TrackingManager.log(event: classDebugInfo+#function+": to English")

        case .English:
            //do sth to change lang to english
            currentLang = .Chinese
            TrackingManager.log(event: classDebugInfo+#function+": to Chinese")
        }
        mapViewController?.changeLang(currentLang)
        switchLangBarButton.title = currentLang.rawValue
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let mapVC = segue.destinationViewController as? MapViewController{
            self.mapViewController = mapVC
            mapVC.showInfoType(dataType: .Youbike)
            
        }
    }
}
