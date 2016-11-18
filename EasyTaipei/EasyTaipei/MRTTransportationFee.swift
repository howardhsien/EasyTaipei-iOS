//
//  MRTTransportationFee.swift
//  EasyTaipei
//
//  Created by Eph on 2016/11/18.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import Foundation
import CoreData


class MRTTransportationFee: NSManagedObject {
    
    class func insert(station1: String, station2: String, originalFee: Double, easyCard: Double, senior: Double, charity: Double, context: NSManagedObjectContext) {
        guard let mrtTransportationFee = NSEntityDescription.insertNewObjectForEntityForName("MRTTransportationFee", inManagedObjectContext: context) as? MRTTransportationFee else {return}
        
        context.performBlockAndWait {
            
            mrtTransportationFee.station1 = station1
            mrtTransportationFee.station2 = station2
            mrtTransportationFee.originalFee = originalFee
            mrtTransportationFee.easyCard = easyCard
            mrtTransportationFee.senior = senior
            mrtTransportationFee.charity = charity
        }
    }
}