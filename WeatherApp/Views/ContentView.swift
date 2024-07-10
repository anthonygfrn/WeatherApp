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
    
    var body: some View {
        
        if locationManager.authorisationStatus == .authorizedWhenInUse {
            
            // create your view
            VStack{
                Label(weatherKitManager.temp, systemImage: weatherKitManager.symbol)
                
                Text(locationManager)
            }
                .task {
                    await weatherKitManager.getWeather(latitude: locationManager.latitude, longitude: locationManager.longitude)
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
