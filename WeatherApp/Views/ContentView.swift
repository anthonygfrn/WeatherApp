//
//  ContentView.swift
//  WeatherApp
//
//  Created by Anthony on 10/07/24.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    @ObservedObject var weatherKitManager = WeatherKitManager()
    @StateObject var locationManager = LocationManager()
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect() // Update every 60 seconds
    
    var body: some View {
        if locationManager.authorisationStatus == .authorizedWhenInUse {
            // create your view
            VStack {
                Text("You're in \(locationManager.cityName)")
                    .font(.largeTitle)
                    .padding(.bottom, 10)
                
                Label(weatherKitManager.temp, systemImage: weatherKitManager.symbol)
            }
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
        }
    }
}

#Preview {
    ContentView()
}
