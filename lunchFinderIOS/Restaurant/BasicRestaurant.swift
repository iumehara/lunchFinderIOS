

struct BasicRestaurant: Codable {
    var id = 0
    var name = ""
    var nameJp: String?
    var website: String?
    var geolocation: Geolocation?
    var categoryIds: [Int] = []

    init(
            id: Int,
            name: String,
            nameJp: String? = nil,
            website: String? = nil,
            geolocation: Geolocation? = nil,
            categoryIds: [Int] = []
    ) {
        self.id = id
        self.name = name
        self.nameJp = nameJp
        self.website = website
        self.geolocation = geolocation
        self.categoryIds = categoryIds
    }
    
    init(restaurant: Restaurant) {
        self.id = restaurant.id
        self.name = restaurant.name
        self.nameJp = restaurant.nameJp
        self.website = restaurant.website
        self.geolocation = restaurant.geolocation
        self.categoryIds = restaurant.categories.map { $0.id }
    }
}

extension BasicRestaurant: Equatable {
    static func ==(lhs: BasicRestaurant, rhs: BasicRestaurant) -> Bool {
        return lhs.id == rhs.id &&
                lhs.name == rhs.name &&
                lhs.nameJp == rhs.nameJp &&
                lhs.website == rhs.website &&
                lhs.geolocation == rhs.geolocation &&
                lhs.categoryIds == rhs.categoryIds
    }
}
