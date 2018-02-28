import Foundation

struct NewCategory: Codable {
    var name = ""
    
    init(name: String) {
        self.name = name
    }
}

extension NewCategory: Equatable {
    static func ==(lhs: NewCategory, rhs: NewCategory) -> Bool {
        return lhs.name == rhs.name
    }
}
