//
//  ViewController.swift
//  RxWeather
//
//  Created by minho on 2021/05/29.
//

import RxCocoa
import RxSwift
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tfCityName: UITextField!
    @IBOutlet weak var lbTemperature: UILabel!
    @IBOutlet weak var lbHumidity: UILabel!

    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        tfCityName.rx.value
            .subscribe(onNext: { cityName in
                if let cityName = cityName {
                    if cityName.isEmpty {
                        self.displayWeather(nil)
                    } else {
                        self.fetchWeather(by: cityName)
                    }
                }
            }).disposed(by: disposeBag)
    }

    private func displayWeather(_ weather: Weather?) {
        if let weather = weather {
            lbTemperature.text = "\(String(format: "%.2f", weather.celsius)) ℃"
            lbHumidity.text = "\(weather.humidity) 💧"
        } else {
            lbTemperature.text = "🙈"
            lbHumidity.text = "🚫"
        }
    }

    private func fetchWeather(by city: String) {
        guard let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
              let url = URL.urlForWeatherAPI(city: cityEncoded) else {
            return
        }

        let resouce = Resource<WeatherResult>(url: url)

        URLRequest.load(resource: resouce)
            .observe(on: MainScheduler.instance) // DispatchQueue.main
            .catchAndReturn(WeatherResult.empty)
            .subscribe(onNext: { result in

                print(result)

                let weather = result.main
                self.displayWeather(weather)
            }).disposed(by: disposeBag)
    }
}
