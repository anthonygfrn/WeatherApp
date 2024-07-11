//
//  ContentView.swift
//  WeatherApp
//
//  Created by Anthony on 10/07/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var weatherKitManager = WeatherKitManager()
    @StateObject var locationManager = LocationManager()
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect() // Update every 60 seconds
    
    var body: some View {
        if locationManager.authorisationStatus == .authorizedWhenInUse {
            // create your view
            VStack(alignment: .leading) {
                Text("You're in \(locationManager.cityName).")
                    .font(.headline)
                
                Text("Longitude: \(locationManager.longitude) | Latitude: \(locationManager.latitude) ")
                    .font(.headline)
                    .padding(.bottom)
                
                Text("\(weatherKitManager.temp)°")
                    .font(.largeTitle)
                
                Text("Humidity: \(weatherKitManager.humidity)")
                    .font(.headline)
            }
            .padding()
            .task {
                await weatherKitManager.getWeather(latitude: locationManager.latitude, longitude: locationManager.longitude)
            }
            .onReceive(timer) { _ in
                Task {
                await weatherKitManager.getWeather(latitude: locationManager.latitude, longitude: locationManager.longitude)
            }
            }
        } else {
            // Create your alternate view
            Text("Error loading location")
                .padding()
        }
    }
}

#Preview {
    ContentView()
}
