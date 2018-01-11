//
//  ViewController.swift
//  WanderlistTestArea
//
//  Created by Robert Wong on 12/13/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit

class PhotoSelectorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var pickedImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openCameraButton(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "xferImage" {
            let xferImageVC = segue.destination as! TransferImageViewController
            xferImageVC.newImage = pickedImage.image
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        print("Image picked: ", image)
        pickedImage.image = image
        dismiss(animated:true, completion: nil)
    }
}

