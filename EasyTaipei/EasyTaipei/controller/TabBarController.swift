//
//  TabBarController.swift
//  EasyTaipei
//
//  Created by howard hsien on 2016/7/5.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit
import PureLayout



class TabBarController: UITabBarController, MenuBarDelegate {
    
    
    lazy var menuBar : MenuBar = {
        let bar = MenuBar()
        bar.delegate = self
        bar.clipsToBounds = false
        return bar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        setupTabBar()
    }
    
    
    private func setupTabBar(){
        tabBar.addSubview(menuBar)
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        menuBar.autoPinEdgesToSuperviewEdges()
        tabBar.clipsToBounds = false
    }
    
    
    func switchPages(index: Int) {
            self.selectedIndex =  index
    }
    

}




