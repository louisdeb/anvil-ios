//
//  ConfigSelectTableViewController.swift
//  bluetooth
//
//  Created by Jono Muller on 13/06/2016.
//  Copyright © 2016 webapps. All rights reserved.
//

import UIKit

class ConfigSelectTableViewController: UITableViewController {

    var configs: [AnyObject] = []
    
    let PAN_TRANSLATION_MIN: CGFloat = 200
    let CONTROLLER_SEGUE = "controllerSegue"
    var jsonString : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let accounts = SSKeychain.accountsForService("Anvil") as NSArray
        var username = String()
        
        if accounts.count > 0 {
            let credentials = accounts[0] as! NSDictionary
            username = credentials.objectForKey(kSSKeychainAccountKey) as! String
        }
        
        configs = SaveConfig.getConfigurations(username)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        let tableSelection = self.tableView.indexPathForSelectedRow! as NSIndexPath;
//        self.tableView.deselectRowAtIndexPath(tableSelection, animated: false)
        self.navigationController!.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
        self.navigationController!.navigationBar.tintColor = UIColor.init(colorLiteralRed: 0, green: 0.478431, blue: 1.0, alpha: 1.0);
        let backButton = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: #selector(backButtonPressed))
        self.navigationItem.leftBarButtonItem = backButton;
    }
    
    @IBAction func handlePan (sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(self.view)
        if (fabs((translation.y)) > PAN_TRANSLATION_MIN) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: {})
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return configs.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("configCell", forIndexPath: indexPath)
        let config = configs[indexPath.row] as! NSDictionary
        cell.textLabel?.text = config.objectForKey("name") as? String
        cell.detailTextLabel?.text = config.objectForKey("username") as? String
        let url = NSURL(string: config.objectForKey("img") as! String)
        let data = NSData(contentsOfURL: url!)
        cell.imageView?.image = UIImage(data: data!)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let config = configs[indexPath.row] as! NSDictionary
        jsonString = (config.objectForKey("json") as? String)!
        self.performSegueWithIdentifier(self.CONTROLLER_SEGUE, sender: self)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200;
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.navigationController!.navigationBar.setBackgroundImage(UIImage.init(), forBarMetrics: .Default)
        self.navigationController!.navigationBar.shadowImage = UIImage.init();
        self.navigationController!.navigationBar.translucent = true;
        self.navigationController!.view.backgroundColor = UIColor.clearColor();
        self.navigationController!.navigationBar.backgroundColor = UIColor.clearColor();
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor();
        if segue.identifier == CONTROLLER_SEGUE {
            let dest = segue.destinationViewController as! ControllerViewController
            dest.controls = SaveConfig.getButtonsFromJSON(self.jsonString) as? [UIView]
        }
    }
    

}
