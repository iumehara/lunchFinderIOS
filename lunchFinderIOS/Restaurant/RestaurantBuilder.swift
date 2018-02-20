import Foundation

struct RestaurantBuilder {
    var id = 0
    var name = ""
    var nameJp: String?
    var website: String?
    var categories: [Category] = []
    var geolocation: Geolocation? = Geolocation(lat: 0, long: 0)

    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    mutating func withNameJp(nameJp: String) -> RestaurantBuilder {
        self.nameJp = nameJp
        return self
    }

    mutating func withWebsite(website: String) -> RestaurantBuilder {
        self.website = website
        return self
    }

    mutating func withCategories(categories: [Category]) -> RestaurantBuilder {
        self.categories = categories
        return self
    }

    mutating func withGeolocation(geolocation: Geolocation) -> RestaurantBuilder {
        self.geolocation = geolocation
        return self
    }

    func build() -> Restaurant {
        return Restaurant(
            id: self.id,
            name: self.name,
            nameJp: self.nameJp,
            website: self.website,
            categories: self.categories,
            geolocation: self.geolocation
        )
    }
}
