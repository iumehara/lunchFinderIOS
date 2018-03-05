import Foundation
import UIKit
@testable import lunchFinderIOS

class SpyMapService: MapService {
    var createMap_wasCalled = false
    func createMap() -> UIView {
        createMap_wasCalled = true
        return UIView()
    }

    var createMap_wasCalledWith = false
    func createMap(isSelectable: Bool) -> UIView {
        createMap_wasCalledWith = isSelectable
        return UIView()
    }

    var setMarker_wasCalledWith: Restaurant? = nil
    func setMarker(restaurant: Restaurant) {
        setMarker_wasCalledWith = restaurant
    }

    var setMarkers_wasCalledWith: [Restaurant] = []
    func setMarkers(restaurants: [Restaurant]) {
        setMarkers_wasCalledWith = restaurants
    }

    var getMarkerPosition_wasCalled = false
    func getMarkerPosition() -> Geolocation? {
        getMarkerPosition_wasCalled = true
        return nil
    }
}
