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

        self.tfCityName.rx.controlEvent(UIControl.Event.editingDidEndOnExit)
            .asObservable()
            .map({ self.tfCityName.text })
            .subscribe(onNext: { city in
                if let city = city {
                    if city.isEmpty {
                        self.displayWeather(nil)
                    } else {
                        self.fetchWeather(by: city)
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

        let search = URLRequest.load(resource: resouce)
            .observe(on: MainScheduler.instance)
            .catch({ error in
                print(error.localizedDescription)
                return Observable.just(WeatherResult.empty)
            })
            .asDriver(onErrorJustReturn: WeatherResult.empty)

        search.map({ "\($0.main.celsius) ℃" })
            .drive(self.lbTemperature.rx.text)
            .disposed(by: disposeBag)
        search.map({ "\($0.main.humidity) 💧" })
            .drive(self.lbHumidity.rx.text)
            .disposed(by: disposeBag)
    }
}
