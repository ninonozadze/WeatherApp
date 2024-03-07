//
//  Service.swift
//  ninoza21_FinalProject
//
//  Created by Nino Nozadze on 03.02.24.
//

import Foundation

class Service {
    
    private let apiKey = "80e69ce5450b017d8dd47c2e5d1494e1"
    private var components = URLComponents()
    
    enum ServiceError: Error {
        case dataError
        case parametersError
    }
    
    init() {
        components.scheme = "https"
        components.host = "api.openweathermap.org"
    }
    
    func loadTodaysWeather(lat: Double, lon: Double, completion: @escaping (Result<WeatherToday, Error>) -> ()) {
        components.path = "/data/2.5/weather"
        
        let parameters = [
            "lat" : lat.description, // Latitude
            "lon" : lon.description, // Longitude
            "appid" : apiKey.description // API key
        ]
        
        components.queryItems = parameters.map { key, value in
            return URLQueryItem(name: key, value: value)
        }
        
        if let url = components.url{
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(WeatherToday.self, from: data)
                        completion(.success(result))
                        return

                    } catch {
                        completion(.failure(error)) 
                        return
                    }
        
                } else {
                    completion(.failure(ServiceError.dataError))
                    return
                }
            })
            
            task.resume()
            
        } else {
            completion(.failure(ServiceError.parametersError))
            return
        }
    }
    
    func loadFiveDaysForecast(lat: Double, lon: Double, completion: @escaping (Result<FiveDaysForecast, Error>) -> ()){
        components.path = "/data/2.5/forecast"
        
        let parameters = [
            "lat" : lat.description, // Latitude
            "lon" : lon.description, // Longitude
            "appid" : apiKey.description // API key
        ]
        
        components.queryItems = parameters.map { key, value in
            return URLQueryItem(name: key, value: value)
        }
        
        if let url = components.url{
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(FiveDaysForecast.self, from: data)
                        completion(.success(result))
                        return

                    } catch {
                        completion(.failure(error))
                        return
                    }
        
                } else {
                    completion(.failure(ServiceError.dataError))
                    return
                }
            })
            
            task.resume()
            
        } else {
            completion(.failure(ServiceError.parametersError))
            return
        }
    }
}
