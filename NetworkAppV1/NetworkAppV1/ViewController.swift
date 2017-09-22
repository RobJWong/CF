//
//  ViewController.swift
//  NetworkAppV1
//
//  Created by Robert Wong on 9/15/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//
import UIKit

class ViewController: UIViewController, UIPopoverControllerDelegate {

    @IBOutlet weak var winsLabel: UILabel!
    @IBOutlet weak var losesLabel: UILabel!
    @IBOutlet weak var divisionLabel: UILabel!
    @IBOutlet weak var tierLabel: UILabel!
    @IBOutlet weak var summonerName: UITextField!
    private let noData = "-No data-"
    
    enum ApiError: Error {
        case invalidURL
        case couldntParseData
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func getSummerInfoButton(_ sender: UIButton) {
        if let nameString = summonerName.text {
            getSummonerInfo(forName: nameString) { (userJson, error) in ///not sure how to solve this
                if let summonerID = userJson?["id"] as? Int {
                    self.getSummonerRankedInfo(forID: summonerID) { (userRankJson, error) in
                        DispatchQueue.main.async(execute: {
                            if !userRankJson!.isEmpty {
                                let wins = userRankJson![0]["wins"]!
                                self.set(self.winsLabel, with: String(describing:wins))
                                let loses = userRankJson![0]["losses"]!
                                self.set(self.losesLabel, with: String(describing:loses))
                                let tier = userRankJson![0]["tier"]!
                                self.set(self.tierLabel, with: String(describing:tier))
                                let divison = userRankJson![0]["rank"]!
                                self.set(self.divisionLabel, with: String(describing:divison))
                            } else {
                                self.showErrorAlert(title: "Error", message: "Ranked info not found")
                            }
                        })
                    }
                } else {
                    print("Error thrown")
                    self.showErrorAlert(title: "Error", message: "User not found")
                }
            }
        }
    }
    
    func getSummonerInfo(forName name: String, completion: @escaping ([String:Any]?, Error?) -> Void ) {
        let urlString = "https://na1.api.riotgames.com/lol/summoner/v3/summoners/by-name/\(name)?api_key=RGAPI-779334cb-51f8-4845-b988-cf190f240407"
        guard let url = URL(string: urlString) else {
            completion(nil, ApiError.invalidURL)
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with:url) { data, response, error in
            if let error = error {
                completion(nil, error)
            } else if let data = data {
                do {
                    if let jsonUser = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        completion(jsonUser, nil)
                    } else {
                        completion(nil, ApiError.couldntParseData)
                    }
                } catch {
                    completion(nil, ApiError.couldntParseData)
                }
            }
        }
        dataTask.resume()
    }
    
    func getSummonerRankedInfo(forID ID: Int, completion: @escaping ([[String:Any]]?, Error?) -> Void ) {
        let urlString = "https://na1.api.riotgames.com/lol/league/v3/positions/by-summoner/\(ID)?api_key=RGAPI-779334cb-51f8-4845-b988-cf190f240407"
        guard let url = URL(string: urlString) else {
            completion(nil, ApiError.invalidURL)
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with:url) { data, response, error in
            if let error = error {
                completion(nil, error)
            } else if let data = data {
                do {
                    if let jsonUser = try JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]] {
                        completion(jsonUser, nil)
                    } else {
                        completion(nil, ApiError.couldntParseData)
                    }
                } catch {
                    completion(nil, ApiError.couldntParseData)
                }
            }
        }
        dataTask.resume()
    }
    
    func set(_ textField: UILabel?, with text: String?) {
        if let text = text, !text.isEmpty {
            textField?.text = text
        } else {
            textField?.text = noData
        }
    }
    
    func showErrorAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
