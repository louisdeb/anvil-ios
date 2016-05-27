//
//  UIBuilderViewController.swift
//  bluetooth
//
//  Created by Jonny Goff-White on 24/05/2016.
//  Copyright © 2016 webapps. All rights reserved.
//

import Foundation
import UIKit

class UIBuilderViewController: UIViewController {
    
    let ELEMENT_SELECTION: String = "showElementSelection"
    
    var currentSelectedElement: UIView?
    var elementsOnScreen: [UIView] = []
    var elementsOnScreenWithReciprocal: [UIView: UIView?] = [:]
    
    // Capability for item that is being touched to be the selected item, and have
    // old values for x and y for each of them - which are changed when that is the item that
    // being dragged
    
    // Potential to make these optional?
    var selectedItemOldX: Float = 0
    var selectedItemOldY: Float = 0
    var itemBeingDragged: Bool  = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /* Function to check for touches - if the currentSelectedElement has a non-nil
     * value then place it at the location of the tap.
     */
    
    // Asserts that an element has been selected
    func placeElement(x: Float, y: Float, elem: UIView) {
        
        //Fix issue for no element being chose at the point of button press
        //Extend CGFloat?
        
        elem.frame = CGRect(x: CGFloat(x), y: CGFloat(y), width: elem.frame.width, height: elem.frame.height)
        elem.center.x = CGFloat(x)
        elem.center.y = CGFloat(y)
        selectedItemOldX = Float(elem.frame.origin.x)
        selectedItemOldY = Float(elem.frame.origin.y)
        
        elementsOnScreen.append(elem)
        self.view.addSubview(elem)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch (segue.identifier) {
            
        case ELEMENT_SELECTION?:
            let dest = segue.destinationViewController as! UIElementSelectionViewController 
            dest.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
            dest.builder = self
            
        default:
            return
        }
    }
    
    @IBAction func showElementSelection (sender: AnyObject) {
        performSegueWithIdentifier(ELEMENT_SELECTION, sender: sender)
    }
}


extension UIBuilderViewController {
    
    //Place the currently selected element at the location of the touch
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touches.forEach { (touch) in
            
            var selecting = false
            for elem in elementsOnScreen {
                if CGRectContainsPoint(elem.frame, touch.locationInView(self.view)) {

                    currentSelectedElement = elem
//                    currentSelectedElement?.layer.borderColor = UIColor.cyanColor().CGColor
//                    currentSelectedElement?.layer.cornerRadius = 5.0
//                    currentSelectedElement?.layer.borderWidth = 2
                    selecting = true
                }
            }
            
            if let elem = currentSelectedElement where !selecting {
                //To string - allow for optionals
                placeElement(Float(touch.locationInView(self.view).x), y: Float(touch.locationInView(self.view).y), elem: elem)
            }
        }
    }
}


/* Code for detecting pressed on a button and depressing button by changing image */
//var inView: Bool = false
//elementsOnScreen.forEach({ (elem) in
//    let touchLoc = touch.locationInView(self.view)
//    if CGRectContainsPoint(elem.frame, touchLoc) {
//        if elem is UIImageView {
//            let imgView = elem as! UIImageView
//            if let rec = elementsOnScreenWithReciprocal[imgView] {
//                print(elementsOnScreenWithReciprocal.count)
//                imgView.image = (rec as! UIImageView).image
//            }
//        }
//        inView = true
//    }
//})


////Adding functionality for touches
//extension UIBuilderViewController {
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//
//        let touch: UITouch = (event?.allTouches()?.first)!
//        let touchLocation: CGPoint = touch.locationInView(self.view)
//        
//        if CGRectContainsPoint((currentSelectedElement?.frame)!, touchLocation) {
//            itemBeingDragged = true
//            selectedItemOldX = Float(touchLocation.x)
//            selectedItemOldY = Float(touchLocation.y)
//
//            
//        }
//    }
//    
//    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        let touch: UITouch = (event?.allTouches()?.first)!
//        let touchLocation: CGPoint = touch.locationInView(self.view)
//        
//        if itemBeingDragged {
//            var frame: CGRect = (currentSelectedElement?.frame)!
//            frame.origin.x = currentSelectedElement!.frame.origin.x + touchLocation.x - CGFloat(selectedItemOldX)
//            frame.origin.y = currentSelectedElement!.frame.origin.y + touchLocation.y - CGFloat(selectedItemOldY)
//            currentSelectedElement!.frame = frame
//        }
//    }
//    
//    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        itemBeingDragged = false
//    }
//}