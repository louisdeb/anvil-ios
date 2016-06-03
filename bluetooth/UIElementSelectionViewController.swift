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
    
    //Deprecated soon {
    var allAvailableElements: [UIView] = []
    var filenameToView: [UIView: String] = [:]
    // }
    
    var allAvailableButtons: [UIButton] = []
    
    let CELLS_PER_ROW = 4
    let UNIVERSAL_RESOURCE_PREFIX = "element_"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Deprecated soon {
        //Populate the array of elements that are available for use
        allAvailableElements = populateAvailableElementsFromResources(UNIVERSAL_RESOURCE_PREFIX)
        // }
        
        //Populate the array of buttons that are available for use
        allAvailableButtons = populateAvailableElementsAsButtonsFromResources(UNIVERSAL_RESOURCE_PREFIX)
        
        //Allow use of custom cell
        collectionView.registerClass(ElementCell.self, forCellWithReuseIdentifier:"cell1")
        
        //Set up of collection view
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //Opacity
        collectionView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(CGFloat(0.5))
        self.view.backgroundColor = collectionView.backgroundColor
    }
    
    
    @IBAction func unwindToInterfaceBuilder(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension UIElementSelectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //let cell: UICollectionViewCell = self.collection.dequeueReusableCellWithReuseIdentifier("cell1", forIndexPath: indexPath) as UICollectionViewCell
        let cell: ElementCell = self.collectionView.dequeueReusableCellWithReuseIdentifier("cell1", forIndexPath: indexPath) as! ElementCell
        

        //Get the corresponding element from the array of all possible element
        
        //let element:UIView = allAvailableElements[indexPath.row]
        let element = allAvailableButtons[indexPath.row]
        
        
        
        element.contentMode = .ScaleAspectFill
        
        //Set the custom class property element
        cell.element = element
        
        //add it to the subview
        cell.contentView.addSubview(element)
        element.center.x = cell.contentView.center.x
        element.center.y = cell.contentView.center.y
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //Number of elements available
        return allAvailableElements.count
    }
    
    //Collection View Cell pressed
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        builder?.currentSelectedElement = collectionView.cellForItemAtIndexPath(indexPath)?
//                                         .contentView.subviews.last
        print("selected item")
        print("builder: \(builder)")
        print("cell: \(collectionView.cellForItemAtIndexPath(indexPath) as! ElementCell)")
        builder?.currentSelectedElement = (collectionView.cellForItemAtIndexPath(indexPath) as! ElementCell).element
        print(builder?.currentSelectedElement)
        
        builder?.filenameToView = filenameToView
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

//Helper
extension UIElementSelectionViewController {
    func populateAvailableElementsFromResources(prefix: String = "", suffix: String = "") -> [UIView]{
        var elements = [UIView]()
        
        while let element = UIImage(named: "\(prefix)\(elements.count + 1)\(suffix)") {
            element.accessibilityIdentifier = "\(prefix)\(elements.count + 1)\(suffix)"
            let imageView = UIImageView(image: element)
            imageView.contentMode = .ScaleAspectFill

            //imageView.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin,
            //                              .FlexibleTopMargin, .FlexibleBottomMargin]
            filenameToView[imageView] = "\(prefix)\(elements.count + 1)\(suffix)"
            elements.append(imageView)
            
        }
        return elements
    }
    
    func populateAvailableElementsAsButtonsFromResources(prefix: String = "", suffix: String = "") -> [UIButton] {
        var elements = [UIButton]()
        
        while let elementImage = UIImage(named: "\(prefix)\(elements.count + 1)\(suffix)") {
            let button = UIButton()
            button.setImage(elementImage, forState: .Normal)
            button.setImage(UIImage(named: "\(prefix)\(elements.count + 1)\(suffix)_pressed"), forState: .Highlighted)
            button.contentMode = .ScaleAspectFill
            
            //There must be a better way of doing this:
            let temp = UIImageView(image: elementImage)
            temp.contentMode = .ScaleAspectFill
            button.frame = temp.frame
            
            button.userInteractionEnabled = false
            elements.append(button)
        }
        return elements
    }
}