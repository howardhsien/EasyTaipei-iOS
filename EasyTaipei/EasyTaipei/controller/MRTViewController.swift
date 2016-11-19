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
    private var buttonShadowSelected = [UIView]()
    
    private let mrtDetailPanel: MRTDetailPanel = UINib(nibName: "mrtDetailPanel", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! MRTDetailPanel
    
    private lazy var scrollView:UIScrollView = {
        let sv = UIScrollView(frame: self.view.bounds)
        sv.delegate = self
        return sv
    }()
    
    private lazy var mrtView: UIView = {
        //should not use imageView; the button added on imageView will not respond.
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
        mrtDetailPanel.hidden = true
        buttonIteration()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        TrackingManager.log(event:classDebugInfo+#function)
    }
    
    //MARK: ScrollView
    private func setupScrollView(){
        scrollView.addSubview(mrtView)
        scrollView.maximumZoomScale = 4.0
        scrollView.minimumZoomScale = 1.0
        scrollView.contentSize = mrtView.frame.size
        
        //setup mrtDetailPanel
        mrtDetailPanel.frame = CGRectMake(0, 0, mrtView.frame.size.width, 100)
        mrtDetailPanel.hidden = true
        scrollView.addSubview(mrtDetailPanel)
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
            
            button.bounds = CGRect(x: 0,y: 0,width: 15,height: 15)
            button.backgroundColor = .clearColor()
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
        
        if buttonTagSelected.count < 2 {
            if buttonTagSelected.contains(sender) { return }
            buttonTagSelected.append(sender)
            activateButton(sender)
            
        } else {
            cleanButton()
            
            if buttonTagSelected.contains(sender) { return }
            buttonTagSelected.append(sender)
            activateButton(sender)
        }
        
        if buttonTagSelected.count == 2 {
            let station1 = buttonTagSelected[0].currentTitle!
            let station2 = buttonTagSelected[1].currentTitle!
            let time = getEstimatedArrivalTimeData(station1, station2: station2)
            let originalFee = getMRTTransportationFee(station1, station2: station2)
            showDetailPanel(station1, station2: station2, time: time, originalFee: originalFee)
        }
    }
    
    func cleanButton() {
        mrtDetailPanel.hidden = true
        for button in buttonTagSelected {
            button.backgroundColor = .clearColor()
            button.setImage(nil, forState: .Normal)
            button.tintColor = .clearColor()
            button.layer.borderWidth = 0
        }
        buttonTagSelected = []
        
        for buttonShadow in buttonShadowSelected {
            buttonShadow.removeFromSuperview()
        }
        buttonShadowSelected = []
    }
    
    func activateButton(button: UIButton!) {
        //MRT Image
        let image = UIImage(named: "MRT") as UIImage?
        button.tintColor = UIColor(red: 242/255.0, green: 255/255.0, blue: 227/255.0, alpha: 1.0)
        button.setImage(image, forState: .Normal)
        button.imageEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2)
        
        button.backgroundColor = UIColor(red: 23/255.0, green: 149/255.0, blue: 163/255.0, alpha: 1.0)

        button.layer.cornerRadius = button.frame.width / 2
        button.layer.borderWidth = 0.6
        button.layer.borderColor = UIColor(red: 242/255.0, green: 255/255.0, blue: 227/255.0, alpha: 1.0).CGColor
        
        //Button Shadow
        let buttonShadow = UIView(frame: CGRectMake(50, 50, 22, 22))
        buttonShadow.backgroundColor = UIColor(red: 23/255.0, green: 149/255.0, blue: 163/255.0, alpha: 0.2)
        buttonShadow.center = button.center
        buttonShadow.layer.cornerRadius = buttonShadow.frame.width / 2
        mrtView.insertSubview(buttonShadow, belowSubview: button.imageView!)
        buttonShadowSelected.append(buttonShadow)
    }
    
    func getEstimatedArrivalTimeData(station1: String, station2: String) -> NSNumber {
        let managedObjectContext: NSManagedObjectContext? =
            (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
        
        let requestForEstimatedArrivalTime = NSFetchRequest(entityName: "EstimatedArrivalTime")
        requestForEstimatedArrivalTime.fetchBatchSize = 1
        requestForEstimatedArrivalTime.fetchLimit = 3
        requestForEstimatedArrivalTime.predicate = NSPredicate(format: "station1 = %@ AND station2 = %@", argumentArray: [station1, station2])
        
        guard let estimatedArrivalTimeData = try? managedObjectContext!.executeFetchRequest(requestForEstimatedArrivalTime) as! [EstimatedArrivalTime] else {return 0}
        
        if estimatedArrivalTimeData.count == 0 {
            //反向查詢，萬芳->動物園，變成動物園->萬芳
            getEstimatedArrivalTimeData(station2, station2: station1)
        }
        
        if estimatedArrivalTimeData.first?.time != nil {
            return  (estimatedArrivalTimeData.first?.time)!
        }
        
        return 0
    }
    
    func getMRTTransportationFee(station1: String, station2: String) -> NSNumber {
        let managedObjectContext: NSManagedObjectContext? =
            (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
        
        let requestForMRTTransportationFee = NSFetchRequest(entityName: "MRTTransportationFee")
        requestForMRTTransportationFee.fetchBatchSize = 1
        requestForMRTTransportationFee.fetchLimit = 3
        requestForMRTTransportationFee.predicate = NSPredicate(format: "station1 = %@ AND station2 = %@", argumentArray: [station1, station2])
        
        guard let mrtTransportationFee = try? managedObjectContext!.executeFetchRequest(requestForMRTTransportationFee) as! [MRTTransportationFee] else {return 0}
        
        if mrtTransportationFee.count == 0 {
            //反向查詢，萬芳->動物園，變成動物園->萬芳
            getMRTTransportationFee(station2, station2: station1)
        }
        
        if mrtTransportationFee.first?.originalFee != nil {
            return (mrtTransportationFee.first?.originalFee)!
        }
        
        return 0
    }
    
    func showDetailPanel(station1: String, station2: String, time: NSNumber, originalFee: NSNumber){
        mrtDetailPanel.mrtRoute.text = "\(station1) <– –> \(station2)"
        mrtDetailPanel.estimatedArrivalTime.text = "行駛\(time)分鐘"
        mrtDetailPanel.originalFee.text = "票價\(originalFee)元"
        mrtDetailPanel.hidden = false
    }
}







