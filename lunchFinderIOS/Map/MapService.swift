import UIKit

protocol MapService {
    func createMap() -> UIView
    func createMap(isSelectable: Bool) -> UIView
    func setMarker(restaurant: BasicRestaurant)
    func setMarkers(restaurants: [BasicRestaurant])
    func removeMarker(restaurant: BasicRestaurant)
    func getMarkerPosition() -> Geolocation?
}
