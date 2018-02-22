import Foundation

struct Category {
    var id = 0
    var name = ""
    var restaurants: [Restaurant] = []
    
    init(id: Int, name: String, restaurants: [Restaurant] = []) {
        self.id = id
        self.name = name
        self.restaurants = restaurants
    }

    init?(dictionary: [String: AnyObject]) {
        guard let idInt = dictionary["id"] as! Int? else { return nil }
        self.id = idInt

        guard let nameString = dictionary["name"] as? String else { return nil }
        self.name = nameString
        
        var restaurants: [Restaurant] = []
        if let dictionaryArray = dictionary["restaurants"] as? [[String: AnyObject]] {
            for dictionary in dictionaryArray {
                if let restaurant = Restaurant(dictionary: dictionary) {
                    restaurants.append(restaurant)
                }
            }
        }
        self.restaurants = restaurants
    }
}

extension Category: Equatable {
    static func ==(lhs: Category, rhs: Category) -> Bool {
        return lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.restaurants == rhs.restaurants
    }
}
