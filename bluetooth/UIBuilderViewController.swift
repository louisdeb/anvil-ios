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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    /* Function to check for touches - if the currentSelectedElement has a non-nil
     * value then place it at the location of the tap.
     */
    
    
    @IBAction func placeElement(sender: AnyObject) {
        
        currentSelectedElement?.frame = CGRect(x: 200, y: 200, width: 200, height: 200)
        self.view.addSubview(currentSelectedElement!)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch (segue.identifier) {
            
        case ELEMENT_SELECTION?:
            let dest = segue.destinationViewController as! UIElementSelectionViewController
            dest.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
            
            
        default:
            return
        }
    }
    
    @IBAction func showElementSelection (sender: AnyObject) {
        performSegueWithIdentifier("showElementSelection", sender: sender)
    }
}

class UIElement: UIView {
    
}