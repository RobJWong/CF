//
//  ExceriseSet.swift
//  ExceriseTableAppV2
//
//  Created by Robert Wong on 7/9/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit

class ExceriseSet {
    
    var exceriseName: String
    var reps: Int
    var randomExcerises: [String] = ["Squats", "Jumping Jacks", "Push Ups", "Crunches", "Bicycle Kicks",
                                     "Lunges", "Burpies", "Knee Jumps", "Pull Ups", "Hip Raise"]
    
    init() {
        let repRandom = Int(arc4random_uniform(5) + 1)
        let exceriseRandom = Int(arc4random_uniform(10))
        self.exceriseName = randomExcerises[exceriseRandom]
        self.reps = repRandom * 5
    }
    
}
