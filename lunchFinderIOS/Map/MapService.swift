import Foundation

protocol MapService {
    func createMap() -> Map
    func setMarker(restaurant: Restaurant) -> Void
}
