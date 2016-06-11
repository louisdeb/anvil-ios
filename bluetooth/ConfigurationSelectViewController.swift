//
//  ConfigurationSelectViewController.swift
//  bluetooth
//
//  Created by Jonny Goff-White on 11/06/2016.
//  Copyright © 2016 webapps. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class SwiftConfigurationSelectViewController: UIViewController {
    
    /* See extension */
    @IBOutlet var tableView: UITableView!
    
    var configs: [AnyObject] = ["this", "is", "a", "placeholder"]
    
    let PAN_TRANSLATION_MIN: CGFloat = 200
    let CONTROLLER_SEGUE = "controllerSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    @IBAction func selectView (sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var codes: [NSNumber] = []
        
        /* Hard coded */
        var num: NSNumber = 0
        codes.append(num)
        num = NSNumber(integer: 1)
        codes.append(num)
        num = NSNumber(integer: 2)
        codes.append(num)
        num = NSNumber(integer: 13)
        codes.append(num)
        num = NSNumber(integer: 49)
        codes.append(num)
        num = NSNumber(integer: 12)
        codes.append(num)
        num = NSNumber(integer: 3)
        codes.append(num)
        num = NSNumber(integer: 14)
        codes.append(num)
        num = NSNumber(integer: 46)
        codes.append(num)
        num = NSNumber(integer: 123)
        codes.append(num)
        num = NSNumber(integer: 124)
        codes.append(num)
        num = NSNumber(integer: 125)
        codes.append(num)
        num = NSNumber(integer: 126)
        codes.append(num)
        /* --- */
        
        appDelegate.addKeyService(NSMutableArray(array: codes))
        self.performSegueWithIdentifier(CONTROLLER_SEGUE, sender: sender)
        
        
    }
    
    @IBAction func handlePan (sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(self.view)
        if (fabs((translation.y)) > PAN_TRANSLATION_MIN) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
}

extension SwiftConfigurationSelectViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return configs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("configCell")! as UITableViewCell
        cell.textLabel?.text = configs[indexPath.row] as? String
        cell.detailTextLabel?.text = "Row: \(indexPath.row)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}