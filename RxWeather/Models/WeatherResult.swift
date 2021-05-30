//
//  WeatherResult.swift
//  RxWeather
//
//  Created by minho on 2021/05/29.
//

import Foundation

struct WeatherResult: Decodable {
    let main: Weather
}

struct Weather: Decodable {
    let temp: Double
    let humidity: Double
}
extension Weather {
    var celsius: Double { return temp - 273.15 }
}

extension WeatherResult {
    static var empty: WeatherResult {
        return WeatherResult(main: Weather(temp: 0.0, humidity: 0.0))
    }
}
