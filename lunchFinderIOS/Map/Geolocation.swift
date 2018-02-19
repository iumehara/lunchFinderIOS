struct Geolocation {
    var lat = 0.0
    var long = 0.0
    
    init(lat: Double, long: Double) {
        self.lat = lat
        self.long = long
    }
    
    init(dictionary: [String: AnyObject]) {
        if let latDouble = dictionary["lat"] as? Double {
            self.lat = latDouble
        }
        if let longDouble = dictionary["long"] as? Double {
            self.long = longDouble
        }
    }
}

extension Geolocation: Equatable {
    static func ==(lhs: Geolocation, rhs: Geolocation) -> Bool {
        return lhs.lat == rhs.lat &&
            lhs.long == rhs.long
    }
}
