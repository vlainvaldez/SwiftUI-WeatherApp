//
//  ForecastViewModel.swift
//  MyWeatherApp
//
//  Created by alvin joseph valdez on 3/3/21.
//

import Foundation

struct ForecastViewModel {
  let forecast: Forecast.Daily
  
  private static var dateFormatter: DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "E, MMM, d"
    return dateFormatter
  }
  
  private static var numberFormatter: NumberFormatter {
    let numberFormatter = NumberFormatter()
    numberFormatter.maximumFractionDigits = 0
    return numberFormatter
  }
  
  private static var numberFormatter2: NumberFormatter {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .percent
    return numberFormatter
  }
  
  var day: String {
    Self.dateFormatter.string(from: forecast.dt)
  }
  
  var overview: String {
    forecast.weather[0].description.capitalized
  }
  
  var high: String {
    "H: \(Self.numberFormatter.string(from: NSNumber(value: forecast.temp.max)) ?? "0" )°"
  }
  
  var low: String {
    "L: \(Self.numberFormatter.string(from: NSNumber(value: forecast.temp.min)) ?? "0" )°"
  }
  
  var pop: String {
    "💧 \(Self.numberFormatter2.string(from: NSNumber(value: forecast.pop)) ?? "0%")"
  }
  
  var clouds: String {
    "☁️ \(forecast.clouds)%"
  }
  
  var humidity: String {
    "Humidity: \(forecast.humidity)%"
  }
  
}
  
