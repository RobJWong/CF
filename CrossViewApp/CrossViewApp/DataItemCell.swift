//
//  DataItemCell.swift
//  CrossViewApp
//
//  Created by Robert Wong on 7/27/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit

class DataItemCell: UICollectionViewCell {
    
    @IBOutlet private weak var dataItemImageView: UIImageView!
    
    var dataItem: DataItem? {
        didSet {
            if let dataItem = dataItem {
                dataItemImageView.image = dataItem.imageName
            }
        }
    }
    
}
