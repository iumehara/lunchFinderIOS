import UIKit
import GoogleMaps

class GoogleMap: UIView {
    var mapView: GMSMapView
    var map: UIView = UIView()
    var isSelectable = false
    var marker: GMSMarker?

    convenience init(frame: CGRect, isSelectable: Bool) {
        self.init(frame: frame)
        self.isSelectable = isSelectable
    }
    
    override init(frame: CGRect) {
        let camera = GMSCameraPosition.camera(withLatitude: 35.660480, longitude: 139.729247, zoom: 16.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.map = mapView
        
        
        super.init(frame: frame)
        
        mapView.delegate = self

        self.addSubview(map)
        
        let margins = self.safeAreaLayoutGuide
        map.translatesAutoresizingMaskIntoConstraints = false
        map.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        map.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        map.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        map.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
    }
    
    func setMarker(restaurant: BasicRestaurant) {
        if let geolocation = restaurant.geolocation {
            marker = GMSMarker()
            if (self.marker != nil) {
                marker!.position = CLLocationCoordinate2D(
                    latitude: geolocation.lat,
                    longitude: geolocation.long
                )
                marker!.title = restaurant.nameJp ?? restaurant.name
                marker!.snippet = restaurant.name
                marker!.map = self.mapView
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
}

extension GoogleMap: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        guard (self.isSelectable) else { return }
        
        if (self.marker != nil) {
            self.marker!.map = nil
        }
        
        marker = GMSMarker(position: coordinate)
        
        guard let unwrappedMarker = marker else { return }
    
        unwrappedMarker.isDraggable = true
        unwrappedMarker.map = mapView
    }
}

