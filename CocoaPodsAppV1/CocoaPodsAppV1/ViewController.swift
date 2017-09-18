//
//  ViewController.swift
//  CocoaPodsAppV1
//
//  Created by Robert Wong on 9/18/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var picker: UIPickerView!
    var pickerData: [String] = [String]()
    var newsSelectionPicked: String?

    @IBOutlet weak var newsTextField: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.picker.delegate = self
        self.picker.dataSource = self
        pickerData = ["Bloomberg", "Buzzfeed", "CNN", "ESPN", "Independent", "Time"]
        self.newsSelectionPicked = pickerData[0]
    }

    @IBAction func generateHeadline(_ sender: UIButton) {
        print(newsSelectionPicked)
        let formattedNewsString = newsSelectionPicked!.lowercased()
        let urlString = "https://newsapi.org/v1/articles?source=\(formattedNewsString)&sortBy=top&apiKey=7dae1514f165451699da7d4633acc5ac"
        Alamofire.request(urlString)
            .validate()
            .responseJSON { response in
                if response.result.isSuccess {
                    if let newsJSON = response.result.value {
                        let parsedData = JSON(newsJSON)
                        let newsAuthor = parsedData["articles", 0 ,"author"]
                        let newsTitle = parsedData["articles", 0, "title"]
                        let newsDescription = parsedData["articles", 0, "description"]
                        let newsURL = parsedData["articles", 0, "url"]
                        self.newsTextField.text = (" Author: \(newsAuthor) \n\n Title: \(newsTitle) \n\n Description: \(newsDescription) \n\n URL: \(newsURL)")
                    }
                } else {
                    print(response.result.error.debugDescription)
                }
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.newsSelectionPicked = pickerData[row]
    }
    
    func noSelectionAlert() {
        let alertController = UIAlertController(title: "Alert", message: ("No selection"), preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

