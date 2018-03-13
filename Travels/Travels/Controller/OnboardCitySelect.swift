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
    
    //@IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var welcomeName: UILabel!
    @IBOutlet weak var googlePlacesView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //setupBackButton()
        guard let nameString = userData?.userName else { return }
        welcomeName.text = "Hi  \(nameString)! \nWhat city are you starting with?"
        setupNavBarItems()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let onboardEmptyListVC = segue.destination as? OnboardEmptyList {
            onboardEmptyListVC.userData = userData
        }
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
        
        let googlePlacesSearch = UITapGestureRecognizer(target: self, action: #selector(googlePlacesTapped(_:)))
        googlePlacesView.isUserInteractionEnabled = true
        googlePlacesView.addGestureRecognizer(googlePlacesSearch)
    }
    
    @objc func googlePlacesTapped(_ sender: UITapGestureRecognizer) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        autocompleteController.autocompleteFilter = filter
        present(autocompleteController, animated: true, completion: nil)
    }
}

extension OnboardCitySelect: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let parseLocation = place.formattedAddress?.components(separatedBy: ",")
        guard let location = parseLocation else { return }
        let parseCount = location.count
        self.userData?.currentCitySelection = location[0] + ", " + location[parseCount - 1]
        dismiss(animated: true, completion: {
            self.performSegue(withIdentifier: "OnboardingEmptyList", sender: self)
        })
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
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
