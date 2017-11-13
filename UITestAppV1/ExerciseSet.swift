//
//  ExerciseSet.swift
//  ExerciseCollectionApp
//
//  Created by Robert Wong on 7/13/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit

class ExerciseSet {
    
    var exerciseName: String
    var reps: Int
    var randomExercises: [String] = ["Squats", "Jumping Jacks", "Push Ups", "Crunches", "Bicycle Kicks",
                                     "Lunges", "Burpies", "Knee Jumps", "Pull Ups", "Hip Raise"]
    
    init() {
        let repRandom = Int(arc4random_uniform(5) + 1)
        let exerciseRandom = Int(arc4random_uniform(10))
        self.exerciseName = randomExercises[exerciseRandom]
        self.reps = repRandom * 5
    }
    
}
