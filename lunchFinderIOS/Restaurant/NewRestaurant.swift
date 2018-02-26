import Foundation

struct NewRestaurant {
    var name = ""
    var nameJp: String?
    var website: String?
    var categoryIds: [Int] = []
    var geolocation: Geolocation? = nil
    
    init(
        name: String,
        nameJp: String? = nil,
        website: String? = nil,
        categoryIds: [Int] = [],
        geolocation: Geolocation? = nil
    ) {
        self.name = name
        self.nameJp = nameJp
        self.website = website
        self.categoryIds = categoryIds
        self.geolocation = geolocation
    }
    
    func dictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["name"] = self.name
        dictionary["nameJp"] = nameJp ?? nil
        dictionary["website"] = website ?? nil
        return dictionary
    }
}

extension NewRestaurant: Equatable {
    static func ==(lhs: NewRestaurant, rhs: NewRestaurant) -> Bool {
        return lhs.name == rhs.name &&
            lhs.nameJp == rhs.nameJp &&
            lhs.website == rhs.website &&
            lhs.categoryIds == rhs.categoryIds &&
            lhs.geolocation == rhs.geolocation
    }
}
