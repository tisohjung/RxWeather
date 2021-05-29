//
//  WeatherResult.swift
//  RxWeather
//
//  Created by minho on 2021/05/29.
//

import Foundation

struct WeatherResult {
    let main: Weather
}

struct Weather {
    let temp: Double
    let humidity: Double
}
