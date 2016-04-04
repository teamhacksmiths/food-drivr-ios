//
//  DonationMapOverviewVC.swift
//  hackathon-for-hunger
//
//  Created by David Fierstein on 4/3/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit
import MapKit


class DonationMapOverviewVC: UIViewController, MKMapViewDelegate {
    
    var donorInfoArray: [DonorInfo]?
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DonationMapOverviewVC.readAndDisplayAnnotations), name: refreshNotificationKey, object: nil)
//        navigationController?.title = "Pending Donations"
        donorInfoArray = [DonorInfo]()
        let dictionary: [String:AnyObject] = [
            "name": "Einstein's Bagels",
            "mapString": "101 Cooper St. Santa Cruz, CA",
            "longitude": -122.0,
            "latitude": 36.5
        ]
        let sampleDonor = DonorInfo(data: dictionary)
        donorInfoArray?.append(sampleDonor)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        readAndDisplayAnnotations()
    }
    
    func readAndDisplayAnnotations() {

//        if let _studentInfoArray = OnTheMapData.sharedInstance.studentInfoArray {
        
            // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        var annotations = [DonationPin]()
        guard let donorInfoArray = donorInfoArray else {
            print("donorInfo nil?")
            return
        }
        for donorInfo in donorInfoArray {
            //TODO: - replace force unwrapping

//            let name = donorInfo.name!
//            let lat = CLLocationDegrees(donorInfo.lat!)
//            let lon = CLLocationDegrees(donorInfo.lon!)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            //let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            //let coordinate = CLLocationCoordinate2D(latitude: 40.0, longitude: -120.0)
            
            // create the annotation and set its coordiate, title, and subtitle properties
            let annotation = DonationPin()//MKPointAnnotation()
            annotation.donorInfo = donorInfo
            //annotation.coordinate = coordinate
            //annotation.title =  name
//            if let linkString = studentInfo.link {
//                let mediaURL = "\(linkString)"
//                annotation.subtitle = mediaURL
//            }
            // place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        // When the array is complete, add the annotations to the map.
        mapView.addAnnotations(annotations)
    }
    
//    // Use this "select" function to tap the pin
//    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
//        // Unless the annotation is deselected, it is not selectable when returning from the collection view
//        mapView.deselectAnnotation(view.annotation, animated: false)
//        
//        self.performSegueWithIdentifier("DonationDetail", sender: view.annotation)
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "DonationDetail") {
            
            if let pin = sender as? DonationPin {
                let donationVC = segue.destinationViewController as! DonationMapViewController
                
                donationVC.donorInfo = pin.donorInfo
            }
        }
    }
    
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {

        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == annotationView.rightCalloutAccessoryView {
            performSegueWithIdentifier("DonationDetail", sender: annotationView.annotation)
            //            let app = UIApplication.sharedApplication()
            //            app.openURL(NSURL(string: (annotationView.annotation!.subtitle)!!)!)
            
        }
    }
}

