//
//  URL+Extension.swift
//  RxWeather
//
//  Created by minho on 2021/05/30.
//

import Foundation

extension URL {
    static func urlForWeatherAPI(city: String) -> URL? {
        return URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)")
    }
}
