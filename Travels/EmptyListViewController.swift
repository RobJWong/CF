//
//  EmptyListViewController.swift
//  Travels
//
//  Created by Robert Wong on 1/10/18.
//  Copyright © 2018 Robert Wong. All rights reserved.
//

import UIKit

class EmptyListViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func openCameraButton(_sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoPickerController = UIImagePickerController()
            photoPickerController.delegate = self
            photoPickerController.sourceType = .photoLibrary
            EmptyListViewController.present(photoPickerController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
