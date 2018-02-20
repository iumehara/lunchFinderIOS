import Foundation

struct Restaurant {
    var id = 0
    var name = ""
    var nameJp: String?
    var website: String?
    var categories: [Category] = []
    var geolocation: Geolocation? = nil
    
    init(
        id: Int,
        name: String,
        nameJp: String? = nil,
        website: String? = nil,
        categories: [Category] = [],
        geolocation: Geolocation? = nil
    ) {
        self.id = id
        self.name = name
        self.nameJp = nameJp
        self.website = website
        self.categories = categories
        self.geolocation = geolocation
    }

    init(dictionary: [String: AnyObject]) {
        if let nameString = dictionary["name"] as? String {
            self.name = nameString
        }

        if let idInt = dictionary["id"] as? Int {
            self.id = idInt
        }
        
        var categories: [Category] = []
        if let dictionaryArray = dictionary["categories"] as? [NSDictionary] {
            for dictionary: NSDictionary in dictionaryArray {
                let category = Category(dictionary: dictionary as! [String: AnyObject])
                categories.append(category)
            }
            
            self.categories = categories
        }
        
        if let geolocationDictionary = dictionary["geolocation"] as? [String: AnyObject] {
            self.geolocation = Geolocation(dictionary: geolocationDictionary)
        }
    }
}

extension Restaurant: Equatable {
    static func ==(lhs: Restaurant, rhs: Restaurant) -> Bool {
        return lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.categories == rhs.categories &&
            lhs.geolocation == rhs.geolocation
    }
}
