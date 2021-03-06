import Foundation
import GoogleMaps

class GoogleMapService: MapService {
    var mapContainer: UIView!
    var map: GoogleMap!

    init() {
        mapContainer = UIView()
    }
    
    func createMap() -> UIView {
        map = GoogleMap(frame: CGRect.zero)
        setupSubviewsAndActivateConstraints()
        return mapContainer
    }

    func createMap(isSelectable: Bool) -> UIView {
        map = GoogleMap(frame: CGRect.zero, isSelectable: isSelectable)
        setupSubviewsAndActivateConstraints()
        return mapContainer
    }

    func setMarker(restaurant: BasicRestaurant) {
        if let geolocation = restaurant.geolocation {
            map.setMarker(geolocation: geolocation, title: restaurant.nameJp, snippet: restaurant.name)
        }
    }
    
    func setMarkers(restaurants: [BasicRestaurant]) {
        for restaurant in restaurants {
            if let geolocation = restaurant.geolocation {
                map.setMarker(geolocation: geolocation, title: restaurant.nameJp, snippet: restaurant.name)
            }
        }
    }

    func setDraggableMarker(geolocation: Geolocation) {
        let tapLocation = CLLocationCoordinate2D(latitude: geolocation.lat, longitude: geolocation.long)
        map.mapView(map.mapView, didTapAt: tapLocation)
    }
    
    func removeMarker(restaurant: BasicRestaurant) {
        if let geolocation = restaurant.geolocation {
            map.removeMarker(geolocation: geolocation)
        }
    }
    
    func removeMarkers() {
        map.removeMarkers()
    }
    
    func getMarkerPosition() -> Geolocation? {
        let position = map.addedMarker?.position
        var geolocation: Geolocation?
        if let lat = position?.latitude, let long = position?.longitude {
            geolocation = Geolocation(lat: lat, long: long)
        }
        return geolocation
    }

    private func setupSubviewsAndActivateConstraints() {
        mapContainer.addSubview(map)

        map.translatesAutoresizingMaskIntoConstraints = false
        map.topAnchor.constraint(equalTo: mapContainer.topAnchor).isActive = true
        map.bottomAnchor.constraint(equalTo: mapContainer.bottomAnchor).isActive = true
        map.leadingAnchor.constraint(equalTo: mapContainer.leadingAnchor).isActive = true
        map.trailingAnchor.constraint(equalTo: mapContainer.trailingAnchor).isActive = true
    }
}
