//
//  DataItem.swift
//  CrossViewApp
//
//  Created by Robert Wong on 7/25/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit

class DataItem {
    
    //var image: UIImage?
    var imageName: UIImage?
    
    init() {
        let random = Int(arc4random_uniform(15) + 1)
//        if let img = UIImage(named:"CrossViewAppImages/Image\(random).jpg") {
//            image = img
//        }
        self.imageName = UIImage(named: "CrossViewAppImages/Image\(random).jpg")
    }
}
