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
        let buttonImage = UIImage(named: "element_15")
        let buttonPressedImage = UIImage(named: "element_10_pressed")
        button.setImage(buttonImage, forState: .Normal)
        //button.setImage(buttonPressedImage, forState: .Highlighted)
        button.imageView?.contentMode = .ScaleAspectFit
        button.frame = CGRectMake(50, 100, 100, 100)
        mappedLetter![button] = "a"
        self.view.addSubview(button)

        let button2 = UIButton()
        let buttonImage2 = UIImage(named: "element_17")
        let buttonPressedImage2 = UIImage(named: "element_10_pressed")
        button2.setImage(buttonImage2, forState: .Normal)
        //button2.setImage(buttonPressedImage2, forState: .Highlighted)
        button2.imageView?.contentMode = .ScaleAspectFit
        button2.frame = CGRectMake(50, 250, 100, 100)
        mappedLetter![button2] = "s"
        self.view.addSubview(button2)
      
        let button3 = UIButton()
        let buttonImage3 = UIImage(named: "element_16")
        let buttonPressedImage3 = UIImage(named: "element_10_pressed")
        button3.setImage(buttonImage3, forState: .Normal)
        //button3.setImage(buttonPressedImage3, forState: .Highlighted)
        button3.imageView?.contentMode = .ScaleAspectFit
        button3.frame = CGRectMake(50, 400, 100, 100)
        mappedLetter![button3] = "d"
        self.view.addSubview(button3)
      
        let button4 = UIButton()
        let buttonImage4 = UIImage(named: "element_18")
        let buttonPressedImage4 = UIImage(named: "element_10_pressed")
        button4.setImage(buttonImage4, forState: .Normal)
        //button4.setImage(buttonPressedImage4, forState: .Highlighted)
        button4.imageView?.contentMode = .ScaleAspectFit
        button4.frame = CGRectMake(190, 250, 100, 100)
        mappedLetter![button4] = "w"
        self.view.addSubview(button4)
      
        let button5 = UIButton()
        let buttonImage5 = UIImage(named: "element_10")
        let buttonPressedImage5 = UIImage(named: "element_10_pressed")
        button5.setImage(buttonImage5, forState: .Normal)
        //button4.setImage(buttonPressedImage4, forState: .Highlighted)
        button5.imageView?.contentMode = .ScaleAspectFit
        button5.frame = CGRectMake(190, 450, 100, 100)
        mappedLetter![button5] = "SPACE"
        self.view.addSubview(button5)
      
        button.addTarget(self, action: #selector(ControllerViewController.buttonPressedDown(_:)), forControlEvents: .TouchDown)
        button.addTarget(self, action: #selector(ControllerViewController.buttonPressedUp(_:)), forControlEvents: [.TouchUpInside, .TouchUpOutside])
        button2.addTarget(self, action: #selector(ControllerViewController.buttonPressedDown(_:)), forControlEvents: .TouchDown)
        button2.addTarget(self, action: #selector(ControllerViewController.buttonPressedUp(_:)), forControlEvents: [.TouchUpInside, .TouchUpOutside])
        button3.addTarget(self, action: #selector(ControllerViewController.buttonPressedDown(_:)), forControlEvents: .TouchDown)
        button3.addTarget(self, action: #selector(ControllerViewController.buttonPressedUp(_:)), forControlEvents: [.TouchUpInside, .TouchUpOutside])
        button4.addTarget(self, action: #selector(ControllerViewController.buttonPressedDown(_:)), forControlEvents: .TouchDown)
        button4.addTarget(self, action: #selector(ControllerViewController.buttonPressedUp(_:)), forControlEvents: [.TouchUpInside, .TouchUpOutside])
        button5.addTarget(self, action: #selector(ControllerViewController.buttonPressedDown(_:)), forControlEvents: .TouchDown)
        button5.addTarget(self, action: #selector(ControllerViewController.buttonPressedUp(_:)), forControlEvents: [.TouchUpInside, .TouchUpOutside])
      
        /* -- */
      
        controls?.forEach({ (elem) in 
            
            elem.userInteractionEnabled = true
            
            if elem is UIButton {
                let button = elem as! UIButton
                button.addTarget(self, action: #selector(ControllerViewController.buttonPressedDown(_:)), forControlEvents: .TouchDown)
                button.addTarget(self, action: #selector(ControllerViewController.buttonPressedUp(_:)), forControlEvents: [.TouchUpInside, .TouchUpOutside])
            }
            
            self.view.addSubview(elem)
        })
        
        SaveConfig.saveConfiguration(self.view, configUser: "jonomuller", configName: "Test Configuration")
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