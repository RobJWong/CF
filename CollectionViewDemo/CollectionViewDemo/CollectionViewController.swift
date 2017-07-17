//
//  CollectionViewController.swift
//  CollectionViewDemo
//
//  Created by Robert Wong on 7/9/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit

//private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {
    
    var plantDataItems = [DataItem]()
    
    var animalDataItems = [DataItem]()
    var allItems = [[DataItem]]()

    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        let item = DataItem(title: "New Item", kind: .Animal, imageName: "images 2/default.jpeg")
        let index = allItems[0].count
        allItems[0].append(item)
        let indexPath = IndexPath(item: index, section: 0)
        collectionView?.insertItems(at: [indexPath])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = collectionView!.frame.width/3
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        for i in 1...12 {
            if i > 9 {
                plantDataItems.append(DataItem(title: "Title #\(i)", kind: Kind.Plant, imageName: "images 2/img\(i).jpg"))
            } else {
                plantDataItems.append(DataItem(title: "Title #0\(i)", kind: Kind.Plant, imageName: "images 2/img0\(i).jpg"))
            }
        }
        for i in 1...12 {
            if i > 9 {
                animalDataItems.append(DataItem(title: "Another Title #\(i)", kind: Kind.Animal, imageName: "images 2/anim\(i).jpg"))
            } else {
                animalDataItems.append(DataItem(title: "Another Title #0\(i)", kind: Kind.Animal, imageName: "images 2/anim0\(i).jpg"))
            }
        }
        
        allItems.append(plantDataItems)
        allItems.append(animalDataItems)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
    
//    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        let sectionItems = allItems[indexPath.section]
//        if indexPath.row >= sectionItems.count && isEditing {
//            return false
//        }
//        return true
//    }
//    
//    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        let itemToMove = allItems[sourceIndexPath.section][sourceIndexPath.row]
//        allItems[sourceIndexPath.section].remove(at: sourceIndexPath.row)
//        if sourceIndexPath.section == destinationIndexPath.section {
//            allItems[sourceIndexPath.section].insert(itemToMove, at: destinationIndexPath.row)
//        } else {
//            allItems[destinationIndexPath.section].insert(itemToMove, at:destinationIndexPath.row)
//        }
//    }
//    
//    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
//        let sectionItems = allItems[proposedDestinationIndexPath.section]
//        if proposedDestinationIndexPath.row >= sectionItems.count {
//            return IndexPath(row: sectionItems.count - 1, section: proposedDestinationIndexPath.section)
//        }
//        return proposedDestinationIndexPath
//    }
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as! DataItemHeader
        //let title = "Plants"
        //sectionHeader.title = title
        
        //return sectionHeader
        
        var title = ""
        if let kind = Kind(rawValue: indexPath.section) {
            title = kind.description()
        }
        sectionHeader.title = title
        
        return sectionHeader
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //return 1
        
        return allItems.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        //return plantDataItems.count
        
        return allItems[section].count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DataItemCell
        //let dataItem = plantDataItems[indexPath.row]
        //cell.dataItem = dataItem
        // Configure the cell
    
        //return cell
        
        let dataItem = allItems[indexPath.section][indexPath.row]
        cell.dataItem = dataItem
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
