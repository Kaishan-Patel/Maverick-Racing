//
//  RestViewController.swift
//  Assignment
//
//  Created by Kaishan Patel on 22/02/2018.
//  Copyright © 2018 Kaishan Patel. All rights reserved.
//

import UIKit
import MapKit

class RestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var barButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var seg: UISegmentedControl!
    
    let locationManager = CLLocationManager() // CLLocationManager

    var allRests = [RestStats]() // to setup table
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        searchBar.delegate = self
        // authorising locationManager in plist
        // this means when the user loads the application for the first time, they will be asked to share their own location
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.distanceFilter = 50
            locationManager.startUpdatingLocation()
        }
        //get users location
        let lat = locationManager.location?.coordinate.latitude
        let long = locationManager.location?.coordinate.longitude
        //URL to get the json data from
        let url = URL(string: "http://radikaldesign.co.uk/sandbox/hygiene.php?op=s_loc&lat=\(lat!)&long=\(long!)")
        urlCall(fullURL: url!)
    }
    
    func urlCall(fullURL: URL) {
        //configure the URLSession
        URLSession.shared.dataTask(with: fullURL) { (data, response, error) in
            guard let data = data else { print("error with data"); return }
            do {
                self.allRests = try JSONDecoder().decode([RestStats].self, from: data);
                //interupt the main thread and update the table with the retrieved data
                DispatchQueue.main.async {
                    self.myTableView.reloadData();
                }
            } catch let err {
                print("Error: ", err)
            }
            }.resume() // start the network call
    }
    
    @IBAction func btnSearch(_ sender: Any) {
        if seg.selectedSegmentIndex == 0
        {
            // get search bar text
            let query = searchBar.text
            //URL to get the json data from
            let url = URL(string: "http://radikaldesign.co.uk/sandbox/hygiene.php?op=s_name&name=\(query!)")
            urlCall(fullURL: url!)
        }
        else if seg.selectedSegmentIndex == 1
        {
            // get search bar text
            let query = searchBar.text
            //URL to get the json data from
            let url = URL(string: "http://radikaldesign.co.uk/sandbox/hygiene.php?op=s_postcode&postcode=\(query!)")
            urlCall(fullURL: url!)
        }
    }
    
    @IBAction func btnRefresh(_ sender: Any) {
        //get users location
        let lat = locationManager.location?.coordinate.latitude
        let long = locationManager.location?.coordinate.longitude
        //URL to get the json data from
        let url = URL(string: "http://radikaldesign.co.uk/sandbox/hygiene.php?op=s_loc&lat=\(lat!)&long=\(long!)")
        urlCall(fullURL: url!)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 // height of each cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allRests.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel!.text = allRests[indexPath.row].BusinessName.capitalized
        cell.detailTextLabel!.text = allRests[indexPath.row].PostCode.capitalized
        let selectIMG = allRests[indexPath.row].RatingValue
        cell.imageView?.image = UIImage(named: "rating_\(selectIMG)")
        cell.imageView?.layer.cornerRadius = (cell.imageView?.frame.size.width)! / 100
        cell.imageView?.layer.masksToBounds = true
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell {
            let i = myTableView.indexPath(for: cell)!.row
            
            if segue.identifier == "details" { // get segue identifier from name 'details'
                let dvc = segue.destination as! RestaurantViewController // Swift file the program will go to
                dvc.rests = self.allRests[i]
            }
        }
    }
}


