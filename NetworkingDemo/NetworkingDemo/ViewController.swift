//
//  ViewController.swift
//  NetworkingDemo
//
//  Created by Robert Wong on 9/15/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!
    
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
        let url = URL(string: urlString)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in DispatchQueue.main.async(execute: {
                self.setLabel(weatherData: data!)
            })
        }
    task.resume()
    }

    func setLabel(weatherData: Data) {
        do {
            let json = try JSONSerialization.jsonObject(with: weatherData, options: []) as! Dictionary<String, AnyObject>
            if let main = json["main"] as? Dictionary<String, AnyObject> {
                if let temp = main["temp"] as? Double {
                    var displayTemp = Double((9.0 / 5.0)*(temp - 273.0)+32.0)
                    //let testData = Double(9.0/5.0)*(temp - 273.0)
                    temperatureLabel.text = String(format: "%.1f", displayTemp)
                }
            }
        } catch {
            print("Error fetching data")
        }
    }
}


