import Foundation

struct BasicCategory: Codable {
    var id = 0
    var name = ""
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

extension BasicCategory: Equatable {
    static func ==(lhs: BasicCategory, rhs: BasicCategory) -> Bool {
        return lhs.id == rhs.id &&
            lhs.name == rhs.name
    }
}

