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
      
        let button = UIButton()
        let buttonImage = UIImage(named: "element_10")
        let buttonPressedImage = UIImage(named: "element_10_pressed")
        button.setImage(buttonImage, forState: .Normal)
        button.setImage(buttonPressedImage, forState: .Highlighted)
        button.imageView?.contentMode = .ScaleAspectFit
        button.frame = CGRectMake(200, 200, 100, 100)
        mappedLetter![button] = "k"
        self.view.addSubview(button)
      
        button.addTarget(self, action: #selector(ControllerViewController.buttonPressed(_:)), forControlEvents: .TouchUpInside)
        
        controls?.forEach({ (elem) in 
            
            elem.userInteractionEnabled = true
            
            if elem is UIButton {
                let button = elem as! UIButton
                button.addTarget(self, action: #selector(ControllerViewController.buttonPressed(_:)), forControlEvents: .TouchUpInside)
            }
            
            self.view.addSubview(elem)
        })
    }
    
    func buttonPressed(sender: UIButton) {
        print(mappedLetter![sender])
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.keyPress(10)
    }
}