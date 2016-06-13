//
//  UIBuilderViewController.swift
//  bluetooth
//
//  Created by Jonny Goff-White on 24/05/2016.
//  Copyright © 2016 webapps. All rights reserved.
//

import Foundation
import UIKit

class UIBuilderViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let ELEMENT_SELECTION: String = "showElementSelection"
    let ATTRIBUTE_CONFIGURATION: String = "toAttributeConfiguration"
    let CONTROLLER: String = "toController"
    
    var currentSelectedElement: UIView?
    var elementsOnScreen: [UIView] = []
    
    var filenameToView: [UIView: String]?
    
    var mappedLetter: [UIView: String] = [:]
    
    // Capability for item that is being touched to be the selected item, and have
    // old values for x and y for each of them - which are changed when that is the item that
    // being dragged
    
    // Potential to make these optional?
    var selectedItemOldX: Float = 0
    var selectedItemOldY: Float = 0
    var itemBeingDragged: Bool  = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIBuilderViewController.handleTap(_:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(UIBuilderViewController.handlePinch(_:)))
        pinch.delegate = self
        self.view.addGestureRecognizer(pinch)
        
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(UIBuilderViewController.handleRotate(_:)))
        rotate.delegate = self
        self.view.addGestureRecognizer(rotate)
        
        let drag = UIPanGestureRecognizer(target: self, action: #selector(UIBuilderViewController.handlePan(_:)))
        drag.delegate = self
        self.view.addGestureRecognizer(drag)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(UIBuilderViewController.handleLongPress(_:)))
        longPress.delegate = self
        self.view.addGestureRecognizer(longPress)
    }
    
    func handlePinch(sender: UIPinchGestureRecognizer) {
        elementsOnScreen.forEach { (elem) in
            if CGRectContainsPoint(elem.frame, sender.locationInView(self.view)) {
                elem.transform = CGAffineTransformScale(elem.transform, sender.scale, sender.scale)
                sender.scale = 1
            }
        }
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        
        if let elem = currentSelectedElement where !elementsOnScreen.contains(elem) {
            //To string - allow for optionals
            placeElement(Float(sender.locationInView(self.view).x), y: Float(sender.locationInView(self.view).y), elem: elem)
        }
    }
    
    
    func handleRotate(sender: UIRotationGestureRecognizer) {
        for elem in elementsOnScreen {
            if CGRectContainsPoint(elem.frame, sender.locationInView(self.view)) {
                elem.transform = CGAffineTransformRotate(elem.transform, sender.rotation)
                sender.rotation = 0
            }
        }
    }
    
    func handlePan(sender: UIPanGestureRecognizer) {
        for elem in elementsOnScreen {
            if CGRectContainsPoint(elem.frame, sender.locationInView(self.view)) {
                let translation: CGPoint = sender.translationInView(self.view)
                elem.center = CGPointMake(elem.center.x + translation.x,
                                          elem.center.y + translation.y)
                sender.setTranslation(CGPointMake(0, 0), inView: self.view)
            }
        }
    }
    
    func handleLongPress(sender: UILongPressGestureRecognizer) {
        for elem in elementsOnScreen {
            if CGRectContainsPoint(elem.frame, sender.locationInView(self.view)) {
                let alertView = UIAlertController(title: "Attributes", message: "Test", preferredStyle: .ActionSheet)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) in
                    //
                })
                alertView.addAction(cancelAction)
                
                let someAction = UIAlertAction(title: "Assign Letter", style: .Default, handler: { (action) in
                    let popup = UIAlertController(title: "Choose a keypress", message: "Enter a letter", preferredStyle: .Alert)
                    
                    popup.addTextFieldWithConfigurationHandler({ (field) in
                        //
                        field.returnKeyType = .Done
                        
                    })
                    let textDone = UIAlertAction(title: "Done", style: .Default, handler: { (action) in
                        self.mappedLetter[elem] = popup.textFields![0].text!
                    })
                    popup.addAction(textDone)
                    
                    
                    self.presentViewController(popup, animated: true, completion: nil)
                })
                alertView.addAction(someAction)
                
                self.presentViewController(alertView, animated: true, completion: nil)
            }
        }
    }
    
    /* Function to check for touches - if the currentSelectedElement has a non-nil
     * value then place it at the location of the tap.
     */
    
    // Asserts that an element has been selected
    func placeElement(x: Float, y: Float, elem: UIView) {
        
        //Fix issue for no element being chose at the point of button press
        //Extend CGFloat?
        
        elem.frame = CGRect(x: CGFloat(x), y: CGFloat(y), width: elem.frame.width, height: elem.frame.height)
        elem.center.x = CGFloat(x)
        elem.center.y = CGFloat(y)
        selectedItemOldX = Float(elem.frame.origin.x)
        selectedItemOldY = Float(elem.frame.origin.y)
        
        elementsOnScreen.append(elem)
        self.view.addSubview(elem)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch (segue.identifier) {
            
        case ELEMENT_SELECTION?:
            let dest = segue.destinationViewController as! UIElementSelectionViewController 
            dest.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
            dest.builder = self
        default:
            return
        }
    }
    
    @IBAction func showControllerScreen (sender: AnyObject) {
        let alertController = UIAlertController(title: "Configuration Name", message: "Please enter a name for the configuration", preferredStyle: .Alert)
        
        alertController.addTextFieldWithConfigurationHandler({
            textField in
                textField.placeholder = "name"
                textField.addTarget(self, action: #selector(UIBuilderViewController.alertTextFieldDidChange(_:)), forControlEvents: .EditingChanged)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil);
        let saveAction = UIAlertAction(title: "Save", style: .Default, handler: {
            action in
                let textField = alertController.textFields?.first
                let configName = textField?.text
                let accounts = SSKeychain.accountsForService("Anvil") as NSArray
                var username = String()
            
                if accounts.count > 0 {
                    let credentials = accounts[0] as! NSDictionary
                    username = credentials.objectForKey(kSSKeychainAccountKey) as! String
                }
                
                let success = SaveConfig.saveConfiguration(self.view, buttons: self.elementsOnScreen, configUser: username, configName: configName)
            
                if success {
                    self.dismissViewControllerAnimated(true, completion: {})
                } else {
                    alertController.setValue(NSAttributedString(string: "Name taken, please try again", attributes: [NSForegroundColorAttributeName: UIColor.redColor()]), forKey: "attributedMessage")
                    textField?.text = ""
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
        })
        
        saveAction.enabled = false;
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        alertController.preferredAction = saveAction
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func alertTextFieldDidChange(textField : UITextField) {
        let alertController = self.presentedViewController as! UIAlertController
        let textField = alertController.textFields?.first
        let saveAction = alertController.actions.last
        saveAction?.enabled = textField?.text?.characters.count > 0
    }
    
    @IBAction func showElementSelection (sender: AnyObject) {
        performSegueWithIdentifier(ELEMENT_SELECTION, sender: sender)
    }
}
