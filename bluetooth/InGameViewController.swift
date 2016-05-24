//
//  InGameViewController.swift
//  bluetooth
//
//  Created by Jonny Goff-White on 20/05/2016.
//  Copyright © 2016 webapps. All rights reserved.
//

import UIKit
import CoreMotion

class InGameViewController: UIViewController {
    
    var motionManager: CMMotionManager!
    
    @IBOutlet weak var northArrow: UIImageView!
    @IBOutlet weak var eastArrow: UIImageView!
    @IBOutlet weak var southArrow: UIImageView!
    @IBOutlet weak var westArrow: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        northArrow.alpha = 0
        eastArrow.alpha  = 0
        southArrow.alpha = 0
        westArrow.alpha  = 0
        
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        
        motionManager.accelerometerUpdateInterval = (1/50)
        
        if (motionManager.accelerometerAvailable) {
            let queue = NSOperationQueue()
            motionManager.startAccelerometerUpdatesToQueue(queue, withHandler: { (accelerometerData: CMAccelerometerData?, error: NSError?) in
                dispatch_async(dispatch_get_main_queue(), { 
                    guard let data = accelerometerData else {
                        return
                    }
                    
                    if (data.acceleration.x >= 0) {
                        self.eastArrow.alpha = CGFloat(data.acceleration.x)
                    } else {
                        self.westArrow.alpha = CGFloat(-data.acceleration.x)
                    }
                    
                    if (data.acceleration.y >= 0) {
                        self.northArrow.alpha = CGFloat(data.acceleration.y)
                    } else {
                        self.southArrow.alpha = CGFloat(-data.acceleration.y)
                    }
                })
            })
        }
    }
    
    @IBAction func buttonPressed (sender: AnyObject) {
        performSegueWithIdentifier("toVariableButtonView", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //let url = NSURL(fileURLWithPath: "test.json")
        let url = NSURL(fileURLWithPath: "/Users/JHGWhite/Desktop/test.json")
        let data = NSData(contentsOfURL: url)
        let handler = JSONViewElementHandler()
        var components: ElementData?
        
        do {
            components = try handler.parseJSON(data!)
        } catch JSONError.IncorrectFormatError {
            print ("JSON format incorrect for parsing")
        } catch {
            print (error)
        }
        
        let dest = segue.destinationViewController as! VariableButtonViewController
        if components != nil { //shit practice, fix later
            dest.components = components!.elements
        }
    }
    
}
