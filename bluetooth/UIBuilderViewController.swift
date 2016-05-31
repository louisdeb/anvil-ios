//
//  UIBuilderViewController.swift
//  bluetooth
//
//  Created by Jonny Goff-White on 24/05/2016.
//  Copyright © 2016 webapps. All rights reserved.
//

import Foundation
import UIKit

class UIBuilderViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let ELEMENT_SELECTION: String = "showElementSelection"
    let ATTRIBUTE_CONFIGURATION: String = "toAttributeConfiguration"
    let CONTROLLER: String = "toController"
    
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIBuilderViewController.handleTap(_:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(UIBuilderViewController.handlePinch(_:)))
        pinch.delegate = self
        self.view.addGestureRecognizer(pinch)
        
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(UIBuilderViewController.handleRotate(_:)))
        rotate.delegate = self
        self.view.addGestureRecognizer(rotate)
        
        let drag = UIPanGestureRecognizer(target: self, action: #selector(UIBuilderViewController.handlePan(_:)))
        drag.delegate = self
        self.view.addGestureRecognizer(drag)
    }
    
    func handlePinch(sender: UIPinchGestureRecognizer) {
        elementsOnScreen.forEach { (elem) in
            if CGRectContainsPoint(elem.frame, sender.locationInView(self.view)) {
                elem.transform = CGAffineTransformScale(elem.transform, sender.scale, sender.scale)
                sender.scale = 1
            }
        }
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
//        var selecting = false
//        for elem in elementsOnScreen {
//            if CGRectContainsPoint(elem.frame, sender.locationInView(self.view)) {
//                currentSelectedElement = elem
//                selecting = true
//            }
//        }
        
        if let elem = currentSelectedElement where !elementsOnScreen.contains(elem) {
            //To string - allow for optionals
            placeElement(Float(sender.locationInView(self.view).x), y: Float(sender.locationInView(self.view).y), elem: elem)
        }
    }
    
    
    func handleRotate(sender: UIRotationGestureRecognizer) {
        for elem in elementsOnScreen {
            if CGRectContainsPoint(elem.frame, sender.locationInView(self.view)) {
                elem.transform = CGAffineTransformRotate(elem.transform, sender.rotation)
                sender.rotation = 0
            }
        }
    }
    
    func handlePan(sender: UIPanGestureRecognizer) {
        for elem in elementsOnScreen {
            if CGRectContainsPoint(elem.frame, sender.locationInView(self.view)) {
                let translation: CGPoint = sender.translationInView(self.view)
                elem.center = CGPointMake(elem.center.x + translation.x,
                                          elem.center.y + translation.y)
                sender.setTranslation(CGPointMake(0, 0), inView: self.view)
            }
        }
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
        case CONTROLLER?:
            let dest = segue.destinationViewController as! ControllerViewController
            dest.controls = self.elementsOnScreen
        default:
            return
        }
    }
    
    @IBAction func showControllerScreen (sender: AnyObject) {
        performSegueWithIdentifier(CONTROLLER, sender: sender)
    }
    
    @IBAction func showElementSelection (sender: AnyObject) {
        performSegueWithIdentifier(ELEMENT_SELECTION, sender: sender)
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