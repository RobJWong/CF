//
//  TransferImageViewController.swift
//  
//
//  Created by Robert Wong on 1/11/18.
//

import UIKit

class TransferImageViewController: UIViewController {
    
    @IBOutlet weak var browsingImage: UIImageView!
    var newImage :  UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        browsingImage.image = newImage
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
