//
//  XferImageViewController.swift
//  
//
//  Created by Robert Wong on 1/11/18.
//

import UIKit

class XferImageViewController: UIViewController {
    
    @IBOutlet weak var xferImageView: UIImageView!
    var storedImage : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        xferImageView.image = storedImage
        // Do any additional setup after loading the view.
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
