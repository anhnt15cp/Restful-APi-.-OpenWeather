//
//  Model.swift
//  APIWeather11
//
//  Created by Tuấn Anh on 17/10/2022.
//

import Foundation
import Alamofire
import ObjectMapper
import UIKit





class LatLonPlace: Mappable {
    func mapping(map: Map) {
        lat <- map["lat"]
        lon <- map["lon"]
        name <- map["name"]
        country <- map["country"]
    }
    required init(map: Map) {
    }
    var lat: Double?
    var lon: Double?
    var name: String?
    var country: String?
}
class ForecastDays: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        list <- map["list"]
    }
    var list: [CurrentWeather]?
    
    
}


class CurrentWeather: Mappable {

    var weather: [Weather]?
    var main: Main?
    var wind: Wind?
    var clouds: Clouds?
    var name: String?
    var dt_txt: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        weather <- map["weather"]
        main <- map["main"]
        wind <- map["wind"]
        clouds <- map["clouds"]
        name <- map["name"]
        dt_txt <- map["dt_txt"]
    }
}

class Weather: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        main <- map["main"]
        description <- map["description"]
        icon <- map["icon"]
        
    }
    var id: Float?
    var main: String?
    var description: String?
    var icon: String?
    
    
}

class Main: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        temp <- map["temp"]
        feels_like <- map["feel_like"]
        temp_min <- map["temp_min"]
        temp_max <- map["temp_max"]
        pressure <- map["pressure"]
        humility <- map["humility"]
        sea_level <- map ["sea_level"]
    }
    var temp: Float?
    var feels_like: Float?
    var temp_min: Float?
    var temp_max: Float?
    var pressure: Float?
    var humility: Float?
    var sea_level: Float?
    
    var temp1: String {
        return String(format: "%0.0f°C", Double( temp ?? 0))
    }
    
    var tempMin: String {
        return String(format: "%0.0f°C", Double( temp_min ?? 0))
    }
    
    var tempMax: String {
        return String(format: "%0.0f°C", Double( temp_max ?? 0))
    }
}
class Wind: Mappable {
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        speed <- map["speed"]
        deg <- map["deg"]
        gust <- map["gust"]
    }
    var speed: Float?
    var deg: Float?
    var gust: Float?
}

class Clouds: Mappable {
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        all <- map["all"]
    }
    var all: Float?
}
