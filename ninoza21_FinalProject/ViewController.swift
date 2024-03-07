//
//  ViewController.swift
//  ninoza21_FinalProject
//
//  Created by Nino Nozadze on 03.02.24.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, MainLocationManagerDelegate {
    
    let locationManager = LocationManager.shared

    let tabBar = UITabBarController()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.mainDelegate = self
        locationManager.requestLocationFunction()
    }
    
    func createTabBar() {
        let TodaysForecastVC = TodaysForecastVC()
        let FiveDaysForecastVC = FiveDaysForecastVC()
        
        let TodaysForecastNC = UINavigationController(rootViewController: TodaysForecastVC)
        let FiveDaysForecastNC = UINavigationController(rootViewController: FiveDaysForecastVC)
        
        TodaysForecastNC.tabBarItem = UITabBarItem(title: "Today", image: UIImage(named: "tab_today"), tag: 0)
        FiveDaysForecastNC.tabBarItem = UITabBarItem(title: "Forecast", image: UIImage(named: "tab_forecast"), tag: 1)
        
        tabBar.tabBar.barTintColor = .blue
        
        tabBar.viewControllers = [TodaysForecastNC, FiveDaysForecastNC]
                
        addChild(tabBar)
        view.addSubview(tabBar.view)
        tabBar.didMove(toParent: self)
    }
    
    func authorizationDenied() {
        let errorAlert = UIAlertController(title: "Error Loading Data", message: "Location authorization denied", preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(errorAlert, animated: true, completion: nil)
        
        view.backgroundColor = .systemCyan
        let deniedPage = DeniedPage()
        
        navigationItem.leftBarButtonItem?.isEnabled = false
        
        view.addSubview(deniedPage)
        deniedPage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            deniedPage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            deniedPage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            deniedPage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            deniedPage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}

