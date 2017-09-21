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
    var summonerID: String?
    
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
            getSummonerInfo(forName: nameString) { (userJson, error) in
                let summonerIDTest = userJson!["id"]!
                //print (summonerIDTest)
                self.summonerID = String(describing: summonerIDTest)
                print (self.summonerID)
            }
            getSummonerRankedInfo(forID: self.summonerID!) { (userRankJson, error) in
                if let wins = userRankJson![0]["wins"] {
                    self.winsLabel.text = String(describing: wins)
                }
            }
        }
    }
    
    func getSummonerInfo(forName name: String, completion: @escaping ([String:Any]?, Error?) -> Void ) {
        let urlString = "https://na1.api.riotgames.com/lol/summoner/v3/summoners/by-name/\(name)?api_key=RGAPI-fe0d450b-e6c4-4f0e-a2ca-d9fa6cd3b3a3"
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
    
    func getSummonerRankedInfo(forID ID: String, completion: @escaping ([[String:Any]]?, Error?) -> Void ) {
        let urlString = "https://na1.api.riotgames.com/lol/league/v3/positions/by-summoner/\(ID)?api_key=RGAPI-fe0d450b-e6c4-4f0e-a2ca-d9fa6cd3b3a3"
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
    
    //    if let winData = json[0]["wins"], let loseData = json[0]["losses"], let divisionData = json[0]["rank"], let tierData = json[0]["tier"] {
    //        winsLabel.text = String(stringInterpolationSegment:winData)
    //        losesLabel.text = String(stringInterpolationSegment:loseData)
    //        divisionLabel.text = String(stringInterpolationSegment:divisionData)
    //        tierLabel.text = String(stringInterpolationSegment:tierData)
    
    //        if let winData = userRankJson![0]["wins"], let loseData = userRankJson![0]["losses"], let divisionData = userRankJson![0]["rank"], let tierData = userRankJson![0]["tier"]{
    //            winsLabel.text = winData
    //        }
}
