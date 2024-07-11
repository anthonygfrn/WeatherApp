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
    
    func getWeather(latitude: Double, longitude: Double){
        async {
            do {
                weather = try await Task.detached(priority: .userInitiated){
                    return try await WeatherService.shared.weather(for:.init(latitude: latitude, longitude: longitude))
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
            guard let temp = weather?.currentWeather.temperature else {
                return "Connecting to Apple Weather Servers"
            }
            let convertedTemp = Int(temp.converted(to: .celsius).value)
            return "\(convertedTemp)"
    }
    
    var humidity: String {
            guard let humidity = weather?.currentWeather.humidity else {
                return "N/A"
            }
            let convertedHumidity = Int(humidity * 100)
            return "\(convertedHumidity)%"
    }
}
