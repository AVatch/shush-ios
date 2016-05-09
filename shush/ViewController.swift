//
//  ViewController.swift
//  shush
//
//  Created by Adrian Vatchinsky on 4/28/16.
//  Copyright © 2016 Adrian Vatchinsky. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    // MARK: Properties
    
    var locationManager: CLLocationManager?
    var lastProximity: CLProximity?
    @IBOutlet weak var proximityLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!

    
    
    // MARK: Notifications
    
    func sendLocalNotificationWithMessage(message: String!) {
        let notification:UILocalNotification = UILocalNotification()
        notification.alertBody = message
        notification.category = "BEACON_MONITORING"
        notification.userInfo = ["TOGGLE_DND": true]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    
    // MARK: Beacons
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        // ENTER REGION
        manager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
        manager.startUpdatingLocation()
        
        print("You entered the region")
        regionLabel.text = "In quite region"
        sendLocalNotificationWithMessage("You entered the region, enable do not disturb")
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        // EXIT REGION
        manager.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
        manager.stopUpdatingLocation()
        
        print("You exited the region")
        regionLabel.text = "Outside the quite region"
        sendLocalNotificationWithMessage("You left the region, disable do not disturb")
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        // RANGING
        
//        print("didRangeBeacons()")
        print("Ranging: " + (randomStringWithLength(10) as String))

        var message:String = ""
        
        if(beacons.count > 0) {
            let nearestBeacon:CLBeacon = beacons[0] as CLBeacon
            
            
            // ensure we only send signal with new beacon
            if(nearestBeacon.proximity == lastProximity ||
                nearestBeacon.proximity == CLProximity.Unknown) {
                return;
            }
            lastProximity = nearestBeacon.proximity;
            
            
            
            switch nearestBeacon.proximity {
            case CLProximity.Far:
                message = "You are far away from the beacon"
            case CLProximity.Near:
                message = "You are near the beacon"
            case CLProximity.Immediate:
                message = "You are in the immediate proximity of the beacon"
            case CLProximity.Unknown:
                return
            }
        } else {
            message = "No beacons are nearby"
        }
        
        proximityLabel.text = message
        if( message == "No beacons are nearby"){
            regionLabel.text = "Outside the quite region"
        }else{
            regionLabel.text = "In quite region"
        }
        
        
        
//        print(message)
//        sendLocalNotificationWithMessage(message)
        
    }
    
    
    // MARK: viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // Define the region to monitor
        let uuidString = "B9407F30-F5F8-466E-AFF9-25556B57FE6D"
        let beaconIdentifier = "estimotes"
        let beaconUUID:NSUUID = NSUUID(UUIDString: uuidString)!
        let beaconRegion:CLBeaconRegion = CLBeaconRegion(proximityUUID: beaconUUID, identifier: beaconIdentifier)
        
        
        // Setup the locationManager
        locationManager = CLLocationManager()
        if(locationManager!.respondsToSelector(#selector(CLLocationManager.requestAlwaysAuthorization))) {
            locationManager!.requestAlwaysAuthorization()
        }
        locationManager!.delegate = self
        locationManager!.pausesLocationUpdatesAutomatically = false
        
        // Start monitoring and ranging
        locationManager!.startMonitoringForRegion(beaconRegion)
        locationManager!.startRangingBeaconsInRegion(beaconRegion)
        locationManager!.startUpdatingLocation()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Other
    func randomStringWithLength (len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        var randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            var length = UInt32 (letters.length)
            var rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString
    }


}

