import Foundation

protocol MapService {
    func createMap() -> Map
    func createMap(isSelectable: Bool) -> Map
    func setMarker(restaurant: Restaurant) -> Void
    func setMarkers(restaurants: [Restaurant]) -> Void
}
