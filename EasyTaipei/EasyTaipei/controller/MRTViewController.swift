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
    
    private var buttonTagSelected = [UIButton]()
    
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
//        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
//        doubleTap.numberOfTapsRequired = 2
//        scrollView.addGestureRecognizer(doubleTap)
        
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
    private func buttonIteration(){
        
        let managedObjectContext: NSManagedObjectContext? =
            (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
        let requestForEstimatedArrivalTime = NSFetchRequest(entityName: "MRTButtonCoordinates")

        
        guard let mrtButtonCoordinates = try? managedObjectContext!.executeFetchRequest(requestForEstimatedArrivalTime) as! [MRTButtonCoordinates] else {return}
        
        for data in mrtButtonCoordinates {
            let button = UIButton(type: .System)
            
            //Adjustment for different device, the button coordinate data is for iPhone 6s Plus
            var buttonCoordinate = CGPointFromString(data.coordinatesString!)
            buttonCoordinate.x = buttonCoordinate.x * mrtView.frame.width/414
            buttonCoordinate.y = buttonCoordinate.y * mrtView.frame.height/623
            button.center = buttonCoordinate
            
            button.bounds = CGRect(x: 0,y: 0,width: 9,height: 9)
            button.backgroundColor = .redColor()
            button.alpha = 0.6
            button.addTarget(self, action: #selector(MRTViewController.MRTButtonBehavior(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            button.setTitle(data.station, forState: UIControlState.Normal)
            button.tintColor = .clearColor()
            
            mrtView.addSubview(button)
        }
    }
    
    
    func handleOneTap(recognizer:UITapGestureRecognizer){
        //debug: Log Clicked Location
        var tapPoint = "\(recognizer.locationInView(mrtView))"
        tapPoint = tapPoint.stringByReplacingOccurrencesOfString("(", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        tapPoint = tapPoint.stringByReplacingOccurrencesOfString(")", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        print(tapPoint)
        cleanButton()
    }
    
    func MRTButtonBehavior(sender: UIButton!){
        sender.backgroundColor = .greenColor()
        
        if buttonTagSelected.count < 2 {
            buttonTagSelected.append(sender)
            
        } else {
            cleanButton()
            buttonTagSelected.append(sender)
        }
        
        if buttonTagSelected.count == 2 {
            getEstimatedArrivalTimeData(buttonTagSelected[0].currentTitle!, station2: buttonTagSelected[1].currentTitle!)
        }
    }
    
    
    func cleanButton() {
        for button in buttonTagSelected {
            button.backgroundColor = .redColor()
        }
        buttonTagSelected = []
    }
    
    func getEstimatedArrivalTimeData(station1: String, station2: String) {
        let managedObjectContext: NSManagedObjectContext? =
            (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
        
        let requestForEstimatedArrivalTime = NSFetchRequest(entityName: "EstimatedArrivalTime")
        requestForEstimatedArrivalTime.fetchBatchSize = 1
        requestForEstimatedArrivalTime.fetchLimit = 3
        requestForEstimatedArrivalTime.predicate = NSPredicate(format: "station1 = %@ AND station2 = %@", argumentArray: [station1, station2])
        
        guard let estimatedArrivalTimeData = try? managedObjectContext!.executeFetchRequest(requestForEstimatedArrivalTime) as! [EstimatedArrivalTime] else {return}
        
        print("\(estimatedArrivalTimeData.first?.station1) to \(estimatedArrivalTimeData.first?.station2) needs \(estimatedArrivalTimeData.first?.time) minute(s)")
    }
}







