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
    var storedImageURL: NSURL?
    var userData: UserData?
    
    @IBOutlet weak var photoSection: UIView!
    @IBOutlet weak var notesSection: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNavBarItems()
        
        let photoSectionTap = UITapGestureRecognizer(target: self, action: #selector(photoTapped(_:)))
        photoSection.isUserInteractionEnabled = true
        photoSection.addGestureRecognizer(photoSectionTap)
        
        let notesSectionTap = UITapGestureRecognizer(target: self, action: #selector(notesTapped(_:)))
        notesSection.isUserInteractionEnabled = true
        notesSection.addGestureRecognizer(notesSectionTap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func photoTapped(_ sender: UITapGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func notesTapped(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "notesVC", sender: self)
    }
    
    @objc func buttonAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let uploadPhotoVC = segue.destination as? AddMemoryViewController {
            uploadPhotoVC.storedImage = storedImage
            uploadPhotoVC.imageURL = storedImageURL
            uploadPhotoVC.userData = userData
        }
        if segue.identifier == "notesVC" {
            let notesVC = segue.destination as? AddNotesViewController
            notesVC?.userData = userData
        }
    }
    
    func setupNavBarItems() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        let backButton = UIBarButtonItem(image:UIImage(named:"icon_back"), style:.plain, target:self, action:#selector(OnboardEmptyList.buttonAction(_:)))
        self.navigationItem.leftBarButtonItem = backButton
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let imageURL = info[UIImagePickerControllerImageURL] as? NSURL, let image = info[UIImagePickerControllerOriginalImage] as? UIImage  else {
            AlertBox.sendAlert(boxMessage: "Unable to get local image URL", presentingController: self)
            return
        }
        storedImageURL = imageURL
        storedImage = image
        dismiss(animated: true, completion: {
            self.performSegue(withIdentifier: "xferImage", sender: self)
        })
    }
}
