//
//  MRTViewController.swift
//  EasyTaipei
//
//  Created by howard hsien on 2016/7/5.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit

class MRTViewController: UIViewController,UIScrollViewDelegate {
//ScrollView image viewer
    
    lazy var scrollView:UIScrollView = {
        let sv = UIScrollView(frame: self.view.bounds)
        sv.delegate = self
        return sv
    }()
    
    lazy var imageView:UIImageView = {
        if let image = UIImage(named: "mrtMap"){
            let imgView = UIImageView(image: image)
            let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
            if let tabHeight = self.tabBarController?.tabBar.frame.height,
                navHeight = self.navigationController?.navigationBar.frame.height
            
            {
                imgView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height  - tabHeight - navHeight - statusBarHeight)
            }
            else{
                imgView.frame = self.view.frame
            }
            imgView.contentMode = .ScaleToFill
            return imgView
        }
        else{
            return UIImageView()
        }
    }()
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        setupScrollView()
        setZoomScale()
        setupGestureRecognizer()
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        TrackingManager.log(event:classDebugInfo+#function)
    }
    
    //MARK: ScrollView
    private func setupScrollView(){
        scrollView.addSubview(imageView)
        scrollView.maximumZoomScale = 4.0
        scrollView.minimumZoomScale = 1.0
        scrollView.contentSize = imageView.frame.size
    }
    
    //handle the zooming
    private func setZoomScale() {
        let imageViewSize = imageView.bounds.size
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
        return imageView
    }

}

extension UIScrollView {
    
    func zoomToPoint( zoomPoint: CGPoint, withScale scale:CGFloat, animated :Bool)
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
