//
//  MapOptionsViewController.swift
//  MapViewTutorial
//
//  Created by Mehmet Eroğlu on 10.01.2020.
//  Copyright © 2020 Mehmet Eroğlu. All rights reserved.
//
/*
https://www.raywenderlich.com/425-mapkit-tutorial-overlay-views
*/
import UIKit

enum MapOptionsType: Int {
    case mapBoundary = 0
    case mapOverlay
    case mapPins
    case mapChracterLocation
    case mapRoute
    
    func displayName() -> String {
        switch (self) {
        case .mapBoundary:
            return "Park Boundary"
        case .mapOverlay:
            return "Map Overlay"
        case .mapPins:
            return "Attraction Pins"
        case .mapChracterLocation:
            return "Character Location"
        case .mapRoute:
            return "Route"
        }
    }
}

class MapOptionsViewController: UIViewController {
// print selectedOptions array
    var selectedOptions = [MapOptionsType]()
    
}

// MARK: - UITableViewDataSource
extension MapOptionsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell")!
        if let mapOptionsType = MapOptionsType(rawValue: indexPath.row) {
            cell.textLabel!.text = mapOptionsType.displayName()
            cell.accessoryType = selectedOptions.contains(mapOptionsType) ? .checkmark : .none
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MapOptionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        guard let mapOptionsType = MapOptionsType(rawValue: indexPath.row) else { return }
        
        if cell.accessoryType == .checkmark {
            // Remove option
            selectedOptions = selectedOptions.filter { $0 != mapOptionsType }
            cell.accessoryType = .none
        } else {
            // Add option
            selectedOptions += [mapOptionsType]
            cell.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
