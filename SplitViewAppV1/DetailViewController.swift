//
//  DetailViewController.swift
//  SplitViewAppV1
//
//  Created by Robert Wong on 8/21/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailTeamImage: UIImageView!
    
    var team: Team?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let team = self.team {
            navigationItem.title = team.teamName
            detailTeamImage.image = UIImage(named: team.imageName)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
