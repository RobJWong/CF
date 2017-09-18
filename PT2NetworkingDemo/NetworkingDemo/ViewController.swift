//
//  ViewController.swift
//  NetworkingDemo
//
//  Created by Robert Wong on 9/15/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import SwiftyJSON


class ViewController: UIViewController {

    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!
    var weather : Weather?
    
    @IBAction func getTempButtonTapped(_ sender: UIButton) {
        if let city = cityNameTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines){
                if let encodedString = city.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
                    getWeatherData(urlString: "http://api.openweathermap.org/data/2.5/weather?q=\(encodedString)&appid=e226509705aa394b95d2caa0dc1d6966")
                }
            }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getWeatherData(urlString: "http://api.openweathermap.org/data/2.5/weather?q=New_York_City,usa&appid=e226509705aa394b95d2caa0dc1d6966")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getWeatherData(urlString: String) {
        let hud = MBProgressHUD()
        hud.label.text = "Loading"
        view.addSubview(hud)
        hud.show(animated:true)
        Alamofire.request(urlString)
            .validate()
            .responseJSON { response in
                hud.hide(animated:true )
                if response.result.isSuccess {
                    if let weatherJSON = response.result.value {
                        let parsedData = JSON(weatherJSON)
                        
                        let id = parsedData["id"].int
                        let cityName = parsedData["name"].string
                        let temperature = parsedData["main", "temp"].double
                        let description = parsedData["weather", 0, "description"].string
                        
                        self.weather = Weather(id: id!, cityName: cityName!, temperature: temperature!, weatherDescription: description!)
                        self.setLabel()
                    }
                } else {
                    print(response.result.error.debugDescription)
                }
        }
    }

    func setLabel() {
        if let temp = self.weather?.temperature {
            if let desc = self.weather?.weatherDescription {
                temperatureLabel.text = "Temp: \(String(format: "%.1f", temp)) Desc: \(desc)"
            }
        }
    }
}


