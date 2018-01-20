//
//  SecondViewController.swift
//  Travels
//
//  Created by Robert Wong on 1/10/18.
//  Copyright © 2018 Robert Wong. All rights reserved.
//

import UIKit
import GooglePlaces

class OnboardCitySelect: UIViewController {
    
    var userData: UserData?
    
    @IBAction func autocompleteClicked(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        autocompleteController.autocompleteFilter = filter
        present(autocompleteController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //print("User's ID: ", userData?.userID)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let onboardingEmptyListVC = segue.destination as? OnboardingEmptyList {
            onboardingEmptyListVC.userData = userData
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

extension OnboardCitySelect: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place: \(place.addressComponents![0])")
        print("Place name: \(place.name)")
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //let controller = storyboard.instantiateViewController(withIdentifier: "EmptyList") as! OnboardingEmptyList
        self.userData?.currentCitySelection = place.name
        //controller.selectedCity = place.name
        dismiss(animated: true, completion: {
            self.performSegue(withIdentifier: "OnboardingEmptyList", sender: self)
        })
        //present(controller, animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
