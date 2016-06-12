//
//  ControllerViewController.swift
//  bluetooth
//
//  Created by Jonny Goff-White on 30/05/2016.
//  Copyright © 2016 webapps. All rights reserved.
//

import Foundation
import UIKit

class ControllerViewController: UIViewController {
    
    var controls: [UIView]?
    var filenameToView: [UIView: String]?
    
    var mappedLetter: [UIView: String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mappedLetter = [:]
      
        controls?.forEach({ (elem) in 
            
            elem.userInteractionEnabled = true
            
            if elem is UIButton {
                let button = elem as! UIButton
                button.addTarget(self, action: #selector(ControllerViewController.buttonPressedDown(_:)), forControlEvents: .TouchDown)
                button.addTarget(self, action: #selector(ControllerViewController.buttonPressedUp(_:)), forControlEvents: [.TouchUpInside, .TouchUpOutside])
            }
            
            self.view.addSubview(elem)
        })
    }
    
    func buttonPressedDown(sender: UIButton) {
        let letter = mappedLetter![sender]
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.keyPress(letter, state: true)
    }
  
    func buttonPressedUp(sender: UIButton) {
      let letter = mappedLetter![sender]
      let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
      appDelegate.keyPress(letter, state: false)
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
    }
}