//
//  ContentView.swift
//  MyWeatherApp
//
//  Created by alvin joseph valdez on 3/2/21.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
  @State private var location: String = ""
  @State private var forecast: Forecast? = nil
  
  let dateFormatter = DateFormatter()
  
  init() {
    dateFormatter.dateFormat = "E, MMM, d"
  }

  var body: some View {
    NavigationView {
      VStack {
        HStack {
          TextField("Enter Location", text: $location)
            .disableAutocorrection(true)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .autocapitalization(.none)
            
          Button {
            getWeatherForecast(for: location)
          } label: {
            Image(systemName: "magnifyingglass.circle.fill").font(.title3)
          }
        }
        .padding(.horizontal)
        
        if let forecast = forecast {
          List(forecast.daily, id: \.dt) { day in
            VStack(alignment: .leading) {
              Text(dateFormatter.string(from: day.dt))
                .fontWeight(.bold)
              HStack(alignment: .top) {
                Image(systemName: "hourglass")
                  .font(.title)
                  .frame(width: 50, height: 50)
                  .background(
                    RoundedRectangle(cornerRadius: 10)
                      .fill(Color.green)
                  )
                VStack(alignment: .leading) {
                  Text(day.weather[0].description.capitalized)
                  HStack {
                    Text("High: \(day.temp.max, specifier: "%.0f")")
                    Text("Low: \(day.temp.min, specifier: "%.0f")")
                  }
                  HStack {
                    Text("Clouds: \(day.clouds)")
                    Text("POP: \(day.pop)")
                  }                  
                  Text("Humidity: \(day.humidity)")
                }
              }
            }
            
          }
          .listStyle(PlainListStyle())
        } else {
          Spacer()
        }
      }
      .navigationTitle("Mobile Weather")
    }
  }
  
  
  func getWeatherForecast(for location: String) {
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
        ) { (result: Result<Forecast, APIService.APIError>) in
          
          switch result {
          case .success(let forecast):
            self.forecast = forecast
//            for day in forecast.daily {
//              print(dateFormatter.string(from: day.dt))
//              print("  Max: ", day.temp.max)
//              print("  Min: ", day.temp.min)
//              print("  Humidity: ", day.humidity)
//              print("  Description: ", day.weather[0].description)
//              print("  IconURL: ", day.weather[0].weatherIconURL)
//            }
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

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
