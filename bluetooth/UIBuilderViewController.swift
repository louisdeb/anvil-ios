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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch (segue.identifier) {
            
        case ELEMENT_SELECTION?:
            let dest = segue.destinationViewController
            dest.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
            
        default:
            return
        }
    }
    
    @IBAction func showElementSelection (sender: AnyObject) {
        performSegueWithIdentifier("showElementSelection", sender: sender)
    }
}
