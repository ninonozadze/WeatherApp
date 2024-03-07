//
//  TodaysForecastVC.swift
//  ninoza21_FinalProject
//
//  Created by Nino Nozadze on 03.02.24.
//

import UIKit
import CoreLocation

class TodaysForecastVC: UIViewController, ErrorPageDelegate, TodayLocationManagerDelegate {
    
    private let service = Service()
    
    let todayLocationManager = LocationManager.shared
    
    let weatherPage = UIView()
    let loadingPage = LoadingPage()
    let errorPage = ErrorPage()
    
    let colorLine = ColorLine()
    
    let mainStackView = UIStackView()
    
    let upperView = UIView()
    let lowerView = UIView()
    
    let upperStack = UIStackView()
    let littleView = UIView()
    let littleStack = UIStackView()
    
    let largeImage = UIImageView()
    let city = UILabel()
    let weather = UILabel()
    
    let horizontalSeparator = UIView()
    let verticalSeparator = UIView()
        
    let weatherInfo = UIStackView()
    
    let upperInfo = UIStackView()
    let lowerInfo = UIStackView()
    
    let cloudPercentage = InfoDetail(name: "raining")
    let humidity = InfoDetail(name: "drop")
    let pressure = InfoDetail(name: "celsius")
    let windSpeed = InfoDetail(name: "wind")
    let windDirection = InfoDetail(name: "compass")
    
    var portraitLayout = [NSLayoutConstraint]()
    var landscapeLayout = [NSLayoutConstraint]()
    
    var currentWeather: String = ""
    
    var rightBarButtonItem: UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white

        configureNavigationBar()
        configureErrorPage()
        configureWeatherPage()
        configureLoadingPage()
        
