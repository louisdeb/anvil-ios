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
    
    var configs: [AnyObject] = []
    
    let PAN_TRANSLATION_MIN: CGFloat = 200
    let CONTROLLER_SEGUE = "controllerSegue"
    var jsonString : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        let accounts = SSKeychain.accountsForService("Anvil") as NSArray
        var username = String()
        
        if accounts.count > 0 {
            let credentials = accounts[0] as! NSDictionary
            username = credentials.objectForKey(kSSKeychainAccountKey) as! String
        }
        
        configs = SaveConfig.getConfigurations(username)
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
        let config = configs[indexPath.row] as! NSDictionary
        cell.textLabel?.text = config.objectForKey("name") as? String
        cell.detailTextLabel?.text = config.objectForKey("username") as? String
        let url = NSURL(string: config.objectForKey("img") as! String)
        let data = NSData(contentsOfURL: url!)
        cell.imageView?.image = UIImage(data: data!)
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == CONTROLLER_SEGUE {
            let dest = segue.destinationViewController as! ControllerViewController
            dest.controls = SaveConfig.getButtonsFromJSON(self.jsonString) as? [UIView]
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let config = configs[indexPath.row] as! NSDictionary
        jsonString = (config.objectForKey("json") as? String)!
        self.performSegueWithIdentifier(self.CONTROLLER_SEGUE, sender: self)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200;
    }
    
}