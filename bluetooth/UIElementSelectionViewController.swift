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
    
    var allAvailableElements: [UIView] = []
    
    let CELLS_PER_ROW = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Populate the array of elements that are available for use
        allAvailableElements = populateAvailableElementsFromResources("element_")
        print(allAvailableElements.count)
        
        collectionView.registerClass(ElementCell.self, forCellWithReuseIdentifier:"cell1")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.whiteColor()
    }
}

extension UIElementSelectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //let cell: UICollectionViewCell = self.collection.dequeueReusableCellWithReuseIdentifier("cell1", forIndexPath: indexPath) as UICollectionViewCell
        let cell: ElementCell = self.collectionView.dequeueReusableCellWithReuseIdentifier("cell1", forIndexPath: indexPath) as! ElementCell
        

        //Get the corresponding element from the array of all possible elements
        let element:UIView = allAvailableElements[indexPath.row]
        element.contentMode = .ScaleAspectFill
        
//        let newCellFrame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, 128.0, 128.0)
//        cell.frame = newCellFrame
        
        
        //let newElementFrame = CGRectMake(newCellFrame.origin.x, newCellFrame.origin.y, element.frame.width, element.frame.height)
        
        //element.frame = newElementFrame
        
        //print(cell.frame)
        
        //Set the custom class property element
        cell.element = element
        
        //add it to the subview
        cell.contentView.addSubview(element)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //Number of elements available
        return allAvailableElements.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        builder?.currentSelectedElement = collectionView.cellForItemAtIndexPath(indexPath)?
//                                         .contentView.subviews.last
        print("selected item")
        print("builder: \(builder)")
        print("cell: \(collectionView.cellForItemAtIndexPath(indexPath) as! ElementCell)")
        builder?.currentSelectedElement = (collectionView.cellForItemAtIndexPath(indexPath) as! ElementCell).element
        print(builder?.currentSelectedElement)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}


//Formatting
extension UIElementSelectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenDims = UIScreen.mainScreen().bounds
        let screenWidth = screenDims.width
        let cellWidth = screenWidth/CGFloat(CELLS_PER_ROW)
        let size = CGSizeMake(cellWidth, cellWidth)
        return size
    }
}



//Subclass the collection view cell with a property of my content.

class ElementCell: UICollectionViewCell {
    
    var element: UIView?
    
    func removeFromSubView() -> UIView? {
        for view in self.subviews {
            if view == element {
                self.subviews[self.subviews.indexOf(view)!].removeFromSuperview()
                return element
            }
        }
        return nil
    }
}

func populateAvailableElementsFromResources(prefix: String = "", suffix: String = "") -> [UIView]{
    var elements = [UIView]()
    
    while let element = UIImage(named: "\(prefix)\(elements.count + 1)\(suffix)") {
        //To scale properly
        let imageView = UIImageView(image: element)
        imageView.contentMode = .ScaleAspectFill
        elements.append(imageView)
    }
    return elements
}






















