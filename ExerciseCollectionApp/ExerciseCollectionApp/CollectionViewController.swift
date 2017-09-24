//
//  CollectionViewController.swift
//  ExerciseCollectionApp
//
//  Created by Robert Wong on 7/13/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {
    
    var exerciseItems = [ExerciseSet]()
    var sectionNames : [String] = ["Set 1", "Set 2"]
    var exerciseItems2 = [ExerciseSet]()
    var allExercises = [[ExerciseSet]]()
    
    @IBAction func addExerciseButton(_ sender: Any) {
        let newExercise = ExerciseSet()
        let index = allExercises[0].count
        allExercises[0].append(newExercise)
        let indexPath = IndexPath(item: index, section: 0)
        collectionView?.insertItems(at: [indexPath])
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = collectionView!.frame.width / 2
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
        for i in 1...12 {
            exerciseItems.append(ExerciseSet())
        }
        for i in 1...12 {
            exerciseItems2.append(ExerciseSet())
        }
        
        allExercises.append(exerciseItems)
        allExercises.append(exerciseItems2)
    }
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemSelected = allExercises[sourceIndexPath.section][sourceIndexPath.row]
        allExercises[sourceIndexPath.section].remove(at:sourceIndexPath.row)
        allExercises[destinationIndexPath.section].insert(itemSelected, at: destinationIndexPath.row)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return allExercises.count
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.performBatchUpdates( { Void in
            self.allExercises[indexPath.section].remove(at: indexPath.row)
            self.collectionView?.deleteItems(at: [indexPath])
        }, completion: nil)
//        func showAlert(title: String) {
//            let alert = UIAlertController(title: title, message: nil, preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { action in
//
//                collectionView.performBatchUpdates({Void in
//                    self.allExercises[indexPath.section].remove(at: indexPath.row)
//                    self.collectionView?.deleteItems(at: [indexPath])
//                }, completion: nil)
//
//            }))
//            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
//
//        let exercises = allExercises[indexPath.section][indexPath.row]
//        showAlert(title: "Delete '\(exercises.exerciseName)'?")
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as! ExerciseItemHeader
        sectionHeader.title = sectionNames[indexPath.section]
        return sectionHeader
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        //return exerciseItems.count
        return allExercises[section].count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ExerciseItemCell
        let dataItem = allExercises[indexPath.section][indexPath.row]
        cell.exerciseItem = dataItem
        return cell
    }

}
