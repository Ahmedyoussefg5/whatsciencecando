//
//  EventsInfoVC.swift
//  WhatScienceCanDo
//
//  Created by Ahmed on 11/5/17.
//  Copyright © 2017 RKAnjel. All rights reserved.
//

import UIKit
import MapKit
import Kingfisher

class EventsInfoVC: BaseViewController {
    lazy var Notifications : UIBarButtonItem = {
        
        let viewFN = NotificationView()
        viewFN.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        let image = UIImage.init(named: "AstraLogo")!.withRenderingMode(.alwaysOriginal)
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        button.setImage(#imageLiteral(resourceName: "AstraLogo"), for: .normal)
        let button1 = UIButton(frame: CGRect(x: 0, y: 20, width: 10, height: 10))
        //NotificationView
        button.addTarget(self, action: #selector(NotifictionFunction), for: .touchUpInside)
        button1.setTitle(String(CountingNotification), for: .normal)
        button1.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button1.titleLabel!.adjustsFontSizeToFitWidth = true
        button1.titleLabel!.baselineAdjustment = .alignCenters
        viewFN.addSubview(button)
        viewFN.addSubview(button1)
        
        // viewFN.backgroundColor = .default
        
        
        // viewFN.backgroundColor = UIColor.yellow
        //     view.NotificationCounter.text = "1"
        
        let Notifications = UIBarButtonItem(customView: viewFN)
        return Notifications
    }();
    @IBOutlet weak var venueLabel:UILabel!
    @IBOutlet weak var startDateLabel:UILabel!
    @IBOutlet weak var endDateLabel:UILabel!
    
    @IBOutlet weak var sessionImageView:UIImageView!
    @IBOutlet weak var mapView:MKMapView!
    
    
    var event:Event!
    let regionRadius: CLLocationDistance = 500

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("event Id" , event.eventName)
        self.navigationItem.setRightBarButtonItems([Notifications], animated: true)

        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .never
        } else {
            // Fallback on earlier versions
        }
        
      //  self.title = self.event.name!
        self.venueLabel.text = event.venue!
        self.startDateLabel.text = event.startDate!
        self.endDateLabel.text = event.endDate!
        
        let url = URL(string: SP_ImageUrl + (event.image!))
        self.sessionImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "pressrelease"), options: [.transition(ImageTransition.fade(1))], progressBlock: { receivedSize, totalSize in
        }, completionHandler: { image, error, cacheType, imageURL in
        })
        
        guard let lat = ((self.event?.lat!)) else {
            return
        }
        guard let long = ((self.event?.long!)) else {
            return
        }
        
        self.centerMapOnLocation(location: (CLLocation(latitude: lat, longitude: long)),title: (self.event?.name)!)

    }
    @objc func NotifictionFunction() {
        print("Notifications")
        //NotificationView
        guard let myVC = self.storyboard?.instantiateViewController(withIdentifier: "NotificationView") else { return }
        
        self.navigationController?.pushViewController(myVC, animated: true)
    }
    override func getData() {
        super.getData()
    }

    func centerMapOnLocation(location: CLLocation,title:String) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        annotation.title = title
        mapView.addAnnotation(annotation)
        mapView.setRegion(coordinateRegion, animated: true)
        
        if location.coordinate.latitude == 0.0 || location.coordinate.longitude == 0.0 {
            self.mapView.isHidden = true
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? EventSessionsVC {
            vc.ID = event.id!
        }else  if let vc = segue.destination as? EvaluateVC {
            vc.eventID = event.id!
        }
    }
}
