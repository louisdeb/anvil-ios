//
//  JSONViewElementHandler.swift
//  bluetooth
//
//  Created by Jonny Goff-White on 23/05/2016.
//  Copyright © 2016 webapps. All rights reserved.
//

import Foundation
import UIKit

struct ElementData {
    var elements: [UIView]
}

enum JSONError: ErrorType {
    case IncorrectFormatError
}

class JSONViewElementHandler {
    
    func parseJSON (source: NSData) throws -> ElementData {
        do {
            guard let json: NSDictionary = try NSJSONSerialization.JSONObjectWithData(source, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary else {
                throw JSONError.IncorrectFormatError
            }
            
            guard let elements = json["elements"] as? NSDictionary else {
                print("Incorrect format of JSON input")
                throw JSONError.IncorrectFormatError
            }
            
            var components: ElementData = ElementData(elements: [UIView]())
            for (elemType, elemListDict) in elements {
                
                //Will always be String
                let elemType = elemType as! String
                guard let elemListDict = elemListDict as? NSDictionary else {
                    throw JSONError.IncorrectFormatError
                }
                
                switch (elemType) {
                    case "buttons":
                    for (name, attributes) in elemListDict {
                        let name = name as! String
                        guard let attributes = attributes as? NSDictionary else {
                            throw JSONError.IncorrectFormatError
                        }
                        //Needs error handling
                        let width: Int  = attributes["width"] as! Int
                        let height: Int = attributes["height"] as! Int
                        let xPos: Int   = attributes["x_pos"] as! Int
                        let yPos: Int   = attributes["y_pos"] as! Int
                        
                        let button = UIButton(frame: CGRect(x: xPos, y: yPos, width: width, height: height))
                        button.setTitle(name, forState: UIControlState.Normal)
                        button.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
                        components.elements.append(button)
                        
                    }
                    
                    default:
                    throw JSONError.IncorrectFormatError
                    
                }
                
            }
            
            return components
            
            
        } catch {
            print("Error reading JSON")
        }
        throw JSONError.IncorrectFormatError
    }
    
}






