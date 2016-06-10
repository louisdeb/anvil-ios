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
      
        /* Temporary buttons */
        let button = UIButton()
        let buttonImage = UIImage(named: "element_10")
        let buttonPressedImage = UIImage(named: "element_10_pressed")
        button.setImage(buttonImage, forState: .Normal)
        button.setImage(buttonPressedImage, forState: .Highlighted)
        button.imageView?.contentMode = .ScaleAspectFit
        button.frame = CGRectMake(50, 100, 100, 100)
        mappedLetter![button] = "a"
        self.view.addSubview(button)
      
        button.addTarget(self, action: #selector(ControllerViewController.buttonPressed(_:)), forControlEvents: .TouchUpInside)
      
        let button2 = UIButton()
        let buttonImage2 = UIImage(named: "element_10")
        let buttonPressedImage2 = UIImage(named: "element_10_pressed")
        button2.setImage(buttonImage2, forState: .Normal)
        button2.setImage(buttonPressedImage2, forState: .Highlighted)
        button2.imageView?.contentMode = .ScaleAspectFit
        button2.frame = CGRectMake(50, 250, 100, 100)
        mappedLetter![button2] = "b"
        self.view.addSubview(button2)
        
        button2.addTarget(self, action: #selector(ControllerViewController.buttonPressed(_:)), forControlEvents: .TouchUpInside)
      
        let button3 = UIButton()
        let buttonImage3 = UIImage(named: "element_10")
        let buttonPressedImage3 = UIImage(named: "element_10_pressed")
        button3.setImage(buttonImage3, forState: .Normal)
        button3.setImage(buttonPressedImage3, forState: .Highlighted)
        button3.imageView?.contentMode = .ScaleAspectFit
        button3.frame = CGRectMake(50, 400, 100, 100)
        mappedLetter![button3] = "c"
        self.view.addSubview(button3)
        
        button3.addTarget(self, action: #selector(ControllerViewController.buttonPressed(_:)), forControlEvents: .TouchUpInside)
      
      let button4 = UIButton()
      let buttonImage4 = UIImage(named: "element_10")
      let buttonPressedImage4 = UIImage(named: "element_10_pressed")
      button4.setImage(buttonImage4, forState: .Normal)
      button4.setImage(buttonPressedImage4, forState: .Highlighted)
      button4.imageView?.contentMode = .ScaleAspectFit
      button4.frame = CGRectMake(190, 250, 100, 100)
      mappedLetter![button4] = "d"
      self.view.addSubview(button4)
      
      button4.addTarget(self, action: #selector(ControllerViewController.buttonPressed(_:)), forControlEvents: .TouchUpInside)
      
        /* -- */
      
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
        let letter = mappedLetter![sender]
        print(letter)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.keyPress(letter)
    }
}