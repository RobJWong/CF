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
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let xferVC = segue.destination as? XferImageViewController {
//            xferVC.storedImage = pickedImage.image
//        }
//    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            print (image)
            print("Am I in here?")
    }
        let imageURL = info[UIImagePickerControllerImageURL] as! NSURL
        print("File location: ", imageURL)
        dismiss(animated: true, completion: nil)
        
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            pickedImage.image = image
//        } else {
//            print("Something went wrong")
//        }
//        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
//        dismiss(animated: true, completion: {
//            self.performSegue(withIdentifier: "xferImage", sender: self)
//        })
    
        ////////orignal method working
//        dismiss(animated:true, completion: nil)
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: "xferImage") as! XferImageViewController
//        controller.storedImage = image
//        present(controller, animated: true, completion: nil)
    }
}

