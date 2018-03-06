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
        map.setMarker(restaurant: restaurant)
    }
    
    func setMarkers(restaurants: [BasicRestaurant]) {
        for restaurant in restaurants {
            map.setMarker(restaurant: restaurant)
        }
    }

    func getMarkerPosition() -> Geolocation? {
        let position = map.marker?.position
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
