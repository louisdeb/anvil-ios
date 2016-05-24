//
//  VariableButtonViewController.swift
//  bluetooth
//
//  Created by Jonny Goff-White on 24/05/2016.
//  Copyright © 2016 webapps. All rights reserved.
//

import Foundation
import UIKit

class VariableButtonViewController: UIViewController {
    
    var components: [UIView]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for view in components! {
            print((view as! UIButton).frame.width)
            print((view as! UIButton).frame.height)
            self.view.addSubview(view)
        }
        
        for view in self.components! {
            let view = view as! UIButton
            
            view.addTarget(self, action: #selector(VariableButtonViewController.buttonPressed(_:)), forControlEvents: .TouchUpInside)
        }
    }
    
    func buttonPressed (sender: AnyObject?) {
        print("a button was pressed")
    }
    
}
