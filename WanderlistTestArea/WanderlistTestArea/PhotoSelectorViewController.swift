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
    var pickedImageVar: UIImage!
    
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
//        let xferImageVC = segue.destination as? XferImageViewController
//        xferImageVC?.storedImage = pickedImage.image
//        if segue.identifier == "xferImage" {
//            let xferImageVC = segue.destination as? XferImageViewController
//             print("Am I here?")
//        }
//            //xferImageVC.newImage = pickedImage.image
//            //xferImageVC.browsingImage.image = pickedImage.image
//        if segue.destination is XferImageViewController {
//            let xferVC = segue.destination as? XferImageViewController
//            print(pickedImage.image)
//            //xferVC?.storedImage = pickedImage.image
//            xferVC?.storedImage = pickedImageVar
//        }
//
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.destination is XferImageViewController {
//            print("Test: ", pickedImage.image)
//            let xferVC = segue.destination as? XferImageViewController
//            xferVC?.storedImage = pickedImage.image
//        }
//        print("WHAT IS GOING ON")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            pickedImage.image = image
        } else {
            print("Something went wrong")
        }
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        //pickedImage.image = image
        dismiss(animated:true, completion: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "xferImage") as! XferImageViewController
        controller.storedImage = image
        present(controller, animated: true, completion: nil)
        //performSegue(withIdentifier: "xferImage", sender: self)
    }
}

