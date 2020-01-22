//
//  Character.swift
//  MapViewTutorial
//
//  Created by Mehmet Eroğlu on 11.01.2020.
//  Copyright © 2020 Mehmet Eroğlu. All rights reserved.
//

import UIKit
import MapKit

class Character: MKCircle {
    var name: String?
    var color: UIColor?
    
    convenience init(filename: String, color: UIColor) {
        guard let points = Park.plist(filename) as? [String] else { self.init(); return }
        
        let cgPoints = points.map { NSCoder.cgPoint(for: $0) }
        let coords = cgPoints.map { CLLocationCoordinate2DMake(CLLocationDegrees($0.x), CLLocationDegrees($0.y)) }
        
        let randomCenter = coords[Int(arc4random()%4)]
        let randomRadius = CLLocationDistance(max(5, Int(arc4random()%40)))
        
        self.init(center: randomCenter, radius: randomRadius)
        self.name = filename
        self.color = color
    }
}
