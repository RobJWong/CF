//
//  CellData.swift
//  Travels
//
//  Created by Robert Wong on 1/17/18.
//  Copyright © 2018 Robert Wong. All rights reserved.
//

import Foundation

struct CityDataCell {
    var imageURL: String?
    var imageText: String?
    
    init(imageURL: String, imageText:String) {
        self.imageURL = imageURL
        self.imageText = imageText
    }
}
