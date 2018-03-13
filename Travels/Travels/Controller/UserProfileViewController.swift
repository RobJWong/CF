//
//  UserProfileViewController.swift
//  Travels
//
//  Created by Robert Wong on 2/1/18.
//  Copyright © 2018 Robert Wong. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase

class UserProfileViewController: UIViewController {
    
    var userData: UserData?
    
    @IBAction func logout(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signOut()
        let homeVC = storyboard?.instantiateViewController(withIdentifier: "HomeScreen") as! LoginViewContoller
        present(homeVC, animated: true, completion: nil)
        AlertBox.sendAlert(boxMessage: "Signed out", presentingController: self)
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteProfile(_ sender: UIButton) {
        let alert = UIAlertController(title: "Travels", message: "Are you sure you want to delete the user profile?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            switch action.style{
            case .default:
                guard let userID = self.userData?.userID else { return }
                let deleteUser = Database.database().reference().child("Users").child(userID)
                deleteUser.removeValue()
        
                GIDSignIn.sharedInstance().signOut()
                let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeScreen") as! LoginViewContoller
                self.present(homeVC, animated: true, completion: nil)
                AlertBox.sendAlert(boxMessage: "User deleted", presentingController: self)
            case .cancel:
                print("Not Applicable")
                
            case .destructive:
                print("Not Applicable")
            }}))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
        
        let backButton = UIBarButtonItem(image:UIImage(named:"icon_back"), style:.plain, target:self, action:#selector(UserProfileViewController.buttonAction(_:)))
        backButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = backButton
        
    }
    
    
    @objc func buttonAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}
