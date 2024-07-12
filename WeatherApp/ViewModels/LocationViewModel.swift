//
//  LocationViewModel.swift
//  WeatherApp
//
//  Created by Anthony on 12/07/24.
//

import Foundation
import Combine
import CoreLocation

@MainActor class LocationViewModel: ObservableObject, LocationManagerDelegate {
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var cityName: String = "Unknown Location"
    @Published var latitude: Double = 37.32298
    @Published var longitude: Double = -122.032181
    
    private var locationManager: LocationManager
    
    init(locationManager: LocationManager = LocationManager()) {
        self.locationManager = locationManager
        self.locationManager.delegate = self
        self.updateAuthorizationStatus()
    }
    
    func didUpdateLocation(latitude: Double, longitude: Double, cityName: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.cityName = cityName
    }
    
    func didFailWithError(error: Error) {
        print("Error fetching location: \(error)")
    }
    
    private func updateAuthorizationStatus() {
        authorizationStatus = locationManager.authorizationStatus
    }
}
