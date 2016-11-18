//
//  MRTButtonCoordinates+CoreDataProperties.swift
//  EasyTaipei
//
//  Created by Eph on 2016/8/31.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension MRTButtonCoordinates {

    @NSManaged var station: String?
    @NSManaged var coordinatesString: String?

}