        generateLocation()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateOrientationChange()
    }

    func configureNavigationBar() {
        navigationItem.title = "Today"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshForecast))
        rightBarButtonItem = UIBarButtonItem(title: "", image: UIImage(systemName: "square.and.arrow.up"), target: self, action: #selector(shareForecast))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func refreshForecast() {
        todayLocationManager.startUpdatingLocationFunction()
    }
    
    @objc func shareForecast() {
        let shareViewController = UIActivityViewController(activityItems: [currentWeather], applicationActivities: nil)

        if let shareController = shareViewController.popoverPresentationController {
            shareController.barButtonItem = navigationItem.rightBarButtonItem
        }
        present(shareViewController, animated: true, completion: nil)
    }
    
    func configureWeatherPage() {
        view.addSubview(weatherPage)
        weatherPage.backgroundColor = .white
        
        weatherPageConstraints()
        configureColorLine()
        configureMainStackView()
    }
    
    func weatherPageConstraints() {
        weatherPage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherPage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            weatherPage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            weatherPage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            weatherPage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func configureColorLine() {
        weatherPage.addSubview(colorLine)
        colorLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colorLine.heightAnchor.constraint(equalToConstant: 1.5),
            colorLine.topAnchor.constraint(equalTo: weatherPage.topAnchor),
            colorLine.leadingAnchor.constraint(equalTo: weatherPage.leadingAnchor),
            colorLine.trailingAnchor.constraint(equalTo: weatherPage.trailingAnchor)
        ])
    }
    
    func configureMainStackView() {
        weatherPage.addSubview(mainStackView)
        mainStackViewConstraints()
        
        mainStackView.addArrangedSubview(upperView)
        mainStackView.addArrangedSubview(lowerView)

        mainStackView.axis = .vertical
        mainStackView.distribution = .fillEqually
        
        configureUpperView()
        configureLowerView()

    }
    
    func mainStackViewConstraints() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: colorLine.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: weatherPage.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: weatherPage.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: weatherPage.bottomAnchor)
        ])
    }

    func updateOrientationChange() {
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            mainStackView.axis = .horizontal
            NSLayoutConstraint.deactivate(portraitLayout)
            NSLayoutConstraint.activate(landscapeLayout)
            
        } else if UIDevice.current.orientation == .portrait || UIDevice.current.orientation == .portraitUpsideDown {
            mainStackView.axis = .vertical
            NSLayoutConstraint.deactivate(landscapeLayout)
            NSLayoutConstraint.activate(portraitLayout)
        }
    }
    
    func configureUpperView() {
        upperView.addSubview(upperStack)
        upperStackConstraints()
        
        configureUpperStack()
    }
    
    func configureUpperStack() {
        upperStack.axis = .vertical
        upperStack.distribution = .fillEqually
        upperStack.alignment = .center

        upperStack.addArrangedSubview(largeImage)
        upperStack.addArrangedSubview(littleView)
        
        configureLittleStack()
        configureUpperStackContent()
    }
    func configureLittleStack() {
        littleView.addSubview(littleStack)
        littleStackConstraints()
        
        littleStack.axis = .vertical
        littleStack.distribution = .fillEqually
        littleStack.alignment = .center
        
        littleStack.addArrangedSubview(city)
        littleStack.addArrangedSubview(weather)
    }
    
    func configureUpperStackContent() {
        largeImage.contentMode = .scaleAspectFill
        
        city.textColor = .darkGray
        city.font = UIFont.systemFont(ofSize: 25)
        city.textAlignment = .center

        weather.textColor = .systemBlue
        weather.font = UIFont.systemFont(ofSize: 30)
        weather.textAlignment = .center
    }
    
    func upperStackConstraints() {
        upperStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            upperStack.heightAnchor.constraint(equalTo: upperView.heightAnchor, multiplier: 0.7),
            upperStack.widthAnchor.constraint(equalTo: upperView.widthAnchor),
            upperStack.centerXAnchor.constraint(equalTo: upperView.centerXAnchor),
            upperStack.centerYAnchor.constraint(equalTo: upperView.centerYAnchor)
        ])
    }
    
    func littleStackConstraints() {
        littleStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            littleStack.heightAnchor.constraint(equalTo: littleView.heightAnchor, multiplier: 0.8),
            littleStack.widthAnchor.constraint(equalTo: littleView.widthAnchor),
            littleStack.centerXAnchor.constraint(equalTo: littleView.centerXAnchor),
            littleStack.bottomAnchor.constraint(equalTo: littleView.bottomAnchor)
        ])
    }
    
    func configureLowerView() {
        lowerView.addSubview(horizontalSeparator)
        lowerView.addSubview(verticalSeparator)
        lowerView.addSubview(weatherInfo)
        
        horizontalSeparator.backgroundColor = .systemGray
        verticalSeparator.backgroundColor = .systemGray
        
        configureWeatherInfo()
        lowerViewConstraints()
        NSLayoutConstraint.activate(portraitLayout)
    }
    
    func configureWeatherInfo() {
        weatherInfo.addArrangedSubview(upperInfo)
        weatherInfo.addArrangedSubview(lowerInfo)
        
        weatherInfo.axis = .vertical
        weatherInfo.distribution = .fillEqually
        weatherInfo.alignment = .center
        
        configureUpperInfo()
        configureLowerInfo()
    }
    
    func configureUpperInfo() {
        upperInfo.axis = .horizontal
        upperInfo.distribution = .fillEqually
        upperInfo.alignment = .center
        
        upperInfo.addArrangedSubview(cloudPercentage)
        upperInfo.addArrangedSubview(humidity)
        upperInfo.addArrangedSubview(pressure)
    }
    
    func configureLowerInfo() {
        lowerInfo.axis = .horizontal
        lowerInfo.distribution = .fillEqually
        lowerInfo.alignment = .center
        
        lowerInfo.addArrangedSubview(windSpeed)
        lowerInfo.addArrangedSubview(windDirection)
        
        lowerInfo.widthAnchor.constraint(equalTo: weatherInfo.widthAnchor, multiplier: 0.8).isActive = true
    }
    
    func lowerViewConstraints() {
        horizontalSeparator.translatesAutoresizingMaskIntoConstraints = false
        verticalSeparator.translatesAutoresizingMaskIntoConstraints = false
        weatherInfo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherInfo.heightAnchor.constraint(equalTo: lowerView.heightAnchor, multiplier: 0.6),
            weatherInfo.widthAnchor.constraint(equalTo: lowerView.widthAnchor, multiplier: 0.8),
            weatherInfo.centerXAnchor.constraint(equalTo: lowerView.centerXAnchor),
            weatherInfo.centerYAnchor.constraint(equalTo: lowerView.centerYAnchor),
        ])
        
        configureOrientationConstraints()
    }
    
    func configureOrientationConstraints() {
        portraitLayout.append(horizontalSeparator.heightAnchor.constraint(equalToConstant: 1))
        portraitLayout.append(horizontalSeparator.widthAnchor.constraint(equalTo: lowerView.widthAnchor, multiplier: 0.4))
        portraitLayout.append(horizontalSeparator.topAnchor.constraint(equalTo: lowerView.topAnchor))
        portraitLayout.append(horizontalSeparator.centerXAnchor.constraint(equalTo: lowerView.centerXAnchor))

        landscapeLayout.append(verticalSeparator.heightAnchor.constraint(equalTo: lowerView.heightAnchor, multiplier: 0.4))
        landscapeLayout.append(verticalSeparator.widthAnchor.constraint(equalToConstant: 1.0))
        landscapeLayout.append(verticalSeparator.leadingAnchor.constraint(equalTo: lowerView.leadingAnchor))
        landscapeLayout.append(verticalSeparator.centerYAnchor.constraint(equalTo: lowerView.centerYAnchor))
    }

    
    func configureLoadingPage() {
        weatherPage.isHidden = true
        view.addSubview(loadingPage)
        loadingPageConstraints()
    }
    
    func loadingPageConstraints() {
        loadingPage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingPage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loadingPage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            loadingPage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            loadingPage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func configureErrorPage() {
        weatherPage.isHidden = true
        view.addSubview(errorPage)
        errorPageConstraints()
        errorPage.delegate = self
    }
    
    func reloadButtonTapped() {
        todayLocationManager.startUpdatingLocationFunction()
    }
    
    func errorPageConstraints() {
        errorPage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorPage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            errorPage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            errorPage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            errorPage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func loadWeatherAPI(lat: Double, lon: Double) {
        weatherPage.isHidden = true
        loadingPage.isHidden = false
        loadingPage.loader.startAnimating()
        rightBarButtonItem?.isEnabled = false
        
        service.loadTodaysWeather(lat: lat, lon: lon) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.loadingPage.loader.stopAnimating()
                self.loadingPage.isHidden = true
                self.rightBarButtonItem?.isEnabled = true
                switch result {
                case .success(let WeatherToday):
                    self.weatherPage.isHidden = false
                    self.generateData(WeatherToday: WeatherToday)
                    
                case .failure(let error):
                    self.errorPage.isHidden = false
                    self.weatherPage.isHidden = true
                    print(error)
                }
            }
            
        }
    }
    
    func generateData(WeatherToday: WeatherToday) {
        let url = URL(string: "https://openweathermap.org/img/wn/\(WeatherToday.weather[0].icon).png")!
        DispatchQueue.global().async {
            if let image = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.largeImage.image = UIImage(data: image)
                }
            }
        }
        self.city.text = WeatherToday.name + ", " + String(WeatherToday.sys.country)
        self.weather.text = String(Int(WeatherToday.main.temp-273.15)) + "°C | " + String(WeatherToday.weather[0].main)
        
        self.cloudPercentage.infoLabel.text = String(WeatherToday.clouds.all) + " %"
        self.humidity.infoLabel.text = String(WeatherToday.main.humidity) + " %"
        self.pressure.infoLabel.text = String(WeatherToday.main.pressure) + " hPa"
        self.windSpeed.infoLabel.text = String(round(WeatherToday.wind.speed * 3.6 * 10)/10) + " km/h"
        self.windDirection.infoLabel.text = direction(deg: WeatherToday.wind.deg)
        
        currentWeather = "Weather Today: " + self.weather.text! + "\nCloudiness: " + self.cloudPercentage.infoLabel.text! + "\nHumidity: " + self.humidity.infoLabel.text! + "\nPressure: " + self.pressure.infoLabel.text! + "\nWind Speed: " + self.windSpeed.infoLabel.text! + "\nWind Direction: " + self.windDirection.infoLabel.text!
    }
    
    func direction(deg: Int) -> String {
        let values = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
        let idx = Int((deg+Int(22.5)) / 45) % 8
        return values[idx]
    }
    
    func generateLocation() {
        todayLocationManager.todayDelegate = self
        todayLocationManager.requestLocationFunction()
    }

    func todayLocationManager(_ manager: LocationManager, didUpdateLocation location: CLLocation) {
        loadWeatherAPI(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
    }

}







