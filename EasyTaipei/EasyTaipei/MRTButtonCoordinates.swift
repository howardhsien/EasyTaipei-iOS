//
//  MRTButtonCoordinates.swift
//  EasyTaipei
//
//  Created by Eph on 2016/8/31.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import Foundation
import CoreData


class MRTButtonCoordinates: NSManagedObject {

    class func insert(station: String, coordinatesString: String, context: NSManagedObjectContext) {
        guard let mrtButtonCoordinates = NSEntityDescription.insertNewObjectForEntityForName("MRTButtonCoordinates", inManagedObjectContext: context) as? MRTButtonCoordinates else {return}
        
        context.performBlockAndWait {
            mrtButtonCoordinates.station = station
            mrtButtonCoordinates.coordinatesString = coordinatesString
        }
    }

}
