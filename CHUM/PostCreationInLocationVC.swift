//
//  PostCreationInLocationVC.swift
//  CHUM
//
//  Created by Andrey Mikhaylov on 19/04/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

import UIKit
import PureLayout
import GoogleMaps
import Crashlytics
import MBProgressHUD

class PostCreationInLocationVC: UIViewController, CHMPostProtocol {
    
    //MARK:property
    
    let mapView = CHMMapView(forAutoLayout:())
    var post:CHMPost!
    
    //MARK: PostProtocol
    
    func configureWithPost(post: CHMPost!) {
        self.post = post
    }
    
    //MARK: lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        startUpdating()
    }
    
    override func viewDidAppear(animated: Bool) {
         super.viewDidAppear(animated)
        CHMNotificationCenter.shared().canShow = false
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        CHMNotificationCenter.shared().canShow = true
    }
    
    //MARK: ui
    
    private func configureUI() {
        setCustomBackButton()
        configureDoneButton()
        configureMap()
        configureSlider()
        configureNavigationBar()
    }
    
    private func configureDoneButton() {
        let button = addRightButtonWithName("confirmIcon")
        button.addTarget(self,
                         action: #selector(confirmAction(_:)),
                         forControlEvents: .TouchUpInside)
    }
    
    private func configureSlider() {
        mapView.slider.addTarget(self, action: #selector(PostCreationInLocationVC.sliderValueChanged(_:)), forControlEvents: .ValueChanged)
        
        let user = CHMCurrentUserManager.shared().user
        let maxMeters = user.maxMeterCount
        
        if let mm = maxMeters {
            mapView.slider.maximumValue = Float(mm)
        }
        sliderValueChanged(mapView.slider)
    }
    
    private func configureMap() {
        view.addSubview(mapView)
        mapView.autoPinEdgesToSuperviewEdges()
    }
    
    private func configureNavigationBar() {
        let img = UIImage(named: "placeChooserIcon")
        let iv = UIImageView(image: img)
        navigationItem.titleView = iv
    }
    
    //MARK: map
    
    private func updateMap(withCoordinate coordinate:CLLocation?, zoom:Float?) {
        var c = coordinate
        var z = zoom
        if c == nil {
            c = getCurrentLocation()
        }
        if z == nil {
            z = getCurrentZoom()
        }
        if let z = z, let c = c {
            let cameraUpdate = GMSCameraUpdate.setTarget(c.coordinate,zoom:z)
            mapView.mapView_.animateWithCameraUpdate(cameraUpdate)
        }
        
    }
    
    private func getCurrentZoom() -> Float {
        let count = UIScreen.mainScreen().bounds.size.width - 40
        let coordinate = mapView.mapView_.camera.target
        let meters = 2 * mapView.slider.value
        let zoom = GMSCameraPosition.zoomAtCoordinate(coordinate, forMeters: Double(meters), perPoints: count)
        
        return zoom
    }
    
    private func getCurrentLocation() -> CLLocation {
        let c = mapView.mapView_.camera.target
        let coordinate = CLLocation(latitude: c.latitude, longitude: c.longitude)
        
        return coordinate
    }
    
    //MARK: updating
    
    func startUpdating() {
        CHMLocationManager.shared().loadLocationSubscibe { (location, err) in
            if let l = location {
                self.updateMap(withCoordinate: l, zoom: nil)
            }
        }
    }
    
    //MARK: handlers
    
    @objc(sliderValueChanged:)
    private func sliderValueChanged(sender:UISlider?) {
        let zoom = getCurrentZoom()
        updateMap(withCoordinate: nil, zoom: zoom)
    }
    
    //MARK: upload
    
    @objc(confirmAction:)
    private func confirmAction(sender:AnyObject?) {
        uploadPost()
    }
    
    func uploadPost() {
        Answers.logCustomEventWithName("creating_in_current_location", customAttributes: nil)
        post.radius = NSNumber(float: mapView.slider.value)
        let postLoader = PostUploader(viewController: self, post: post)
        postLoader.startUploading()
        
        if let l = CHMLocationManager.shared().lastCoordinate {
            postLoader.updatePostLocation(l)
            postLoader.uploadPost()
        } else {
            CHMLocationManager.shared().loadLocationCompletion({ (loc, err) in
                if let l = loc {
                    postLoader.updatePostLocation(l)
                    postLoader.uploadPost()
                } else {
                    self.showWarningWithText("Ошибка геолокации")
                    postLoader.finishUploading()
                }
            })
        }
    }
}
