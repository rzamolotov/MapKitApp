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
    
    let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444) //Honolulu
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.centerLocation(initialLocation)
        
        let oahuCenter = CLLocation(latitude: 21.4765, longitude: -157.9647)
        let region = MKCoordinateRegion(
            center: oahuCenter.coordinate,
            latitudinalMeters: 50000,
            longitudinalMeters: 60000)
        mapView.setCameraBoundary(
            MKMapView.CameraBoundary(coordinateRegion: region),
            animated: true)
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
        mapView.setCameraZoomRange(zoomRange, animated: true) // код ограничивает зум до максимума не более радиуса
        
        let artwork = Artwork(title: "King David Kalakaua", locationName: "Waikiki Gateway Park", discipline: "Sculpture", coordinate: CLLocationCoordinate2D(latitude: 21.283921, longitude: -157.831661))
        mapView.addAnnotation(artwork)
        
        mapView.delegate = self
    }

}

private extension MKMapView {
    func centerLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 500) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    } // ФУНКЦИЯ ОПРЕДЕЛЕНИЯ ЦЕНТРА ЛОКАЦИИ И ЕЕ РАДИУСА
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? { // mapView(_:viewFor:) gets called for every annotation you add to the map
        guard let annotation = annotation as? Artwork else { // check that this annotation is an Artwork object. If it isn’t, return nil to let the map view use its default annotation view.
            return nil
        }
        let identifier = "artwork"
        var view: MKMarkerAnnotationView
        
        if let dequeueView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeueView.annotation = annotation
            view = dequeueView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
}

