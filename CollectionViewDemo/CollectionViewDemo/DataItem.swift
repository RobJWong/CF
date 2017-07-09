//
//  DataItem.swift
//  CollectionViewDemo
//
//  Created by Robert Wong on 7/9/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit

class DataItem {
    var title: String
    var kind: Kind
    var imageName: String
    
    init (title: String, kind: Kind, imageName: String) {
        self.title = title
        self.kind = kind
        self.imageName = imageName
    }
}

enum Kind: Int {
    case Plant
    case Animal
        
    func description() -> String{
    switch self {
    case .Plant:
        return "Plants"
    case .Animal:
        return "Animals"
        }
    }
}
