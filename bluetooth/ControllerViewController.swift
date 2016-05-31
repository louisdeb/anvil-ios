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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controls?.forEach({ (elem) in
            self.view.addSubview(elem)
        })
    }
}
