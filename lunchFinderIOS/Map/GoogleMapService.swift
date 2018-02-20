import Foundation
import GoogleMaps

class GoogleMapService: MapService {    
    var map: Map!

    init() {}
    
    func createMap() -> Map {
        map = Map(frame: CGRect.zero)
        return map
    }
    
    func setMarker(restaurant: Restaurant) {
        map.setMarker(restaurant: restaurant)
    }
    
    func setMarkers(restaurants: [Restaurant]) {
        for restaurant in restaurants {
            map.setMarker(restaurant: restaurant)
        }
    }
}
