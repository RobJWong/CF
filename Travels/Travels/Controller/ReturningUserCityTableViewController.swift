//
//  ReturningUserCityTableViewController.swift
//  Travels
//
//  Created by Robert Wong on 1/16/18.
//  Copyright © 2018 Robert Wong. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import GooglePlaces

class ReturningUserCityTableViewController: UITableViewController {
    
    var userData : UserData?
    var cities: [String]?
    
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
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setupSavedLocations()
        setupNavBarItems()
    }
    
    
    func setupNavBarItems() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        let settingsButton = UIBarButtonItem(image:UIImage(named:"icon_settings"), style:.plain, target:self, action:#selector(ReturningUserCityTableViewController.buttonAction(_:)))
        self.navigationItem.rightBarButtonItem = settingsButton
    }
    
    @objc func buttonAction(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "userSettings", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCityDetail" {
            let returningUserCityDetailVC = segue.destination as? ReturningUserCityDetailTableViewController
            if let indexPath = self.tableView.indexPathForSelectedRow {
                userData?.currentCitySelection = cities?[indexPath.row]
                returningUserCityDetailVC?.userData = userData
            }
        }
        if let addNewCity = segue.destination as? OnboardEmptyList {
            addNewCity.userData = userData
        }
        if let userProfileVC = segue.destination as? UserProfileViewController {
            userProfileVC.userData = userData
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard let uid = self.userData?.userID, let citiesArray = cities else { return nil }
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            print("delete button tapped")
            let alert = UIAlertController(title: "Confrimation", message: "Do you want to delete all the data relating to this city?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
                let databaseRef = Database.database().reference().child("Users").child(uid).child("Cities").child(citiesArray[indexPath.row])
                databaseRef.removeValue()
                self.cities?.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                alert.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        delete.backgroundColor = .red
        
        return [delete]
    }
    
    func setupSavedLocations() {
        guard let uid = userData?.userID else {
            print("uid is nil")
            return
        }
        let databaseRef = Database.database().reference().child("Users").child(uid).child("Cities")
        databaseRef.observeSingleEvent(of: .value, with: { (snapshot) in
            var cityContainer : [String] = []
            for city in snapshot.children {
                let snap = city as! DataSnapshot
                let key = snap.key
                cityContainer.append(key)
            }
            print(cityContainer)
            self.cities = cityContainer
            self.tableView.reloadData()
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let cities = cities else { return 1 }
        return cities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CityTableViewCell
        cell.textLabel?.textAlignment = .center
        cell.cityName.text = cities?[indexPath.row]
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ReturningUserCityTableViewController: GMSAutocompleteViewControllerDelegate {
    
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
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        //navigationController?.popViewController(animated: true)
        navigationController?.popToRootViewController(animated: true)
        dismiss(animated: true, completion: nil)
        //navigationController?.popToRootViewController(animated: true)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
