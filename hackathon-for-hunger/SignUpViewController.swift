//
//  SignUpViewController.swift
//  hackathon-for-hunger
//
//  Created by ivan lares on 4/4/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var driverImageView: UIImageView!
    @IBOutlet weak var donorImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let imageViews = [driverImageView!, donorImageView!]
        addImageViewGestureRecognizer(imageViews)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func cancelButtonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /** Adds gesture recognizers to each image view in an array of passed in image
     *  views
     *
     *  @param imageViews - an array of imageviews
     *  @return None
     */
    func addImageViewGestureRecognizer(imageViews: [UIImageView]) {
        for imageView in imageViews {
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.didTapImageView(_:)))
            gestureRecognizer.numberOfTapsRequired = 1
            imageView.userInteractionEnabled = true
            imageView.addGestureRecognizer(gestureRecognizer)
        }
    }
    
    /** Fired when the image view is tapped.
     *
     *  @param sender - The Tap Gesture Recognizer that sent the message.
     *  @return None
     */
    func didTapImageView(sender: UITapGestureRecognizer) {
        let imageView = sender.view!
        let button = SignupButtons(rawValue: imageView.tag)
        switch button! {
        case .Donor:
            performSegueWithIdentifier("ShowDonorSignup", sender: self)
        case .Driver:
            performSegueWithIdentifier("ShowDriverSignup", sender: self)
        }
    }
    
    /** Maps to the tap set in storyboard for these image view buttons.
     *
     */
    enum SignupButtons: Int {
        case Driver = 101,
             Donor
    }
    
}
