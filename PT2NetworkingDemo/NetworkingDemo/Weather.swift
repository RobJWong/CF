//
//  Weather.swift
//  NetworkingDemo
//
//  Created by Robert Wong on 9/18/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import Foundation

class Weather {
    
    var id: Int
    var cityName: String
    var temperature: Double
    var weatherDescription: String
    
    init(id: Int, cityName: String, temperature: Double, weatherDescription: String) {
        self.id = id
        self.cityName = cityName
        self.temperature = temperature
        self.weatherDescription = weatherDescription
    }
    
}
