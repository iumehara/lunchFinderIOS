import UIKit

protocol MapService {
    func createMap() -> UIView
    func createMap(isSelectable: Bool) -> UIView
    func setMarker(restaurant: BasicRestaurant)
    func setDraggableMarker(geolocation: Geolocation)
    func setMarkers(restaurants: [BasicRestaurant])
    func removeMarker(restaurant: BasicRestaurant)
    func removeMarkers()
    func getMarkerPosition() -> Geolocation?
}
