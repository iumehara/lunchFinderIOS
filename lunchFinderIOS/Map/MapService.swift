import UIKit

protocol MapService {
    func createMap() -> UIView
    func createMap(isSelectable: Bool) -> UIView
    func setMarker(restaurant: Restaurant) -> Void
    func setMarkers(restaurants: [Restaurant]) -> Void
    func getMarkerPosition() -> Geolocation?
}
