//
//  DataItem.swift
//  TableViewDemo
//
//  Created by Robert Wong on 7/6/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit

class DataItem {
    
    var title: String
    var subtitle: String
    var image: UIImage?
    
    init(title: String, subtitle: String, imageName: String?) {
        self.title = title
        self.subtitle = subtitle
        if let imageName = imageName {
            if let img = UIImage(named: imageName) {
                image = img
            }
        }
    }
}
