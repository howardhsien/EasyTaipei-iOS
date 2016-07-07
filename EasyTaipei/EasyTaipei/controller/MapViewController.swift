//
//  MapViewController.swift
//  EasyTaipei
//
//  Created by howard hsien on 2016/7/5.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController{
    
    //MARK: outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var detailPanel: UIView!
    @IBOutlet weak var detailPanelTitleLabel: UILabel!
    @IBOutlet weak var detailPanelSubtitleLabel: UILabel!
    @IBOutlet weak var detailPanelSideLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var mapNavigateButton: UIButton!
    @IBOutlet weak var markerImageView: UIImageView!
    
    //MARK: helpers
    var locationManager = CLLocationManager()
    var jsonParser = JSONParser.sharedInstance()
    
    var annotationAdded = false
    var dataType :DataType?
    
    //reuse images to save memory
    var toiletIcon : UIImage? = {
        if let image = UIImage(named: "toilet")
        {
            return image.imageWithRenderingMode(.AlwaysTemplate)
        }
        else{ return nil }
    }()
    
    var youbikeIcon : UIImage? = {
        if let image = UIImage(named: "bike")
        {
            return image.imageWithRenderingMode(.AlwaysTemplate)
        }
        else{ return nil }
    }()
    
    
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDetailPanel()
        setupStyle()
        setupMapAndLocationManager()
        setupMapRegion()
        setupActivityIndicator()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if !annotationAdded{
            guard let dataType = dataType else{ return }
            showInfoType(dataType: dataType)
        }

        
    }
    //MARK: Style Setting
    private func bringViewToFront(){
        view.bringSubviewToFront(mapNavigateButton)
        view.bringSubviewToFront(activityIndicatorView)
        
    }
    private func setupActivityIndicator(){
        activityIndicatorView.hidden = true
        activityIndicatorView.hidesWhenStopped = true
    }
    
    private func setupStyle(){
        self.view.bringSubviewToFront(detailPanel)
        markerImageView.image = markerImageView.image?.imageWithRenderingMode(.AlwaysTemplate)
        markerImageView.tintColor = UIColor.esyOffWhiteColor()
    }
    
    private func setupDetailPanel(){
        detailPanel.hidden = true
    }
    
    //MARK: Display Infomation
    func showInfoType(dataType type: DataType){
        activityIndicatorView?.startAnimating()
        jsonParser.request?.cancel()
        jsonParser.getDataWithCompletionHandler(type, completion: {[unowned self] in
            self.dataType = type
            guard let _ = self.mapView else { return }
            self.addAnnotationOnMapview(dataType: type)
            self.activityIndicatorView?.stopAnimating()
            }
        )
    }
    
    func reloadData(){
        guard let dataType = self.dataType else { return }
        showInfoType(dataType: dataType)
    }
    
 
}
//MARK: MapView and LocationManager Method
extension MapViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    //MARK: locationManager
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("didChangeAuthorizationStatus")
        setupMapRegion()
    }
    
    func setupMapAndLocationManager(){
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapNavigateButton.addTarget(self, action: #selector(setupMapRegion), forControlEvents: .TouchUpInside)
    }
    
    //MARK: Method
    func addAnnotationOnMapview(dataType type: DataType){
        mapView.removeAnnotations(mapView.annotations)
        
        switch type {
        case .Toilet:
            if jsonParser.toilets.isEmpty { return }
            for toilet in jsonParser.toilets{
                let annotation = CustomMKPointAnnotation()
                annotation.type = type
                annotation.toilet = toilet
                annotation.updateInfo()
                mapView.addAnnotation(annotation)
            }
        case .Youbike:
            if jsonParser.youbikes.isEmpty { return }
            for youbike in jsonParser.youbikes{
                let annotation = CustomMKPointAnnotation()
                annotation.type = type
                annotation.youbike = youbike
                annotation.updateInfo()
                mapView.addAnnotation(annotation)
            }
        }
        self.annotationAdded = true
    }
    
    func setupMapRegion(){
        let span = MKCoordinateSpanMake(0.006, 0.006)
        if let location = locationManager.location {
            let region = MKCoordinateRegion(center: location.coordinate , span: span)
            
            mapView.setRegion(region, animated: true)
        }
        else{
            let location = mapView.userLocation
            let region = MKCoordinateRegion(center: location.coordinate , span: span)
            
            mapView.setRegion(region, animated: true)
        }
        
    }
    
  
    //MARK: MapView
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? CustomMKPointAnnotation else { return nil}
        var annotationView: CustomAnnotationView?
        let annotationViewDiameter:CGFloat = 35;
        switch annotation.type! {
        case .Toilet:
            let reuseIdentifier = " toiletAnnotationView"  //handle reuse identifier to better manage the memory
            if let view = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier){ annotationView = view as? CustomAnnotationView }
            else {
                annotationView = CustomAnnotationView(frame:CGRectMake(0, 0, annotationViewDiameter, annotationViewDiameter),annotation: annotation, reuseIdentifier: reuseIdentifier)
                if let icon = toiletIcon{
                    annotationView?.setCustomImage(icon)
                }
            }
            
        case .Youbike:
            let reuseIdentifier = " youbikeAnnotationView"
            if let view = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier){ annotationView = view as? CustomAnnotationView }
            else {
                annotationView = CustomAnnotationView(frame:CGRectMake(0, 0, annotationViewDiameter, annotationViewDiameter),annotation: annotation, reuseIdentifier: reuseIdentifier)
                if let icon = youbikeIcon{
                    annotationView?.setCustomImage(icon)
                }
            }
            
        }
        annotationView?.canShowCallout = true
        
        return annotationView
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        if let annotation = view.annotation as? CustomMKPointAnnotation {
            //            view.backgroundColor = UIColor.mrLightBlueColor()
            detailPanel.hidden = false
            let annotationLocation = CLLocation( latitude:annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
            if let userLocation = locationManager.location{
                let distance = annotationLocation.distanceFromLocation(userLocation)
                let distanceInTime  = distance / (3 / 3.6 * 60)  //distance in time is not accurate now
                let roundDistanceInTime = ceil(distanceInTime)
                detailPanelSideLabel.text = String(format: "%0.0f min(s)", roundDistanceInTime)
            }
            detailPanelTitleLabel.text = annotation.title
            detailPanelSubtitleLabel.text = annotation.address
        }
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        if view.annotation is MKUserLocation{
            return
        }
        detailPanel.hidden = true
        view.backgroundColor = UIColor.whiteColor()
    }
    
    
    
}


