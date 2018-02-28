import Foundation

struct Restaurant: Codable {
    var id = 0
    var name = ""
    var nameJp: String?
    var website: String?
    var categories: [BasicCategory] = []
    var geolocation: Geolocation? = nil
    
    init(
        id: Int,
        name: String,
        nameJp: String? = nil,
        website: String? = nil,
        categories: [BasicCategory] = [],
        geolocation: Geolocation? = nil
    ) {
        self.id = id
        self.name = name
        self.nameJp = nameJp
        self.website = website
        self.categories = categories
        self.geolocation = geolocation
    }
}

extension Restaurant: Equatable {
    static func ==(lhs: Restaurant, rhs: Restaurant) -> Bool {
        return lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.nameJp == rhs.nameJp &&
            lhs.website == rhs.website &&
            lhs.categories == rhs.categories &&
            lhs.geolocation == rhs.geolocation
    }
}
