import UIKit

protocol MapService {
    func createMap() -> UIView
    func createMap(isSelectable: Bool) -> UIView
    func setMarker(restaurant: BasicRestaurant) -> Void
    func setMarkers(restaurants: [BasicRestaurant]) -> Void
    func getMarkerPosition() -> Geolocation?
}
