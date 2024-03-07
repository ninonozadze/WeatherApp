//
//  FiveDaysForecastVC.swift
//  ninoza21_FinalProject
//
//  Created by Nino Nozadze on 03.02.24.
//

import UIKit
import CoreLocation

class FiveDaysForecastVC: UIViewController, ErrorPageDelegate, FiveDaysLocationManagerDelegate {
    
    private let service = Service()
    
    let forecastLocationManager = LocationManager.shared

    private var listArray: [List] = []
    private var forecastData: [[List]] = []
    private var weekdayArray: [(String, Int)] = []

    let weatherPage = UIView()
    let loadingPage = LoadingPage()
    let errorPage = ErrorPage()
    
    let colorLine = ColorLine()
    
    var forecastTableView = UITableView()

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
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//    }

//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        configureForecastTableView()
//    }
    
    func configureNavigationBar() {
        navigationItem.title = "Forecast"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshForecast))
    }
    
    @objc func refreshForecast() {
        forecastLocationManager.startUpdatingLocationFunction()
    }
    
    func configureWeatherPage() {
        view.addSubview(weatherPage)
        weatherPage.backgroundColor = .white
        
        weatherPageConstraints()
        configureColorLine()
        configureForecastTableView()
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
    
    func configureForecastTableView() {
        weatherPage.addSubview(forecastTableView)
        forecastTableViewConstraints()
        
        forecastTableView.delegate = self
        forecastTableView.dataSource = self
        forecastTableView.register(FiveDaysForecastCell.self, forCellReuseIdentifier: "FiveDaysForecastCell")
        forecastTableView.register(WeekdayHeader.self, forHeaderFooterViewReuseIdentifier: "WeekdayHeader")
    }
    
    func forecastTableViewConstraints(){
        forecastTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            forecastTableView.topAnchor.constraint(equalTo: colorLine.bottomAnchor),
            forecastTableView.leadingAnchor.constraint(equalTo: weatherPage.leadingAnchor),
            forecastTableView.trailingAnchor.constraint(equalTo: weatherPage.trailingAnchor),
            forecastTableView.bottomAnchor.constraint(equalTo: weatherPage.bottomAnchor)
        ])
    }
    
    func configureLoadingPage() {
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
        view.addSubview(errorPage)
        errorPageConstraints()
        
        errorPage.delegate = self
    }
    
    func reloadButtonTapped() {
        forecastLocationManager.startUpdatingLocationFunction()
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
    
    func loadForecastAPI(lat: Double, lon: Double) {
        weatherPage.isHidden = true
        loadingPage.isHidden = false
        loadingPage.loader.startAnimating()
        
        service.loadFiveDaysForecast(lat: lat, lon: lon) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.loadingPage.loader.stopAnimating()
                self.loadingPage.isHidden = true
                switch result {
                case .success(let FiveDaysForecast):
                    self.weatherPage.isHidden = false
                    self.listArray = FiveDaysForecast.list
                    self.generateData()
                    self.forecastTableView.reloadData()
                    
                case .failure(let error):
                    self.errorPage.isHidden = false
                    print(error)
                }
            }
            
        }
    }
    
    func generateData() {
        for list in listArray {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

            var weekday = ""
            if let date = dateFormatter.date(from: list.dt_txt) {
                weekday = dateFormatter.weekdaySymbols[Calendar.current.component(.weekday, from: date)-1].uppercased()
            }
            
            var contains = false
            
            for element in weekdayArray {
                if element.0 == weekday {
                    forecastData[element.1].append(list)
                    contains = true
                }
            }
            
            if !contains {
                let index = forecastData.count
                weekdayArray.append((weekday, index))
                forecastData.append([list])
            }
            
        }
        
    }
    
    func generateLocation() {
        forecastLocationManager.fiveDaysDelegate = self
        forecastLocationManager.requestLocationFunction()
    }

    func forecastLocationManager(_ manager: LocationManager, didUpdateLocation location: CLLocation) {
        loadForecastAPI(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
    }

}

extension FiveDaysForecastVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return weekdayArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FiveDaysForecastCell", for: indexPath)
        if let fiveDaysForecastCell = cell as? FiveDaysForecastCell {
            
            let list = forecastData[indexPath.section][indexPath.row]
            
            let url = URL(string: "https://openweathermap.org/img/wn/\(list.weather[0].icon).png")!
            DispatchQueue.global().async {
                if let image = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        fiveDaysForecastCell.weatherImage.image = UIImage(data: image)
                    }
                }
            }
            fiveDaysForecastCell.timeLabel.text = String(list.dt_txt.prefix(16).suffix(5))
            fiveDaysForecastCell.weatherLabel.text = list.weather[0].description
            fiveDaysForecastCell.temperatureLabel.text = String(Int(list.main.temp-273.15)) + "°C"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var weekday = ""
        for pair in weekdayArray {
            if pair.1 == section {
                weekday = pair.0
            }
        }
            
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "WeekdayHeader")
        if let weekdayHeader = header as? WeekdayHeader {
            weekdayHeader.setup(with: weekday)
        }
        return header
    }
    
}
