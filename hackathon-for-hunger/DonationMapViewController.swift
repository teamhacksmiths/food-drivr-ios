//
//  DonationMapViewController.swift
//  hackathon-for-hunger
//
//  Created by David Fierstein on 4/2/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit
import MapKit

class DonationMapViewController: UIViewController, UITextFieldDelegate {

    enum UIState: Int {
        case Unspecified
        case Find
        case Geocoding
        case GeocodingError
        case Submit
    }
    
    var annotation:MKAnnotation!
    var pointAnnotation:MKPointAnnotation?
    var pinAnnotationView:MKPinAnnotationView!
    
    var keyboardHeight: CGFloat?
    
    //MARK:- Outlets & Actions
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBAction func acceptDonation(sender: AnyObject) {
        findOnMap()
    }
    
    //MARK:- View lifecycle
    
    override func viewDidLoad() {
        locationTextField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        subscribeToKeyboardNotifications()
    }
    
    //MARK:- Geocoding
    
    func findOnMap() {
        
        self.configureUIForState(UIState.Geocoding)
        
        // In case there are any exisiting annotations, remove them
        if mapView.annotations.count != 0 {
            annotation = self.mapView.annotations[0]
            mapView.removeAnnotation(annotation)
        }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(self.locationTextField.text!) { (placemarks, error) -> Void in
            if (error != nil) {
                self.configureUIForState(UIState.GeocodingError)
                self.alert("Could not find that place")
                return
            }
            if let placemark = placemarks?[0] {
                let lat = placemark.location?.coordinate.latitude
                let lon = placemark.location?.coordinate.longitude
                let region = placemark.region as! CLCircularRegion
                let mkregion = MKCoordinateRegionMakeWithDistance(
                    region.center,
                    region.radius,
                    region.radius);
                
                self.pointAnnotation = MKPointAnnotation()
                self.pointAnnotation!.title = self.locationTextField.text
                self.pointAnnotation!.coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
                self.mapView.centerCoordinate = self.pointAnnotation!.coordinate
                self.mapView.setRegion(mkregion, animated: true)
                self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
                self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
                self.configureUIForState(UIState.Submit)
            }
        }
    }
    
    func configureUIForState(state: UIState) {
        
    }
    
    func alert(alertString: String) {
        let alertController = UIAlertController(title: nil, message: alertString, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Text and keyboard funcs
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Cancels textfield editing when user touches outside the textfield
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if locationTextField.isFirstResponder() {
            view.endEditing(true)
        }
        super.touchesBegan(touches, withEvent:event)
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DonationMapViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DonationMapViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if locationTextField.isFirstResponder() {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if keyboardHeight != nil && locationTextField.isFirstResponder() {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        keyboardHeight = keyboardSize.CGRectValue().height
        return keyboardHeight!
    }
    
}
