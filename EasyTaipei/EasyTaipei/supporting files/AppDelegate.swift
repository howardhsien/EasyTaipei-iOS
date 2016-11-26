//
//  AppDelegate.swift
//  EasyTaipei
//
//  Created by howard hsien on 2016/7/5.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit
import CoreData
import Foundation
import Amplitude_iOS

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    //private var managedObjectContext: NSManagedObjectContext? =
        //(UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //preload data for when first time in use
        let defaults = NSUserDefaults.standardUserDefaults()
        let isPreloaded = defaults.boolForKey("isPreloaded")
        if !isPreloaded {
            preloadData()
            defaults.setBool(true, forKey: "isPreloaded")
        }
        // Override point for customization after application launch.
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        Amplitude.instance().initializeApiKey("aa386419aa58ab94d59d39a785f8821a")

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    


    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.appworks-school-WuDuhRen.asdasd" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    
    // MARK: - Preload to Core Data
    
    private func preloadData(){
        loadEstimatedArrivalTimeJSON()
        loadMRTButtonCoordinatesJSON()
        loadMRTTransportationFeeCSV()
        loadMRTEnglishNameCSV()
    }
    
    
    // MARK: - Estimated Arrival Time JSON
    
    private func loadEstimatedArrivalTimeJSON(){
        
        removeEstimatedArrivalTimeData()
        
        let url = NSBundle.mainBundle().URLForResource("EstimatedArrivalTime", withExtension: "json")
        let data = NSData(contentsOfURL: url!)
        
        do {
            let object = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            guard let JSONObject = object as? [String: AnyObject] else {return}
            readEstimatedArrivalTimeJSON(JSONObject)
            
        } catch let error as NSError {
            print(error)
        }
    }
    
    private func readEstimatedArrivalTimeJSON(JSONObject: [String: AnyObject]) {
        
        for (station,stationData) in JSONObject {
            guard let stationData = stationData as? [String: [String: String]] else {return}
            for (_, destinationAndTime) in stationData {
                let time = Double(destinationAndTime["timeSpent"]!)
                //insert to coredata
                EstimatedArrivalTime.insert(
                    station,
                    station2: destinationAndTime["destination"]!,
                    time: time!,
                    context: managedObjectContext
                )
                //print("loading data: \(station), \(destinationAndTime["destination"]!), \(time!)")
            }
        }
        
        _ = try? managedObjectContext.save()
    }
    
    private func removeEstimatedArrivalTimeData() {
        let requestForEstimatedArrivalTime = NSFetchRequest(entityName: "EstimatedArrivalTime")
        
        guard var estimatedArrivalTimeData = try? managedObjectContext.executeFetchRequest(requestForEstimatedArrivalTime) as! [EstimatedArrivalTime] else {return}
        if estimatedArrivalTimeData.count > 0 {
            for data in estimatedArrivalTimeData {
                managedObjectContext.deleteObject(data)
                print("Removing data before preload, this should not happend")
            }
            estimatedArrivalTimeData.removeAll(keepCapacity: false)
            _ = try? managedObjectContext.save()
        }
    }
    
    
    
    // MARK: - MRT Button Coordinates JSON
    
    private func loadMRTButtonCoordinatesJSON(){
        
        removeMRTButtonCoordinatesData()
        
        let url = NSBundle.mainBundle().URLForResource("MRTButtonCoordinates", withExtension: "json")
        let data = NSData(contentsOfURL: url!)
        
        do {
            let object = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            guard let JSONObject = object as? [String:String] else {return}
            readMRTButtonCoordinatesJSON(JSONObject)
            
        } catch let error as NSError {
            print(error)
        }
    }
    
    private func readMRTButtonCoordinatesJSON(JSONObject: [String:String]) {
        
        for (station, coordinate) in JSONObject {
            MRTButtonCoordinates.insert(station, coordinatesString: coordinate, context: managedObjectContext)
        }
        _ = try? managedObjectContext.save()
    }
    
    private func removeMRTButtonCoordinatesData() {
        let requestForMRTButtonCoordinates = NSFetchRequest(entityName: "MRTButtonCoordinates")
        
        guard var mrtButtonCoordinates = try? managedObjectContext.executeFetchRequest(requestForMRTButtonCoordinates) as! [MRTButtonCoordinates] else {return}
        if mrtButtonCoordinates.count > 0 {
            for data in mrtButtonCoordinates {
                managedObjectContext.deleteObject(data)
                print("Removing data before preload, this should not happend")
            }
            mrtButtonCoordinates.removeAll(keepCapacity: false)
            _ = try? managedObjectContext.save()
        }
    }
    
    
    
    // MARK: - MRT Transportation Fee CSV
    
    private func loadMRTTransportationFeeCSV(){
        removeMRTTransportationFeeCSV()
        
        do {
            if let path = NSBundle.mainBundle().pathForResource("mrtTransportationFee", ofType: "txt"){
                let data = try String(contentsOfFile:path, encoding: NSUTF8StringEncoding)
                let mrtTransportationFeeData = data.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
                
                for mrtFeeData in mrtTransportationFeeData{
                    //csv header
                    if mrtFeeData != "" && mrtFeeData != "station1,station2,originalFee,easyCard,senior,charity,,"{
                        
                        let feeData = mrtFeeData.componentsSeparatedByString(",")
                        let station1 = feeData[0]
                        let station2 = feeData[1]
                        guard let originalFee = Double(feeData[2]) else {return}
                        guard let easyCard = Double(feeData[3]) else {return}
                        guard let senior = Double(feeData[4]) else {return}
                        
                        MRTTransportationFee.insert(station1,
                                                    station2: station2,
                                                    originalFee: originalFee,
                                                    easyCard: easyCard,
                                                    senior: senior,
                                                    charity: 0,
                                                    context: managedObjectContext)
                    }
                }
                _ = try? managedObjectContext.save()
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    private func removeMRTTransportationFeeCSV(){
        let requestForMRTTransportationFee = NSFetchRequest(entityName: "MRTTransportationFee")
        
        guard var mrtTransportationFeeData = try? managedObjectContext.executeFetchRequest(requestForMRTTransportationFee) as! [EstimatedArrivalTime] else {return}
        if mrtTransportationFeeData.count > 0 {
            for data in mrtTransportationFeeData {
                managedObjectContext.deleteObject(data)
                print("Removing data before preload, this should not happend")
            }
            mrtTransportationFeeData.removeAll(keepCapacity: false)
            _ = try? managedObjectContext.save()
        }
    }
    
    
    
    // MARK: - MRT English Name CSV
    
    private func loadMRTEnglishNameCSV(){
        removeMRTEnglishNameCSV()
        
        do {
            if let path = NSBundle.mainBundle().pathForResource("mrtEnglishName", ofType: "txt"){
                let data = try String(contentsOfFile:path, encoding: NSUTF8StringEncoding)
                let mrtEnglishNameData = data.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
                
                for mrtEnglishName in mrtEnglishNameData {
                    //csv header
                    if mrtEnglishName != "" {
                        
                        let nameData = mrtEnglishName.componentsSeparatedByString(",")
                        let stationChinese = nameData[0]
                        let stationEnglish = nameData[1]
                        
                        MRTEnglishName.insert(stationChinese, stationEnglish: stationEnglish, context: managedObjectContext)
                    }
                }
                _ = try? managedObjectContext.save()
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    private func removeMRTEnglishNameCSV() {
        let requestForMRTEnglishNameCSV = NSFetchRequest(entityName: "MRTEnglishName")
        
        guard var mrtEnglishNameData = try? managedObjectContext.executeFetchRequest(requestForMRTEnglishNameCSV) as! [MRTEnglishName] else {return}
        if mrtEnglishNameData.count > 0 {
            for data in mrtEnglishNameData {
                managedObjectContext.deleteObject(data)
                print("Removing data before preload, this should not happend")
            }
            mrtEnglishNameData.removeAll(keepCapacity: false)
            _ = try? managedObjectContext.save()
        }
    }
    
}

    




















