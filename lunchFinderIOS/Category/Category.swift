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

    init(dictionary: [String: AnyObject]) {
        if let nameString = dictionary["name"] as? String {
            self.name = nameString
        }
        if let idInt = dictionary["id"] as? Int {
            self.id = idInt
        }
        
        var restaurants: [Restaurant] = []
        
        if let dictionaryArray = dictionary["restaurants"] as? [NSDictionary] {
            for dictionary: NSDictionary in dictionaryArray {
                let restaurant = Restaurant(dictionary: dictionary as! [String: AnyObject])
                restaurants.append(restaurant)
            }
            
            self.restaurants = restaurants
        }
    }
}

extension Category: Equatable {
    static func ==(lhs: Category, rhs: Category) -> Bool {
        return lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.restaurants == rhs.restaurants
    }
}
