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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controls?.forEach({ (elem) in
            let tap = UITapGestureRecognizer(target: self, action: #selector(ControllerViewController.depressButton(_:)))
            tap.delegate = self
            self.view.addGestureRecognizer(tap)
            self.view.addSubview(elem)
        })
        
        print(filenameToView)
    }
}


//Depress Button
extension ControllerViewController: UIGestureRecognizerDelegate {
    
    func depressButton(sender: UITapGestureRecognizer) {
        controls?.forEach({ (elem) in
            if CGRectContainsPoint(elem.frame, sender.locationInView(self.view)) {
                changeButtonToPressed(elem as! UIImageView)
            }
        })
    }
}

//Utility
extension ControllerViewController {
    
    func changeButtonToPressed(button: UIImageView) {
        let filename = filenameToView![button]
        let newFilename = filename! + "_pressed"
        let newImage = UIImage(named: newFilename)
        button.image = newImage
    }
    
}













