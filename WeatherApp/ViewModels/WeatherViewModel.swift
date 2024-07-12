//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Anthony on 12/07/24.
//

import Foundation
import SwiftUI

@MainActor class WeatherViewModel: ObservableObject {
    @Published var weather: WeatherModel?
    private let weatherService: WeatherServiceProtocol
    
    init(weatherService: WeatherServiceProtocol = WeatherService()) {
        self.weatherService = weatherService
    }
    
    func fetchWeather(latitude: Double, longitude: Double) async {
        do {
            self.weather = try await weatherService.getWeather(latitude: latitude, longitude: longitude)
        } catch {
            print("Error fetching weather: \(error)")
        }
    }
    
    var temperature: String {
        guard let temp = weather?.temperature else {
            return "Connecting to Apple Weather Servers"
        }
        return "\(Int(temp))°"
    }
    
    var humidity: String {
        guard let humidity = weather?.humidity else {
            return "N/A"
        }
        return "\(Int(humidity * 100))%"
    }
    
    var symbol: String {
        weather?.symbolName ?? "xmark"
    }
}
