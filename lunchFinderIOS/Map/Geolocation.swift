struct Geolocation: Codable {
    var lat = 0.0
    var long = 0.0
    
    init(lat: Double, long: Double) {
        self.lat = lat
        self.long = long
    }
}

extension Geolocation: Equatable {
    static func ==(lhs: Geolocation, rhs: Geolocation) -> Bool {
        return lhs.lat == rhs.lat &&
            lhs.long == rhs.long
    }
}
