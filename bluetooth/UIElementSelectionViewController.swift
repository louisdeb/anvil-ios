//
//  UIElementSelectionViewController.swift
//  bluetooth
//
//  Created by Jonny Goff-White on 24/05/2016.
//  Copyright © 2016 webapps. All rights reserved.
//

import Foundation
import UIKit

class UIElementSelectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var builder: UIBuilderViewController?
    
    let test = ["item 1"]
    
    let cellsPerRow = 4
    let cellSpacing = 1
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    @IBOutlet weak var collection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundColor = UIColor.whiteColor()
    }
}

extension UIElementSelectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = self.collection.dequeueReusableCellWithReuseIdentifier("cell1", forIndexPath: indexPath) as UICollectionViewCell
        
        
        
        let image:UIImage = UIImage(contentsOfFile: "Users/JHGWhite/Desktop/button.jpg")!
        let imageView = UIImageView(image: image)
        imageView.frame = cell.frame
        cell.contentView.addSubview(imageView)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return test.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        builder?.currentSelectedElement = collectionView.cellForItemAtIndexPath(indexPath)?
                                         .contentView.subviews.last
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

//Subclass the collection view cell with a property of my content.



