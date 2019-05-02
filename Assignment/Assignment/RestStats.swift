//
//  RestStats.swift
//  Assignment
//
//  Created by Kaishan Patel on 22/02/2018.
//  Copyright © 2018 Kaishan Patel. All rights reserved.
//

import Foundation
import Contacts

// Codable so that we can automatically deserilize
// JSON to create object/s of this class
class RestStats: Codable {
    
    // Classifiying each description as a string in the URL
    let id: String
    let BusinessName: String
    let AddressLine1: String?
    let AddressLine2: String
    let AddressLine3: String
    let PostCode: String
    let RatingValue: String
    let RatingDate: String
    let Latitude: String
    let Longitude: String
    let DistanceKM: String?

}

