//
//  MapViewController.swift
//  Assignment
//
//  Created by Kaishan Patel on 22/02/2018.
//  Copyright © 2018 Kaishan Patel. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var myMapView: MKMapView!
    
    var locations = [RestStats]()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myMapView.delegate = self
    }
    
    @IBAction func zoomIn(_ sender: Any) {
        let userLocation = myMapView.userLocation
        let region = MKCoordinateRegionMakeWithDistance((userLocation.location?.coordinate)!, 2000, 2000)
        myMapView.setRegion(region, animated: true)
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        let allAnnotations = myMapView.annotations
        self.myMapView.removeAnnotations(allAnnotations)
        //get location
        let lat = locationManager.location?.coordinate.latitude
        let long = locationManager.location?.coordinate.longitude
        //URL to get the json data from
        let url = URL(string: "http://radikaldesign.co.uk/sandbox/hygiene.php?op=s_loc&lat=\(lat!)&long=\(long!)")
        urlCall(fullURL: url!)
    }
    
    func urlCall(fullURL: URL) {
        //configure the URLSession
            do {
                let data = try Data(contentsOf: fullURL)
                let locations = try JSONDecoder().decode([RestStats].self, from: data)
                for l in locations {
                    let annotation = CustomPin()
                    let lat = Double(l.Latitude)
                    let lon = Double(l.Longitude)
                    let selectIMG1 = l.RatingValue
                    annotation.image = UIImage(named: "location_\(selectIMG1)")
                    annotation.coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
                    annotation.title = l.BusinessName
                    annotation.subtitle = "ID: " + l.id + " / Distance KM: " + l.DistanceKM!
                    myMapView.addAnnotation(annotation)
                    let span: MKCoordinateSpan = MKCoordinateSpanMake(0.02, 0.02)
                    let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat!, lon!)
                    let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
                    myMapView.setRegion(region, animated: true)
                }
            } catch let error {
                print(error)
        }
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
