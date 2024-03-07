//
//  LocationManager.swift
//  ninoza21_FinalProject
//
//  Created by Nino Nozadze on 05.02.24.
//

import Foundation
import CoreLocation
import UIKit

protocol MainLocationManagerDelegate: AnyObject {
    func authorizationDenied()
    func createTabBar()
}

protocol TodayLocationManagerDelegate: AnyObject {
    func todayLocationManager(_ manager: LocationManager, didUpdateLocation location: CLLocation)
}

protocol FiveDaysLocationManagerDelegate: AnyObject {
    func forecastLocationManager(_ manager: LocationManager, didUpdateLocation location: CLLocation)
}


class LocationManager: NSObject, CLLocationManagerDelegate {
    
    weak var mainDelegate: MainLocationManagerDelegate?
    weak var todayDelegate: TodayLocationManagerDelegate?
    weak var fiveDaysDelegate: FiveDaysLocationManagerDelegate?
    
    static let shared = LocationManager()
    private var locationManager: CLLocationManager
    var currentLocation: CLLocation?
    
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocationFunction() {
        self.locationManager.requestLocation()
    }
    
    func startUpdatingLocationFunction() {
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        self.currentLocation = newLocation
        self.todayDelegate?.todayLocationManager(self, didUpdateLocation: newLocation)
        self.fiveDaysDelegate?.forecastLocationManager(self, didUpdateLocation: newLocation)
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch manager.authorizationStatus {
        case .restricted, .denied:
            print("Denied")
            self.mainDelegate?.authorizationDenied()
        case .authorizedWhenInUse, .authorizedAlways:
            print("Granted")
            self.mainDelegate?.createTabBar()
            self.locationManager.startUpdatingLocation()
        case .notDetermined:
            print("not Determined")
        @unknown default:
            fatalError("default")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
