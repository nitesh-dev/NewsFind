//
//  WeatherViewController.swift
//  NewsFinder
//
//  Created by Nitesh Singh on 08/11/18.
//  Copyright © 2018 Nitesh Singh. All rights reserved.
//

import UIKit
import MapKit
import Moya

class WeatherViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 1000
    let provider = MoyaProvider<OpenWeatherAPI>()
    var flag = false
    var fullAddress: String = ""
    var loc: [CLLocation] = []
    var distance: CLLocationDistance = CLLocationDistance(MAXFLOAT)
    var centralLocationCoordinate: CLLocationCoordinate2D? = nil
    var mapRadius: Double = 500.0
    var region: String = ""
    var weatherResult: WeatherModel!
    {
        didSet {
            flag = true
        }
    }
   @objc func handleTap(gestureReconizer: UILongPressGestureRecognizer) {
    
        let touchPoint = gestureReconizer.location(in: mapView)
        let touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
    
        // Add below code to get address for touch coordinates.
    
        let location = CLLocation(latitude: touchCoordinate.latitude, longitude: touchCoordinate.longitude)
    self.fullAddress = ""
    self.reverseGeocoding(location: location, completionHandler:{ result in
        if (result == true)
        {
            let fixedDistance = self.mapRadius * 100
            if (self.loc.count > 0 )
            {
                for locatn in self.loc
                {
                    self.distance = location.distance(from: locatn)
                    print(self.distance)
                    if (self.distance < fixedDistance)
                    {
                        break;
                    }
                }
            }
            if (self.distance > fixedDistance )
            {
                self.getWeatherData(latitude: touchCoordinate.latitude, longitude: touchCoordinate.longitude, completionHandler:{ result in
                    if (result == true)
                    {
                        self.loc.append(location)
                        let str = self.weatherResult.weather![0].desc
                        let info = WeatherAnnotationModel(city: self.fullAddress, description: (str?.capitalized(with: NSLocale.current))!, coordinate: touchCoordinate)
                        self.mapView.addAnnotation(info)
                    }
                    else {
                        //Configure it later
                        print("Error occured, please try again later")
                    }
                })
            }
        }
        else {
            //Configure it later
            print("Error occured, please try again later")
        }
    })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(self.handleTap))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
        let location = CLLocation(latitude: 13.0827, longitude: 80.2707)
        self.getWeatherData(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, completionHandler:{ result in
            if (result == true)
            {
              self.centerMapOnLocation(location: location)
            }
            else {
                //Configure it later
                print("Error occured, please try again later")
            }
        })
    }
    
    func reverseGeocoding(location: CLLocation, completionHandler: @escaping (Bool) -> Void) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            if (!(error != nil))
            {
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // Street address
                if (self.mapRadius < 200 )
                {
            if let street = placeMark.thoroughfare {
                self.fullAddress.append(street)
                print(street)
            }
                }
            // City
                
            if let city = placeMark.subAdministrativeArea {
                if(self.fullAddress.isEmpty)
                {
                    self.fullAddress.append(city)
                }
                else
                {
                    self.fullAddress.append(", ")
                    self.fullAddress.append(city)
                }
            }
                if (self.mapRadius < 2000 && self.mapRadius > 200)
                {
            if let state = placeMark.administrativeArea {
                    if(self.fullAddress.isEmpty)
                    {
                        self.fullAddress.append(state)
                    }
                    else
                    {
                        self.fullAddress.append(", ")
                        self.fullAddress.append(state)
                    }
                }
                }
                
            // Country
                if (self.mapRadius > 2000)
                {
            if let country = placeMark.country {
                
                if(self.fullAddress.isEmpty)
                {
                    self.fullAddress.append(country)
                }
                else
                {
                    self.fullAddress.append(", ")
                    self.fullAddress.append(country)
                }
            }
            }
                if let reg = placeMark.isoCountryCode {
                    self.region = reg
                }
                completionHandler(true)
            }
        })
    }
    func getWeatherData(latitude: Double, longitude: Double, completionHandler: @escaping (Bool) -> Void){
        provider.request(.weather(lat: latitude, lon: longitude)) { result in
            switch result  {
            case .success(let response):
                do{
                    print(response)
                    let filteredResponse = try response.filterSuccessfulStatusCodes()
                    let decoder = JSONDecoder()
                    self.weatherResult = try filteredResponse.map(WeatherModel.self, using: decoder)
                    print("Check")
                    
                    completionHandler(true)
                } catch {
                    completionHandler(false)
                    print("Exception occured, please try again later")
                }
            case .failure:
                completionHandler(false)
                print("Error occured, please try again later")
            }
        }
    }
    func centerMapOnLocation(location: CLLocation)
    {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}
extension WeatherViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? WeatherAnnotationModel else {return nil}
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        {
            dequeuedView.annotation = annotation
            view = dequeuedView
            view.glyphText = region
        }
        else
        {
            
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            view.glyphText = region
        }
        return view
        
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        flag = true
    }
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let centralLocation = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude:  mapView.centerCoordinate.longitude)
        self.centralLocationCoordinate = mapView.centerCoordinate
        
        self.mapRadius = self.getRadius(centralLocation: centralLocation)
        print("Radius - \(self.getRadius(centralLocation: centralLocation))")
    }
    
    func getRadius(centralLocation: CLLocation) -> Double{
        let topCentralLat:Double = centralLocation.coordinate.latitude -  mapView.region.span.latitudeDelta/2
        let topCentralLocation = CLLocation(latitude: topCentralLat, longitude: centralLocation.coordinate.longitude)
        let radius = centralLocation.distance(from: topCentralLocation)
        return radius / 1000.0 // to convert radius to meters
    }
}
