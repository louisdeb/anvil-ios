//
//  ConfigurationSelectViewController.swift
//  bluetooth
//
//  Created by Jonny Goff-White on 11/06/2016.
//  Copyright © 2016 webapps. All rights reserved.
//

import Foundation
import UIKit

class SwiftConfigurationSelectViewController: UIViewController {
    
    let PAN_TRANSLATION_MIN: CGFloat = 200
    let CONTROLLER_SEGUE = "controllerSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func selectView (sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var codes: [NSNumber] = []
        
        /* Hard coded */
        var num: NSNumber = 0
        codes.append(num)
        num = NSNumber(integer: 1)
        codes.append(num)
        num = NSNumber(integer: 2)
        codes.append(num)
        num = NSNumber(integer: 13)
        codes.append(num)
        num = NSNumber(integer: 49)
        codes.append(num)
        num = NSNumber(integer: 12)
        codes.append(num)
        num = NSNumber(integer: 3)
        codes.append(num)
        num = NSNumber(integer: 14)
        codes.append(num)
        num = NSNumber(integer: 46)
        codes.append(num)
        num = NSNumber(integer: 123)
        codes.append(num)
        num = NSNumber(integer: 124)
        codes.append(num)
        num = NSNumber(integer: 125)
        codes.append(num)
        num = NSNumber(integer: 126)
        codes.append(num)
        /* --- */
        
        appDelegate.addKeyService(NSMutableArray(array: codes))
        self.performSegueWithIdentifier(CONTROLLER_SEGUE, sender: sender)
        
        
    }
    
    @IBAction func handlePan (sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(self.view)
        if (fabs((translation.y)) > PAN_TRANSLATION_MIN) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
}

//extension ConfigurationSelectViewController: UITableViewDelegate, UITableViewDataSource {
//    
//}