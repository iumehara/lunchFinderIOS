import Foundation
import UIKit
@testable import lunchFinderIOS

class SpyMapService: MapService {
    var createMap_wasCalled = false
    func createMap() -> Map {
        createMap_wasCalled = true
        return Map(frame: CGRect.zero)
    }

    var setMarker_wasCalledWith: Restaurant? = nil
    func setMarker(restaurant: Restaurant) {
        setMarker_wasCalledWith = restaurant
    }

    var setMarkers_wasCalledWith: [Restaurant] = []
    func setMarkers(restaurants: [Restaurant]) {
        setMarkers_wasCalledWith = restaurants
    }
}
