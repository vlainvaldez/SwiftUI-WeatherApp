//
//  ForecastListViewModel.swift
//  MyWeatherApp
//
//  Created by alvin joseph valdez on 3/3/21.
//

import Foundation
import CoreLocation
import SwiftUI

class ForecastListViewModel: ObservableObject {
  @Published var forecasts: [ForecastViewModel] = []
  @AppStorage("location") var location: String = ""
  @AppStorage("system") var system: Int = 0 {
    didSet {
      for i in 0..<forecasts.count {
        forecasts[i].system = system
      }
    }
  }
  
  init() {
    if !location.isEmpty {
      getWeatherForecast()
    }
  }
  
  func getWeatherForecast() {
    let apiService = APIService.shared

    CLGeocoder().geocodeAddressString(location) { (placeMarks, error) in
      if let error = error {
        print(error.localizedDescription)
      }
      
      if let lat = placeMarks?.first?.location?.coordinate.latitude,
         let long = placeMarks?.first?.location?.coordinate.longitude {
        
        apiService.getJSON(
          urlString: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&exclude=hourly,current,minutely,hourly&appid=8e7ae45a3781f63c9dfb8d2c93b812fa",
          dateDecodingStrategy: .secondsSince1970
        ) { [weak self] (result: Result<Forecast, APIService.APIError>) in
          guard let self = self else { return }
          
          switch result {
          case .success(let forecast):
            DispatchQueue.main.async {
              self.forecasts = forecast.daily.map { ForecastViewModel(forecast: $0, system: self.system) }
            }
          case .failure(let apiError):
            switch apiError {
            case .error(let errorString):
              print(errorString)
            }
          }
        }        
      }
    }
  }
}
