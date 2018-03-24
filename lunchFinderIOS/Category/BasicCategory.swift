import Foundation

struct BasicCategory: Codable {
    var id = 0
    var name = ""
    var restaurantCount = 0
    
    init(id: Int, name: String) {
        self.init(id: id, name: name, restaurantCount: 0)
    }
    
    init(id: Int, name: String, restaurantCount: Int) {
        self.id = id
        self.name = name
        self.restaurantCount = restaurantCount
    }
}

extension BasicCategory: Equatable {
    static func ==(lhs: BasicCategory, rhs: BasicCategory) -> Bool {
        return lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.restaurantCount == rhs.restaurantCount
    }
}

