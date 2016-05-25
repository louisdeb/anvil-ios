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
    
    
    @IBAction func placeElement(sender: AnyObject) {
        
        //Fix issue for no element being chose at the point of button press
        //Extend CGFloat?
        
        currentSelectedElement?.frame = CGRect(x: 200, y: 200, width: (currentSelectedElement?.frame.width)!, height: (currentSelectedElement?.frame.height)!)
        selectedItemOldX = Float((currentSelectedElement!.frame.origin.x))
        selectedItemOldY = Float((currentSelectedElement!.frame.origin.y))
        
        self.view.addSubview(currentSelectedElement!)
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

//Adding functionality for touches
extension UIBuilderViewController {
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch: UITouch = (event?.allTouches()?.first)!
        let touchLocation: CGPoint = touch.locationInView(self.view)
        
        if CGRectContainsPoint((currentSelectedElement?.frame)!, touchLocation) {
            itemBeingDragged = true
            selectedItemOldX = Float(touchLocation.x)
            selectedItemOldY = Float(touchLocation.y)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch: UITouch = (event?.allTouches()?.first)!
        let touchLocation: CGPoint = touch.locationInView(self.view)
        
        if itemBeingDragged {
            var frame: CGRect = (currentSelectedElement?.frame)!
            frame.origin.x = currentSelectedElement!.frame.origin.x + touchLocation.x - CGFloat(selectedItemOldX)
            frame.origin.y = currentSelectedElement!.frame.origin.y + touchLocation.y - CGFloat(selectedItemOldY)
            currentSelectedElement!.frame = frame
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        itemBeingDragged = false
    }
}