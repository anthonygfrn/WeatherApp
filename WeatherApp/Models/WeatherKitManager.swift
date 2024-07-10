//
//  WeatherKitManager.swift
//  WeatherApp
//
//  Created by Anthony on 10/07/24.
//

import Foundation
import WeatherKit

@MainActor class WeatherKitManager: ObservableObject {
    @Published var weather:Weather?
    
    func getWeather(){
        async {
            do {
                weather = try await Task.detached(priority: .userInitiated){
                    return try await WeatherService.shared.weather(for:.init(latitude: 37.322998, longitude: -122.032181)) // for Apple park
                }.value
            } catch {
                fatalError("\(error)")
            }
        }
    }
    
    var symbol: String {
        weather?.currentWeather.symbolName ?? "xmark"
    }
    
    var temp: String {
        let temp = weather?.currentWeather.temperature
        let convertedTemp = temp?.converted(to: .celsius).description
        return convertedTemp ?? "Connecting to Apple Weather Servers"
    }
}
