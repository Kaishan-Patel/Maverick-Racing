//
//  RestaurantViewController.swift
//  Assignment
//
//  Created by Kaishan Patel on 22/02/2018.
//  Copyright © 2018 Kaishan Patel. All rights reserved.
//

import UIKit
import MapKit
import Contacts
import CoreLocation

class RestaurantViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var address1Label: UILabel!
    @IBOutlet weak var address2Label: UILabel!
    @IBOutlet weak var address3Label: UILabel!
    @IBOutlet weak var postcodeLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var myMapView: MKMapView!
    
    // Storing all descriptions into rests
    var rests:RestStats?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myMapView.delegate = self
        idLabel.text = rests?.id
        nameLabel.text = rests?.BusinessName
        address1Label.text = rests?.AddressLine1
        address2Label.text = rests?.AddressLine2
        address3Label.text = rests?.AddressLine3
        postcodeLabel.text = rests?.PostCode
        valueLabel.text = rests?.RatingValue
        dateLabel.text = rests?.RatingDate
        latitudeLabel.text = rests?.Latitude
        longitudeLabel.text = rests?.Longitude
        distanceLabel.text = rests?.DistanceKM
        
        // selecting image to display according to ratingValue
        let selectIMG = rests?.RatingValue
        img.image = UIImage(named: "rating_\(selectIMG!)")
        
        // setting map region according to the current data cell selected
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let lat = (latitudeLabel.text! as NSString).doubleValue
        let long = (longitudeLabel.text! as NSString).doubleValue
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        myMapView.setRegion(region, animated: true)
        
        // setting custompin annotation onto MapView
        let annotation = CustomPin()
        let latitude = (latitudeLabel.text! as NSString).doubleValue
        let longitude = (longitudeLabel.text! as NSString).doubleValue
        let selectIMG1 = rests?.RatingValue
        annotation.image = UIImage(named: "location_\(selectIMG1!)")
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotation.title = nameLabel.text!
        annotation.subtitle = "ID: " + idLabel.text! + " / Distance KM: " + distanceLabel.text!
        myMapView.addAnnotation(annotation)
                    
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
        let annotationIdentifier = "AnnotationIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        // layout of annotation when clicked
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView!.canShowCallout = true
            annotationView?.calloutOffset = CGPoint(x: -5, y: 5)
            let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 30)))
            mapsButton.setBackgroundImage(UIImage(named: "Maps-icon"), for: UIControlState())
            annotationView?.rightCalloutAccessoryView = mapsButton
        } else {
            annotationView!.annotation = annotation
        }
        let customPointAnnotation = annotation as! CustomPin
        annotationView!.image = customPointAnnotation.image
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let placemark = MKPlacemark(coordinate: view.annotation!.coordinate, addressDictionary: nil)
        // The map item is the restaurant location
        let mapItem = MKMapItem(placemark: placemark)
        // when the user clicks on Apple Map icon this method is used
        let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeTransit]
        mapItem.openInMaps(launchOptions: launchOptions)
    }

}
