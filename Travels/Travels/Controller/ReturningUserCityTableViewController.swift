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
    
//    @IBAction func addCity(_ sender: UIBarButtonItem) {
//        performSegue(withIdentifier: "addCity", sender: self)
//    }
    
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
        
//        setupSavedLocations()
//        setupNavBarItems()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        //backButton.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = settingsButton
        
    }
    
    @objc func buttonAction(_ sender: UIBarButtonItem) {
        //self.navigationController?.popViewController(animated: true)
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
//        if let addNewCity = segue.destination as? OnboardEmptyList {
//            addNewCity.userData = userData
//            let tempVC  = OnboardEmptyList()
//            navigationController?.pushViewController(tempVC, animated: true)
//        }
        if let addNewCity = segue.destination as? OnboardEmptyList {
            addNewCity.userData = userData
        }
        if let userProfileVC = segue.destination as? UserProfileViewController {
            userProfileVC.userData = userData
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = cities?[indexPath.row]
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.font = UIFont(name: "Goku", size: 33.9)
        cell.textLabel?.textAlignment = .center
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ReturningUserCityTableViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let parseLocation = place.formattedAddress?.components(separatedBy: ",")
        guard let location = parseLocation else { return }
        //print(location)
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
