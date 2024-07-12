//
//  ContentView.swift
//  WeatherApp
//
//  Created by Anthony on 10/07/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var weatherViewModel = WeatherViewModel()
    @StateObject var locationViewModel = LocationViewModel()
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect() // Update every 60 seconds
    
    var body: some View {
        VStack(alignment: .leading) {
            if let authorizationStatus = locationViewModel.authorizationStatus, authorizationStatus == .authorizedWhenInUse {
                Text("You're in \(locationViewModel.cityName).")
                    .font(.headline)
                
                Text("Longitude: \(locationViewModel.longitude) | Latitude: \(locationViewModel.latitude)")
                    .font(.headline)
                    .padding(.bottom)
                
                Text(weatherViewModel.temperature)
                    .font(.largeTitle)
                
                Text("Humidity: \(weatherViewModel.humidity)")
                    .font(.headline)
            } else {
                Text("Error loading location")
                    .padding()
            }
        }
        .padding()
        .task {
            await weatherViewModel.fetchWeather(latitude: locationViewModel.latitude, longitude: locationViewModel.longitude)
        }
        .onReceive(timer) { _ in
            Task {
                await weatherViewModel.fetchWeather(latitude: locationViewModel.latitude, longitude: locationViewModel.longitude)
            }
        }
    }
}

#Preview {
    ContentView()
}
