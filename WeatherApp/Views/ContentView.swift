//
//  ContentView.swift
//  WeatherApp
//
//  Created by Anthony on 10/07/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var weatherKitManager = WeatherKitManager()
    
    var body: some View {
        HStack {
            Label(weatherKitManager.temp, systemImage: weatherKitManager.symbol)
        }
        .padding()
        .task {
            await weatherKitManager.getWeather()
        }
    }
}

#Preview {
    ContentView()
}
