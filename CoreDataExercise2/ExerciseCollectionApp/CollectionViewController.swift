//
//  CollectionViewController.swift
//  ExerciseCollectionApp
//
//  Created by Robert Wong on 7/13/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit
import CoreData

class CollectionViewController: UICollectionViewController {
    
    var exerciseList: [String] = ["Squats", "Jumping Jacks", "Push Ups", "Crunches", "Bicycle Kicks",
                                     "Lunges", "Burpies", "Knee Jumps", "Pull Ups", "Hip Raise"]
    var exercise = [Exercise]()
    var fetchedResultsController: NSFetchedResultsController<Exercise>?
    
    @IBAction func addExerciseButton(_ sender: UIBarButtonItem) {
        let randomExercise = exerciseList[Int(arc4random_uniform(UInt32(exerciseList.count)))]
        let repRandom = Int(arc4random_uniform(29) + 1)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Exercise", in: context)
        
        let exercise = Exercise(entity: entity!, insertInto: context)
        exercise.name = randomExercise
        exercise.count = Int32(repRandom)
        appDelegate.saveContext()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = collectionView!.frame.width / 2
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Exercise>(entityName: "Exercise")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: "ExerciseCache")
        fetchedResultsController?.delegate = self
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            fatalError("Unable to fetch: \(error)")
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController?.sections?[section] else {
            fatalError("Failed to load fetched results controller")
        }
        
        return sectionInfo.numberOfObjects
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let fetchedResultsController = fetchedResultsController else {
            fatalError("Failed to load fetched results controller")
        }
        
        let exercise = fetchedResultsController.object(at: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ExerciseItemCell

        cell.exerciseName.text = exercise.name
        cell.exerciseRep.text = String(exercise.count)
        return cell
    }

}

extension CollectionViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView?.performBatchUpdates( {() -> Void in }, completion: nil)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView?.reloadData()
    }
}

