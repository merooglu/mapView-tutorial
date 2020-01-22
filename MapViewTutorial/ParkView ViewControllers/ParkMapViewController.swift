//
//  ParkMapViewController.swift
//  MapViewTutorial
//
//  Created by Mehmet Eroğlu on 10.01.2020.
//  Copyright © 2020 Mehmet Eroğlu. All rights reserved.
//
/*
 https://www.raywenderlich.com/425-mapkit-tutorial-overlay-views
 */

import UIKit
import MapKit

class ParkMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var selectedOptions: [MapOptionsType] = []
    var park = Park(filename: "MagicMountain")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let latDelta = park.overlayTopLeftCoordinate.latitude - park.overlayBottomRightCoordinate.latitude
        
        // Think of aspan as atv size, measure from one corner to another
        let span = MKCoordinateSpan(latitudeDelta: fabs(latDelta), longitudeDelta: 0.0)
        let region = MKCoordinateRegion(center: park.midCoordianate, span: span)
        mapView.region = region
    }
    
    // MARK: - Functions
    func loadSelectedOptions() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        
        for option in selectedOptions {
            switch option {
            case .mapOverlay:
                addOverlay()
            case .mapPins:
                addAttractionPins()
            case .mapRoute:
                addRoute()
            case .mapBoundary:
                addBoundary()
            case .mapChracterLocation:
                addCharacterLocation()
            }
        }
    }
    
    func addOverlay() {
          let overlay = ParkMapOverlay(park: park)
          mapView.addOverlay(overlay)
      }
    
    
    func addAttractionPins() {
        guard let attractions = Park.plist("MagicMountainAttractions") as? [[String: String]] else { return }
        
        for attraction in attractions {
            let coordinate = Park.parseCoord(dict: attraction, fieldName: "location")
            let title = attraction["name"] ?? ""
            let subtitle = attraction["subtitle"] ?? ""
            let typeRawValue = Int(attraction["type"] ?? "0") ?? 0
            let type = AttractionType(rawValue: typeRawValue) ?? .misc
            let annotation = AttractionAnnotation(coordinate: coordinate, title: title, subtitle: subtitle, type: type)
            mapView.addAnnotation(annotation)
        }
    }
    
    func addRoute() {
        guard let points = Park.plist("EntranceToGoliathRoute") as? [String] else { return }
        
        let cgPoints = points.map { NSCoder.cgPoint(for: $0) }
        let coords = cgPoints.map { CLLocationCoordinate2DMake(CLLocationDegrees($0.x), CLLocationDegrees($0.y)) }
        let myPolyLine = MKPolyline(coordinates: coords, count: coords.count)
        
        mapView.addOverlay(myPolyLine)
    }
   
    func addBoundary() {
        mapView.addOverlay(MKPolygon(coordinates: park.boundary, count: park.boundary.count))
    }
    
    func addCharacterLocation() {
        mapView.addOverlay(Character(filename: "BatmanLocations", color: .blue))
        mapView.addOverlay(Character(filename: "TazLocations", color: .orange))
        mapView.addOverlay(Character(filename: "TweetyBirdLocations", color: .yellow))
    }
    
    // MARK: - Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as? MapOptionsViewController)?.selectedOptions = selectedOptions
    }
    
    // MARK: - UnWindSegue Action
    @IBAction func closeOptions(_ exitSegue: UIStoryboardSegue) {
        guard let vc = exitSegue.source as? MapOptionsViewController else { return }
        selectedOptions = vc.selectedOptions
        loadSelectedOptions()
    }
    
    @IBAction func mapTypeChanged(_ sender: UISegmentedControl) {
        mapView.mapType = MKMapType.init(rawValue: UInt(sender.selectedSegmentIndex)) ?? .standard
    }
}

// MARK: - MKMapViewDelegate
extension ParkMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is ParkMapOverlay {
            return ParkMapOverlayView(overlay: overlay, overlayImage: #imageLiteral(resourceName: "overlay_park"))
        } else if overlay is MKPolyline {
            let lineView = MKPolylineRenderer(overlay: overlay)
            lineView.strokeColor = UIColor.green
            return lineView
        } else if overlay is MKPolygon {
          let polygonView = MKPolygonRenderer(overlay: overlay)
          polygonView.strokeColor = UIColor.magenta
          return polygonView
        } else if let character = overlay as? Character {
            let circleView = MKCircleRenderer(overlay: character)
            circleView.strokeColor = character.color
            return circleView
        }
        
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationVeiw = AttractionAnnotationView(annotation: annotation, reuseIdentifier: "Attraction")
        annotationVeiw.canShowCallout = true
        return annotationVeiw
    }
}
