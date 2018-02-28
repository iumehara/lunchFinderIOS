import Foundation

struct Category: Codable {
    var id = 0
    var name = ""
    var restaurants: [Restaurant] = []
    
    init(id: Int, name: String, restaurants: [Restaurant] = []) {
        self.id = id
        self.name = name
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
