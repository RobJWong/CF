//
//  ViewController.swift
//  NetworkAppV1
//
//  Created by Robert Wong on 9/15/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

//https://na1.api.riotgames.com/lol/league/v3/positions/by-summoner/22362681?api_key=RGAPI-728d27bb-9d39-4850-bcac-2c446adfcf7c
import UIKit

class ViewController: UIViewController, UIPopoverControllerDelegate {

    @IBOutlet weak var winsLabel: UILabel!
    @IBOutlet weak var losesLabel: UILabel!
    @IBOutlet weak var divisionLabel: UILabel!
    @IBOutlet weak var tierLabel: UILabel!
    
    @IBAction func generatePlayerData(_ sender: UIButton) {
        getPlayerData(urlString: "https://na1.api.riotgames.com/lol/league/v3/positions/by-summoner/22362681?api_key=RGAPI-728d27bb-9d39-4850-bcac-2c446adfcf7c")
        
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
        let dataTask = URLSession.shared.dataTask(with: url!)  {(data, response, error) in
            DispatchQueue.main.async ( execute : {
                self.getData(playerData: data!)
            })
        }
        dataTask.resume()
    }
    
    func getData(playerData: Data) {
        do {
            let json = try JSONSerialization.jsonObject(with: playerData, options: []) as! [[String:Any]]
            if let winData = json[0]["wins"], let loseData = json[0]["losses"], let divisionData = json[0]["rank"], let tierData = json[0]["tier"] {
                winsLabel.text = String(stringInterpolationSegment:winData)
                losesLabel.text = String(stringInterpolationSegment:loseData)
                divisionLabel.text = String(stringInterpolationSegment:divisionData)
                tierLabel.text = String(stringInterpolationSegment:tierData)
            }
        } catch {
            print("error")
        }
    }
}

