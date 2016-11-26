//
//  MRTEnglishName.swift
//  EasyTaipei
//
//  Created by Eph on 2016/11/26.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import Foundation
import CoreData


class MRTEnglishName: NSManagedObject {

    class func insert(stationChinese: String, stationEnglish: String, context: NSManagedObjectContext) {
        guard let mrtEnglishName = NSEntityDescription.insertNewObjectForEntityForName("MRTEnglishName", inManagedObjectContext: context) as? MRTEnglishName else {return}
        
        context.performBlockAndWait {
            
            mrtEnglishName.stationChinese = stationChinese
            mrtEnglishName.stationEnglish = stationEnglish
        }
    }
}
