//
//  CustomMKPointAnnotation.swift
//  Mr-Ride
//
//  Created by howard hsien on 2016/6/21.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit
import MapKit

class CustomMKPointAnnotation: MKPointAnnotation {
    var type: DataType?
    var toilet:Toilet?
    var youbike:Youbike?
    var address:String?
    var category:String?


    func updateInfo(){
        if let toilet = toilet{
            address = toilet.address
            category = toilet.category
            coordinate = CLLocationCoordinate2D(latitude: toilet.latitude, longitude: toilet.longitude)
            title = toilet.name
        }
        if let youbike = youbike{
            subtitle = String(format:"%d bike(s)",youbike.bikeLeft)
            address = youbike.address
            coordinate = CLLocationCoordinate2D(latitude: youbike.latitude, longitude: youbike.longitude)
            title = youbike.name
        }
    }
    
    func changeLang(lang: Lang){
        if let youbike = youbike{
            switch lang {
            case .Chinese:
                title = youbike.name
                address = youbike.address
            case .English:
                title = youbike.name_en
                address = youbike.address_en

            }
        }
        
    }
}
