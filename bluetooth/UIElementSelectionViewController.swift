//
//  UIElementSelectionViewController.swift
//  bluetooth
//
//  Created by Jonny Goff-White on 24/05/2016.
//  Copyright © 2016 webapps. All rights reserved.
//

import Foundation
import UIKit

class UIElementSelectionViewController: UIViewController, UICollectionViewDataSource {
    
    let test = ["item 1", "item 2"]
    
    @IBOutlet weak var collection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.dataSource = self
        collection.backgroundColor = UIColor.whiteColor()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = self.collection.dequeueReusableCellWithReuseIdentifier("cell1", forIndexPath: indexPath) as UICollectionViewCell
        
        let image:UIImage = UIImage(contentsOfFile: "Users/JHGWhite/Desktop/button.jpg")!
        let imageView = UIImageView(image: image)
        cell.contentView.addSubview(imageView)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return test.count
    }
    
    
}
