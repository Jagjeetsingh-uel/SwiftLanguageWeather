//
//  LocationPermissionViewController.swift
//  SwiftWeather
//
//  Created by Jagjeetsingh Labana on 16/11/2024.
//  Copyright © 2024 Jake Lin. All rights reserved.
//

import UIKit
import CoreLocation

class LocationPermissionViewController: UIViewController {

    @IBOutlet weak var viewContainer: UIView!{
        didSet {
            viewContainer.layer.cornerRadius = 8
            viewContainer.layer.shadowColor = UIColor.black.cgColor
            viewContainer.layer.shadowOffset = CGSize(width: 0, height: 1)
            viewContainer.layer.shadowRadius = 5
            viewContainer.layer.shadowOpacity = 0.8
            viewContainer.clipsToBounds = false
        }
    }
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var buttonAllow: UIButton! {
        didSet {
            buttonAllow.layer.borderColor = UIColor.systemBlue.cgColor
            buttonAllow.layer.borderWidth = 2
            buttonAllow.layer.cornerRadius = 8
            buttonAllow.clipsToBounds = true
        }
    }
    @IBOutlet weak var buttonCustomSearch: UIButton! {
        didSet {
            buttonCustomSearch.layer.borderColor = UIColor.black.cgColor
            buttonCustomSearch.layer.borderWidth = 2
            buttonCustomSearch.layer.cornerRadius = 8
            buttonCustomSearch.clipsToBounds = true
        }
    }
    @IBOutlet weak var activityViewIndicator: UIActivityIndicatorView!
    
    // MARK: - Services
     var locationService = LocationService()
     var weatherService: WeatherServiceProtocol?
    var isDirectNavigation = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationService.delegate = self
        weatherService = OpenWeatherMapService()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Auth Status : ",CLLocationManager.authorizationStatus().rawValue)
        if CLLocationManager.authorizationStatus().rawValue == 0 || CLLocationManager.authorizationStatus().rawValue == 2 {
            self.activityViewIndicator.stopAnimating()
            UIView.animate(withDuration: 0.5) {
                self.viewContainer.alpha = 1
            }
        }
    }
    @IBAction func actionAllow(_ sender: Any) {
        isDirectNavigation = false
        locationService.requestLocation()
    }
    
    @IBAction func actionCustomSearch(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "WeatherViewController") as? WeatherViewController {
            vc.directSearch = true
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
}
// MARK: LocationServiceDelegate
extension LocationPermissionViewController: LocationServiceDelegate {
  func locationDidUpdate(_ service: LocationService? = nil, location: CLLocation) {
      weatherService?.retrieveWeatherInfo(location) { (weather, error) -> Void in
      DispatchQueue.main.async(execute: {
        if let unwrappedError = error {
          print(unwrappedError)
                // self.update(unwrappedError)
          return
        }

        guard let unwrappedWeather = weather else {
          return
        }
      //  self.update(unwrappedWeather)
          let storyboard = UIStoryboard(name: "Main", bundle: nil)
          if let vc = storyboard.instantiateViewController(withIdentifier: "WeatherViewController") as? WeatherViewController {
              self.navigationController?.setNavigationBarHidden(true, animated: true)
              self.navigationController?.pushViewController(vc, animated: false)
          }
      })
    }
  }
  
  func locationDidFail(withError error: SWError) {
      //self.update(error)
  }
}
