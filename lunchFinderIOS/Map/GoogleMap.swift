import UIKit
import GoogleMaps

class GoogleMap: UIView {
    var mapView: GMSMapView
    var map: UIView = UIView()
    var isSelectable = false
    var addedMarker: GMSMarker?
    var markers: [GMSMarker]
    
    convenience init(frame: CGRect, isSelectable: Bool) {
        self.init(frame: frame)
        self.isSelectable = isSelectable
    }
    
    override init(frame: CGRect) {
        let camera = GMSCameraPosition.camera(withLatitude: 35.660480, longitude: 139.729247, zoom: 16.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.map = mapView
        self.markers = []
        
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
    
    func setMarker(geolocation: Geolocation, title: String?, snippet: String?) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(
            latitude: geolocation.lat,
            longitude: geolocation.long
        )
        marker.title = title
        marker.snippet = snippet
        marker.map = self.mapView
        markers.append(marker)
    }
    
    func removeMarker(geolocation: Geolocation) {
        let positionToRemove = CLLocationCoordinate2D(
            latitude: geolocation.lat,
            longitude: geolocation.long
        )
        let markerToRemove = markers.first(where: {$0.position.equals(positionToRemove)})
        markerToRemove?.map = nil
    }
    
    func removeMarkers() {
        mapView.clear()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
}

extension GoogleMap: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        guard (self.isSelectable) else { return }
        
        if (self.addedMarker != nil) {
            self.addedMarker!.map = nil
            markers = markers.filter { $0 != addedMarker }
        }
        
        addedMarker = GMSMarker(position: coordinate)
        guard let unwrappedMarker = addedMarker else { return }
        unwrappedMarker.isDraggable = true
        unwrappedMarker.map = mapView
        markers.append(unwrappedMarker)
    }
}

extension CLLocationCoordinate2D {
    func equals(_ comparator: CLLocationCoordinate2D) -> Bool {
        return self.latitude == comparator.latitude && self.longitude == comparator.longitude
    }
}

