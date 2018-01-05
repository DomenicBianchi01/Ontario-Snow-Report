//
//  TrailMapViewController.swift
//  Ontario Ski Report
//
//  Created by Domenic Bianchi on 2016-10-14.
//  Copyright © 2016 Domenic Bianchi. All rights reserved.
//

import UIKit
import SwiftSoup
import JGActionSheet
import Firebase

final class TrailMapViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet var trailMap: GMSMapView!
    
    // MARK: - Structs
    ///FilterMode maps to TrailDifficulty
    private struct FilterMode: OptionSet {
        let rawValue: Int

        static let easy = FilterMode(rawValue: 1 << 0)
        static let intermediate = FilterMode(rawValue: 1 << 1)
        static let advanced = FilterMode(rawValue: 1 << 2)
        static let expert = FilterMode(rawValue: 1 << 3)
        static let terrainPark = FilterMode(rawValue: 1 << 4)
        static let allRuns = FilterMode(rawValue: 1 << 5)
        static let allDifficulties = FilterMode(rawValue: 1 << 6)
        static let openRuns = FilterMode(rawValue: 1 << 7)
    }

    // MARK: - Properties
    private var trails = [TrailSegment]()
    private var lodges = [LodgeInfo]()
    private var marker = GMSMarker()
    private var terrainParks = [GMSPolygon]()
    private var filter: FilterMode = [.openRuns, .allDifficulties]
    private var selectedStatusRow = 1
    private var selectedDifficultyRow = 0
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        let mountainType: String
        let viewModel: CoordinatesViewModelable
        
        switch selectedMountain {
        case .blueMountain:
            mountainType = "Blue Mountain"
            viewModel = BlueMountainTrailViewModel()
            trails = viewModel.trailCoordinates
        case .saintLouis:
            mountainType = "Mt. St. Louis"
            viewModel = MountStLouisTrailViewModel()
            trails = viewModel.trailCoordinates
        case .horseshoe:
            mountainType = "Horseshoe Valley"
            viewModel = HorseshoeTrailViewModel()
            trails = viewModel.trailCoordinates
        case .glenEden:
            mountainType = "Glen Eden"
            viewModel = GlenEdenTrailViewModel()
            trails = viewModel.trailCoordinates
        }
        
        let defaultCoordinates = viewModel.defaultViewCoordinates
        lodges = viewModel.lodgeCoordinates

        trailMap.camera = GMSCameraPosition.camera(withLatitude: defaultCoordinates.lat, longitude: defaultCoordinates.long, zoom: 10, bearing: 250, viewingAngle: 0)
        trailMap.mapType = .satellite
        trailMap.setMinZoom(14.9, maxZoom: 20)
        trailMap.delegate = self
        
        if trails.isEmpty {
            let alert = UIAlertController(title: "No trails open", message: "It looks like no trails are currently open.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)

            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        }
        
        refreshTrailMap()
        addLodgeMarkers(with: lodges)

        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [AnalyticsParameterItemID: "id-\(mountainType)-map" as NSObject,
                                                                     AnalyticsParameterItemName: mountainType + " trail map viewed"])
    }
    
    // MARK: - Helper Functions
    private func refreshTrailMap() {
        var terrainParkName: String? = nil
        let path = GMSMutablePath()
        
        var filteredTrails = trails
        
        if filter.contains(.openRuns) {
            filteredTrails = trails.filter({ $0.status == .open })
        }
        if !filter.contains(.allDifficulties) {
            var rawValue = -1
            if filter.contains(.easy) {
                rawValue = 1
            } else if filter.contains(.intermediate) {
                rawValue = 2
            } else if filter.contains(.advanced) {
                rawValue = 3
            } else if filter.contains(.expert) {
                rawValue = 4
            } else if filter.contains(.terrainPark) {
                rawValue = 5
            }
            
            filteredTrails = filteredTrails.filter({ $0.difficulty.rawValue == rawValue })
        }
        
        trailMap.clear()
        addLodgeMarkers(with: lodges)
        
        for segment in filteredTrails {
            if segment.difficulty != .terrainPark || (segment.name != terrainParkName && terrainParkName != nil) {
                if terrainParkName != nil {
                    drawTerrainPark(from: path, named: terrainParkName ?? "")
                    path.removeAllCoordinates()
                    terrainParkName = nil
                    continue
                }
                
                path.add(CLLocationCoordinate2DMake(segment.latStart, segment.longStart))
                path.add(CLLocationCoordinate2DMake(segment.latEnd, segment.longEnd))
                
                let polyline = GMSPolyline(path: path)
                polyline.strokeWidth = 2.5
                
                switch segment.difficulty {
                case .easy:
                    polyline.strokeColor = .green
                    polyline.zIndex = 3
                case .intermediate:
                    polyline.strokeColor = .blue
                    polyline.zIndex = 2
                case .advanced, .expert:
                    polyline.strokeColor = .black
                    polyline.zIndex = 1
                default:
                    //Lift
                    polyline.strokeColor = .red
                    polyline.zIndex = 4
                }
                
                polyline.map = trailMap
                path.removeAllCoordinates()
            } else {
                path.add(CLLocationCoordinate2DMake(segment.latStart, segment.longStart))
                path.add(CLLocationCoordinate2DMake(segment.latEnd, segment.longEnd))
                terrainParkName = segment.name
            }
        }
        
        if terrainParkName != nil {
            drawTerrainPark(from: path, named: terrainParkName ?? "No Name")
            path.removeAllCoordinates()
        }
    }
    
    private func drawTerrainPark(from path: GMSMutablePath, named: String) {
        let polygon = GMSPolygon(path: path)
        polygon.fillColor = UIColor(red: 255/255, green: 165/255, blue: 0, alpha: 0.5)
        polygon.title = named
        polygon.map = trailMap
        terrainParks.append(polygon)
    }
    
    private func addLodgeMarkers(with lodges: [LodgeInfo]) {
        for lodge in lodges {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake(lodge.lat, lodge.long)
            marker.title = lodge.title
            marker.icon = GMSMarker.markerImage(with: .purple)
            marker.map = trailMap
        }
    }
    
    //MARK: - IBActions
    @IBAction func filterBarButtonPressed(_ sender: Any) {
        let sectionStatus = JGActionSheetSection(title: "Trail Status", message: nil, buttonTitles: ["All Trails", "Only Open Trails"], buttonStyle: .default)
        let sectionDifficulty = JGActionSheetSection(title: "Trail Difficulty", message: nil, buttonTitles: ["All", "Beginner", "Intermediate", "Advanced", "Expert", "Terrain Park"], buttonStyle: .default)
        let sectionCancel = JGActionSheetSection(title: nil, message: nil, buttonTitles: ["Cancel"], buttonStyle: .cancel)
        
        sectionStatus?.setButtonStyle(.green, forButtonAt: UInt(selectedStatusRow))
        sectionDifficulty?.setButtonStyle(.green, forButtonAt: UInt(selectedDifficultyRow))
        let actionSheet = JGActionSheet(sections: [sectionStatus, sectionDifficulty, sectionCancel])
        
        actionSheet?.buttonPressedBlock = {
            (_ sheet: JGActionSheet?, _ indexPath: IndexPath?) -> Void in
            actionSheet?.dismiss(animated: true)
            
            if indexPath?.section == 0 {
                self.selectedStatusRow = indexPath?.row ?? 0
                if indexPath?.row == 0 {
                    self.filter.remove(.openRuns)
                    self.filter.insert(.allRuns)
                } else {
                    self.filter.remove(.allRuns)
                    self.filter.insert(.openRuns)
                }
            } else {
                self.selectedDifficultyRow = indexPath?.row ?? 0
                self.filter.remove(.allDifficulties)
                self.filter.remove(.easy)
                self.filter.remove(.intermediate)
                self.filter.remove(.advanced)
                self.filter.remove(.expert)
                self.filter.remove(.terrainPark)
                if indexPath?.row == 0 {
                    self.filter.insert(.allDifficulties)
                } else if indexPath?.row == 1 {
                    self.filter.insert(.easy)
                } else if indexPath?.row == 2 {
                    self.filter.insert(.intermediate)
                } else if indexPath?.row == 3 {
                    self.filter.insert(.advanced)
                } else if indexPath?.row == 4 {
                    self.filter.insert(.expert)
                } else if indexPath?.row == 5 {
                    self.filter.insert(.terrainPark)
                }
            }
            self.refreshTrailMap()
        }
        
        actionSheet?.show(in: navigationController?.view, animated: true)
    }
}

extension TrailMapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        mapView.selectedMarker = nil
        marker.map = nil
        marker = GMSMarker()
        for terrainPark in terrainParks {
            if GMSGeometryContainsLocation(coordinate, terrainPark.path!, true) {
                marker.position = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)
                marker.title = terrainPark.title
                marker.snippet = "Terrain Park"
                marker.map = mapView
                mapView.selectedMarker = marker
                break
            }
        }
    }
}

extension TrailMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            trailMap.isMyLocationEnabled = true
            trailMap.settings.myLocationButton = true
        }
    }
}
