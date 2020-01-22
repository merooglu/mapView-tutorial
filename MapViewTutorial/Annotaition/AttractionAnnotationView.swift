//
//  AttractionAnnotationView.swift
//  MapViewTutorial
//
//  Created by Mehmet Eroğlu on 11.01.2020.
//  Copyright © 2020 Mehmet Eroğlu. All rights reserved.
//

import UIKit
import MapKit

class AttractionAnnotationView: MKAnnotationView {
    // Required for MKAnntationView
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        guard let attractionAnnotation = self.annotation as? AttractionAnnotation else { return }
        
        image = attractionAnnotation.type.image()
    }
}
