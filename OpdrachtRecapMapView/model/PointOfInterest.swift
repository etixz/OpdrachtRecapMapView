//
//  PointOfInterest.swift
//  OpdrachtRecapMapView
//
//  Created by mobapp03 on 15/01/2020.
//  Copyright © 2020 mobapp03. All rights reserved.
//

import Foundation
import MapKit

class PointOfInterest:NSObject, MKAnnotation{
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var category:String?
    
    internal init(coordinate: CLLocationCoordinate2D, title: String?) {
        self.coordinate = coordinate
        self.title = title
    }
    
    
}
