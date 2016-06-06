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
    
    var mappedLetter: [UIView: Character]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controls?.forEach({ (elem) in 
            
            elem.userInteractionEnabled = true
            self.view.addSubview(elem)
            if elem is UIButton {
                let button = elem as! UIButton
                button.addTarget(self, action: #selector(ControllerViewController.buttonPressed(_:)), forControlEvents: .TouchUpInside)
            }
        })
    }
    
    func buttonPressed(sender: UIButton) {
        print(mappedLetter![sender])
    }
}