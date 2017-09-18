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
    
    @IBAction func generatePlayerData(_ sender: UIButton) {
        if let summonerNameInput = summonerName.text {
            getPlayerData(urlString: "https://na1.api.riotgames.com/lol/summoner/v3/summoners/by-name/\(summonerNameInput)?api_key=RGAPI-07450933-905d-4a3a-b7eb-70a6cf5b04f7")
        }
        
        if let summonerID = summonerID {
            getSummonerRanked(urlString: "https://na1.api.riotgames.com/lol/league/v3/positions/by-summoner/\(summonerID)?api_key=RGAPI-07450933-905d-4a3a-b7eb-70a6cf5b04f7")
        }
        
        let alertController = UIAlertController(title: "Entered", message: "Entered", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) {
            (alert) in
            print("User tapped Ok")
        }
        alertController.addAction(okAction)
        alertController.popoverPresentationController?.sourceRect = sender.frame
        alertController.popoverPresentationController?.sourceView = view
        
        present(alertController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getPlayerData(urlString: String) {
        let url = URL(string: urlString)
        let dataTask = URLSession.shared.dataTask(with: url!)  {(data, response, error) in DispatchQueue.main.async ( execute : {
            self.getSummonerIDJSON(playerData: data!)
            })
        }
        //dataTask.resume()
    }
    
    func getSummonerRanked(urlString: String) {
        let url = URL(string: urlString)
        let dataTask = URLSession.shared.dataTask(with: url!)  {(data, response, error) in DispatchQueue.main.async ( execute : {
            self.getSummonerRankedJSON(playerData: data!)
            })
        }
        dataTask.resume()
    }

    func getSummonerIDJSON(playerData: Data) {
        do {
            let jsonUser = try JSONSerialization.jsonObject(with: playerData, options: []) as! [String:Any]
            if let summonerIDData = jsonUser["id"] {
                self.summonerID = String(describing: summonerIDData)
            }
        } catch {
            print("Error capturing summonerID")
        }
    }
    
    func getSummonerRankedJSON(playerData: Data) {
        do {
            let jsonRankedData = try JSONSerialization.jsonObject(with: playerData, options: []) as! [[String:Any]]
            if let winData = jsonRankedData[0]["wins"] {
                winsLabel.text = String(stringInterpolationSegment:winData)
            }
        } catch {
            print("potato code")
        }
    }
}

//    func getSummonerRankedJSON(playerData: Data) {
//        do {
//            let jsonUserRanked = try? JSONSerialization.jsonObject(with: playerData, options:  []) as! [[String:Any]]
//            if let winData = jsonUserRanked?[0]["wins"], let loseData = jsonUserRanked?[0]["losses"], let divisionData = jsonUserRanked?[0]["rank"], let tierData = jsonUserRanked?[0]["tier"] {
//                winsLabel.text = String(stringInterpolationSegment:winData)
//                losesLabel.text = String(stringInterpolationSegment:loseData)
//                divisionLabel.text = String(stringInterpolationSegment:divisionData)
//                tierLabel.text = String(stringInterpolationSegment:tierData)
//            } catch {
//                print ("Error capturing smmoner ranked stats")
//            }
//        }
//    }


//    func getData(playerData: Data) {
//        do {
//            let json = try JSONSerialization.jsonObject(with: playerData, options: []) as! [[String:Any]]
//            if let winData = json[0]["wins"], let loseData = json[0]["losses"], let divisionData = json[0]["rank"], let tierData = json[0]["tier"] {
//                winsLabel.text = String(stringInterpolationSegment:winData)
//                losesLabel.text = String(stringInterpolationSegment:loseData)
//                divisionLabel.text = String(stringInterpolationSegment:divisionData)
//                tierLabel.text = String(stringInterpolationSegment:tierData)
//            } else {
//                let summonerData = json[0]["id]
//        } catch {
//            print("error")
//        }
//

