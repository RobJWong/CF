//
//  DataItemCell.swift
//  CollectionViewDemo
//
//  Created by Robert Wong on 7/9/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit

class DataItemCell: UICollectionViewCell {
    
    @IBOutlet private weak var dataItemImageView: UIImageView!
    
    var dataItem: DataItem? {
        didSet {
            if let dataItem = dataItem{
                dataItemImageView.image = UIImage(named: dataItem.imageName)
            }
        }
    }
}
