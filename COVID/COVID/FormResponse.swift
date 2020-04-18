//
//  FormResponse.swift
//  COVID
//
//  Created by Rastaar Haghi on 4/17/20.
//  Copyright © 2020 Rastaar Haghi. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase

struct FormResponse: Codable {
    let product: String
    let storeName: String
    let quantity: String
    let xCoord: CLLocationDegrees
    let yCoord: CLLocationDegrees
    
    var dictionary: [String: Any] {
      return [
        "product": product,
        "storeName": storeName,
        "quantity": quantity,
        "xCoord": xCoord,
        "yCoord": yCoord
      ]
    }
}
