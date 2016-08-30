//
//  EstimatedArrivalTime.swift
//  EasyTaipei
//
//  Created by Eph on 2016/8/29.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import Foundation
import CoreData


class EstimatedArrivalTime: NSManagedObject {

    class func insert(station1: String, station2: String, time: Double, context: NSManagedObjectContext) {
        guard let estimatedArrivalTime = NSEntityDescription.insertNewObjectForEntityForName("EstimatedArrivalTime", inManagedObjectContext: context) as? EstimatedArrivalTime else {return}
        
        context.performBlock {
            
            estimatedArrivalTime.station1 = station1
            estimatedArrivalTime.station2 = station2
            estimatedArrivalTime.time = time
        }
    }
}
