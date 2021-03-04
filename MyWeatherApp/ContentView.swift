//
//  ContentView.swift
//  MyWeatherApp
//
//  Created by alvin joseph valdez on 3/2/21.
//

import SwiftUI

struct ContentView: View {
  @StateObject private var forecastsListVM = ForecastListViewModel()

  var body: some View {
    NavigationView {
      VStack {
        Picker(selection: $forecastsListVM.system, label: Text("System")) {
            Text("°C").tag(0)
            Text("°F").tag(1)
        }
        .pickerStyle(SegmentedPickerStyle())
        .frame(width: 100)
        .padding(.vertical)
                
        HStack {
          TextField("Enter Location", text: $forecastsListVM.location)
            .disableAutocorrection(true)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .autocapitalization(.none)

          Button {
            forecastsListVM.getWeatherForecast()
          } label: {
            Image(systemName: "magnifyingglass.circle.fill").font(.title3)
          }
        }
        .padding(.horizontal)

        List(forecastsListVM.forecasts, id: \.day) { day in
          VStack(alignment: .leading) {
            Text(day.day)
              .fontWeight(.bold)
            HStack(alignment: .center) {
              Image(systemName: "hourglass")
                .font(.title)
                .frame(width: 50, height: 50)
                .background(
                  RoundedRectangle(cornerRadius: 10)
                    .fill(Color.green)
                )
              VStack(alignment: .leading) {
                Text(day.overview)
                HStack {
                  Text(day.high)
                  Text(day.low)
                }
                HStack {
                  Text(day.clouds)
                  Text(day.pop)
                }
                Text(day.humidity)
              }
            }
          }
        }
        .listStyle(PlainListStyle())
      }
      .navigationTitle("Mobile Weather")
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
