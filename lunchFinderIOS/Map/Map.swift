import UIKit
import GoogleMaps

class Map: UIView {
    var mapView: GMSMapView
    var map: UIView = UIView()
    
    override init(frame: CGRect) {
        let camera = GMSCameraPosition.camera(withLatitude: 35.660480, longitude: 139.729247, zoom: 16.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.map = mapView
        
        super.init(frame: frame)
        
        self.addSubview(map)
        
        let margins = self.safeAreaLayoutGuide
        map.translatesAutoresizingMaskIntoConstraints = false
        map.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        map.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        map.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        map.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
    }
    
    func setMarker(restaurant: Restaurant) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(
            latitude: restaurant.geolocation.lat,
            longitude: restaurant.geolocation.long
        )
        marker.title = restaurant.name
        marker.snippet = restaurant.name
        marker.map = self.mapView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
}
