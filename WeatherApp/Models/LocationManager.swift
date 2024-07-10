//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Anthony on 10/07/24.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate{
    
    var locationManager = CLLocationManager()
    @Published var authorisationStatus: CLAuthorizationStatus?
    @Published var cityName: String = "Unknown Location"
    
    var latitude: Double{
        locationManager.location?.coordinate.latitude ?? 37.32298
    }
    var longitude: Double{
        locationManager.location?.coordinate.longitude ?? -122.032181
    }
    
    override init(){
        super.init()
        locationManager.delegate = self
        fetchCityName()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus{
        case .authorizedWhenInUse:
            //location services available
            authorisationStatus = .authorizedWhenInUse
            locationManager.requestLocation()
            break
            
        case .restricted:
            authorisationStatus = .restricted
            break
            
        case .denied:
            authorisationStatus = .denied
            break
            
        case .notDetermined:
            authorisationStatus = .notDetermined
            manager.requestWhenInUseAuthorization()
            break
            
        default:
            break
            
        }
    }
    
    func fetchCityName() {
            guard let location = locationManager.location else { return }
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
                guard let self = self else { return }
                if let placemark = placemarks?.first, let city = placemark.locality {
                    DispatchQueue.main.async {
                        self.cityName = city
                    }
                }
            }
        }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        fetchCityName()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\(error.localizedDescription)")    }
    
}
