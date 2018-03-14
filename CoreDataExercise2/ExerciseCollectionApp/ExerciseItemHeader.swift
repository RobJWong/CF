//
//  ExerciseItemHeader.swift
//  ExerciseCollectionApp
//
//  Created by Robert Wong on 7/17/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit

class ExerciseItemHeader: UICollectionReusableView {
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
}
