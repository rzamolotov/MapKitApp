//
//  ViewController.swift
//  MapKitApp
//
//  Created by Роман Замолотов on 20.05.2023.
//
import UIKit
import MapKit

class ViewController: UIViewController {
    @IBOutlet private var mapView: MKMapView!
    private var artworks: [Artwork] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        mapView.centerToLocation(initialLocation)
        
        let oahuCenter = CLLocation(latitude: 21.4765, longitude: -157.9647)
        let region = MKCoordinateRegion(center: oahuCenter.coordinate, latitudinalMeters: 50000, longitudinalMeters: 60000)
        
        mapView.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region), animated: true)
        
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
        mapView.setCameraZoomRange(zoomRange, animated: true)
        
        mapView.delegate = self
        
        mapView.register(ArtworkView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        loadInitialData()
        mapView.addAnnotations(artworks)
    }
    
    private func loadInitialData() {
        guard
            let fileName = Bundle.main.url(forResource: "PublicArt", withExtension: "geojson"),
            let artworkData = try? Data(contentsOf: fileName)
        else {
            return
        }
        
        do {
            let features = try MKGeoJSONDecoder()
                .decode(artworkData)
                .compactMap { $0 as? MKGeoJSONFeature }
            let validWorks = features.compactMap(Artwork.init)
            artworks.append(contentsOf: validWorks)
        } catch {
            print("Unexpected error: \(error).")
        }
    }
}

private extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(
        _ mapView: MKMapView,
        annotationView view: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl
    ) {
        guard let artwork = view.annotation as? Artwork else {
            return
        }
        
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        artwork.mapItem?.openInMaps(launchOptions: launchOptions)
    }
}
