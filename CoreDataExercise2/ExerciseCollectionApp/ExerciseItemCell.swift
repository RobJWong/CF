//
//  ExerciseItemCell.swift
//  ExerciseCollectionApp
//
//  Created by Robert Wong on 7/14/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit

class ExerciseItemCell: UICollectionViewCell {
    
    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var exerciseRep: UILabel!
    
    
//    var exerciseItem: ExerciseSet? {
//        didSet {
//            if let exerciseItem = exerciseItem {
//                exerciseName.text = exerciseItem.exerciseName
//                exerciseRep.text = String(exerciseItem.reps)
//            }
//        }
//    }
}
