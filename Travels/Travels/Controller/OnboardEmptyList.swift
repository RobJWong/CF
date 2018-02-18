//
//  EmptyListViewController.swift
//  Travels
//
//  Created by Robert Wong on 1/10/18.
//  Copyright © 2018 Robert Wong. All rights reserved.
//

import UIKit
import Firebase

class OnboardEmptyList: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var storedImage: UIImage?
    //var selectedCity: String?
    var storedImageURL: NSURL?
    
    var userData: UserData?
    
//    @IBAction func backButton(_ sender: UIButton) {
//        dismiss(animated: true, completion: nil)
//    }
    
    @IBAction func openCameraButton(_sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNavBarItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNavBarItems() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        let backButton = UIBarButtonItem(image:UIImage(named:"icon_back"), style:.plain, target:self, action:#selector(OnboardEmptyList.buttonAction(_:)))
        //backButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = backButton
        
    }
    
    @objc func buttonAction(_ sender: UIBarButtonItem) {
        //let onboardCitySelectVC = OnboardCitySelect()
        //self.navigationController?.popToViewController(onboardCitySelectVC, animated: true)
        self.navigationController?.popViewController(animated: true)
        //self.performSegue(withIdentifier: "userSettings", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let uploadPhotoVC = segue.destination as? AddMemoryViewController {
            uploadPhotoVC.storedImage = storedImage
            uploadPhotoVC.imageURL = storedImageURL
            uploadPhotoVC.userData = userData
        }
        if let uploadNotesVC = segue.destination as? AddNotesViewController {
            uploadNotesVC.userData = userData
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let imageURL = info[UIImagePickerControllerImageURL] as? NSURL, let image = info[UIImagePickerControllerOriginalImage] as? UIImage  else {
            AlertBox.sendAlert(boxMessage: "Unable to get local image URL", presentingController: self)
            return
        }
        storedImageURL = imageURL
        storedImage = image
        //sendImage(imageURL: imageURL)
        //updateFirebase(imageURL: imageURL)
        dismiss(animated: true, completion: {
            self.performSegue(withIdentifier: "xferImage", sender: self)
        })
//        dismiss(animated: true, completion: {
//        })
        ////////orignal method working
        //        dismiss(animated:true, completion: nil)
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let controller = storyboard.instantiateViewController(withIdentifier: "xferImage") as! XferImageViewController
        //        controller.storedImage = image
        //        present(controller, animated: true, completion: nil)
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
