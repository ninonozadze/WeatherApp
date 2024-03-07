//
//  Weather.swift
//  ninoza21_FinalProject
//
//  Created by Nino Nozadze on 03.02.24.
//

import Foundation

struct WeatherToday: Codable {
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let clouds: Clouds
    let sys: Sys
    let name: String // City name
    let cod: Int // Internal parameter
}

struct Weather: Codable {
    let id: Int // Weather condition id
    let main: String // Group of weather parameters (Rain, Snow, Clouds etc.)
    let description: String // Weather condition within the group.
    let icon: String //Weather icon id
}

struct Main: Codable {
    let temp: Double // Temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit
    let pressure: Double // Atmospheric pressure on the sea level, hPa
    let humidity: Int // Humidity, %
}

struct Wind: Codable {
    let speed: Double // Wind speed. Unit Default: meter/sec, Metric: meter/sec, Imperial: miles/hour
    let deg: Int // Wind direction, degrees (meteorological)
}

struct Clouds: Codable {
    let all: Int // Cloudiness, %
}

struct Sys: Codable {
    let country: String // Country code
}

struct FiveDaysForecast: Codable {
    let cod: String // Internal parameter
    let list: [List]
}

struct List: Codable {
    let main: Main
    let weather: [Weather]
    let dt_txt: String // Time of data forecasted, ISO, UTC
}

