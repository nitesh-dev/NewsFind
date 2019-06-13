

import Foundation
import MapKit

class WeatherAnnotationModel: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    
    let title: String?
    let locationName: String?
    
    init(city: String, description: String, coordinate: CLLocationCoordinate2D) {
        
        self.title = city
        self.locationName = description
        self.coordinate = coordinate
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}
