//
//  MRTViewController.swift
//  EasyTaipei
//
//  Created by howard hsien on 2016/7/5.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit
import CoreData

class MRTViewController: UIViewController,UIScrollViewDelegate {
//ScrollView image viewer
    
    //-------------------------------data-------------------------------------
    private var managedObjectContext: NSManagedObjectContext? =
        (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    private var buttonTagSelected = [UIButton]()
    
    //------------------------------------------------------------------------
    
    private lazy var scrollView:UIScrollView = {
        let sv = UIScrollView(frame: self.view.bounds)
        sv.delegate = self
        return sv
    }()
    
    private lazy var mrtView: UIView = {
        //should not use imageView as before; the button added on imageView will not respond.
        if let mrtView = UIView.loadFromNibNamed("mrtView"){
            
            let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
            if let tabHeight = self.tabBarController?.tabBar.frame.height,
                navHeight = self.navigationController?.navigationBar.frame.height
                
            {
                mrtView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height  - tabHeight - navHeight - statusBarHeight)
            }
            else{
                mrtView.frame = self.view.frame
            }
            mrtView.contentMode = .ScaleToFill
            return mrtView
        }
        else{
            return UIView()
        }
    }()

    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        setupScrollView()
        setZoomScale()
        setupGestureRecognizer()
        
        //Chris
        buttonIteration()
        parseEstimatedArrivalTimeJSON()
        
    }
    //MARK: ScrollView
    private func setupScrollView(){
        scrollView.addSubview(mrtView)
        scrollView.maximumZoomScale = 4.0
        scrollView.minimumZoomScale = 1.0
        scrollView.contentSize = mrtView.frame.size
    }
    
    //handle the zooming
    private func setZoomScale() {
        let imageViewSize = mrtView.bounds.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        
        scrollView.minimumZoomScale = min(widthScale, heightScale)
        scrollView.zoomScale = 1.0
    }
    
    private func setupGestureRecognizer() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
        
        //oneTap for location
        let oneTap = UITapGestureRecognizer(target: self, action: #selector(handleOneTap))
        oneTap.numberOfTapsRequired = 1
        scrollView.addGestureRecognizer(oneTap)
    }
    
    @objc private func handleDoubleTap(recognizer: UITapGestureRecognizer) {
        let tapPoint = recognizer.locationInView(view)
        let preferedTapZoomScale:CGFloat = 3.0
        if (scrollView.zoomScale > scrollView.minimumZoomScale) {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
            
        } else {
            scrollView.zoomToPoint(tapPoint, withScale: preferedTapZoomScale, animated: true)
//            scrollView.setZoomScale(preferedTapZoomScale, animated: true)
        }
    }
    
   

    
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return mrtView
    }

}

extension UIScrollView {
    
    private func zoomToPoint( zoomPoint: CGPoint, withScale scale:CGFloat, animated :Bool)
    {
        //Normalize current content size back to content scale of 1.0f
        var contentSize = CGSize()
        contentSize.width = (self.contentSize.width / self.zoomScale);
        contentSize.height = (self.contentSize.height / self.zoomScale);
        
        var zoomToPoint = CGPoint()
        //translate the zoom point to relative to the content rect
        zoomToPoint.x = (zoomPoint.x / self.bounds.size.width) * contentSize.width;
        zoomToPoint.y = (zoomPoint.y / self.bounds.size.height) * contentSize.height;
        
        //derive the size of the region to zoom to
        var zoomSize = CGSize();
        zoomSize.width = self.bounds.size.width / scale;
        zoomSize.height = self.bounds.size.height / scale;
        
        //offset the zoom rect so the actual zoom point is in the middle of the rectangle
        var zoomRect = CGRect();
        zoomRect.origin.x = zoomPoint.x - zoomSize.width / 2.0;
        zoomRect.origin.y = zoomPoint.y - zoomSize.height / 2.0;
        zoomRect.size.width = zoomSize.width;
        zoomRect.size.height = zoomSize.height;
        
        //apply the resize
        zoomToRect(zoomRect, animated: animated)
    }
}




//MARK: Button
extension MRTViewController {
    
    //add button
    func buttonIteration(){
        
        let stationLocation = [
            "中山":"{164.0, 317.666656494141}",
            "雙連":"{163.666656494141, 294.0}",
            "民權西路":"{163.666656494141, 271.33332824707}",
            "圓山":"{163.0, 246.666656494141}",
            "劍潭":"{163.0, 224.0}",
            "士林":"{162.666656494141, 204.666656494141}",
            "芝山":"{163.33332824707, 185.33332824707}",
            "明德":"{163.33332824707, 163.33332824707}"
        ]
        
        
        
        for (station, coordinate) in stationLocation {
            let button = UIButton(type: .System)
            button.center = CGPointFromString(coordinate)
            button.bounds = CGRect(x: 0,y: 0,width: 9,height: 9)
            button.backgroundColor = .redColor()
            button.alpha = 0.6
            button.addTarget(self, action: #selector(MRTViewController.EstimatedArrivalTimer(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            button.setTitle(station, forState: UIControlState.Normal)
            button.tintColor = .clearColor()
            
            mrtView.addSubview(button)
        }
    }
    
    //show coordinates of stations
    func handleOneTap(recognizer:UITapGestureRecognizer){
        //Log Clicked Location
        let tapPoint = recognizer.locationInView(mrtView)
        print(tapPoint)
        cleanButton()
    }
    
    func EstimatedArrivalTimer(sender: UIButton!){
        sender.backgroundColor = .greenColor()
        
        if buttonTagSelected.count < 2 {
            buttonTagSelected.append(sender)
            
        } else {
            cleanButton()
            buttonTagSelected.append(sender)
        }
        
        if buttonTagSelected.count == 2 {
            showEstimatedArrivalTime()
        }
    }
    
    func showEstimatedArrivalTime() {
    }
    
    func cleanButton() {
        for button in buttonTagSelected {
            button.backgroundColor = .redColor()
        }
        buttonTagSelected = []
    }
}



//coredata
extension MRTViewController {
    
    private func parseEstimatedArrivalTimeJSON(){
        
        let url = NSBundle.mainBundle().URLForResource("EstimatedArrivalTime", withExtension: "json")
        let data = NSData(contentsOfURL: url!)
        
        do {
            let object = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            guard let JSONObject = object as? [String: AnyObject] else {return}
            readJSONObject(JSONObject)
            
        } catch {
            // Handle Error
        }
    }
    
    private func readJSONObject(JSONObject: [String: AnyObject]) {
        var timeDataCount = 0
        
        for (station,stationData) in JSONObject {
            guard let stationData = stationData as? [String: [String: String]] else {return}
            for (_, destinationAndTime) in stationData {
                timeDataCount += 1
                let time = Double(destinationAndTime["timeSpent"]!)
                //insert to coredata
                EstimatedArrivalTime.insert(
                    station,
                    station2: destinationAndTime["destination"]!,
                    time: time!,
                    context: managedObjectContext!
                )
            }
        }
        
        print("timeDataCount: \(timeDataCount)")
    }

    
    func getEstimatedArrivalTimeData() {
        let request = NSFetchRequest(entityName: "EstimatedArrivalTime")
        request.fetchBatchSize = 1
        request.fetchLimit = 3
        
    }
    
}




