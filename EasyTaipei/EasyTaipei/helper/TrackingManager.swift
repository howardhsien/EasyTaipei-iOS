//
//  TrackingManager.swift
//  EasyTaipei
//
//  Created by howard hsien on 2016/7/14.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import Foundation
import Amplitude_iOS

class TrackingManager{
    
    class func log(event event:String){
        Amplitude.instance().logEvent(event)

    }
}
