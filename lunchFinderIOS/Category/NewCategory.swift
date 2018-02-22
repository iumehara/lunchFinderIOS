import Foundation

struct NewCategory {
    var name = ""
    
    init(name: String) {
        self.name = name
    }
    
    func dictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["name"] = self.name
        return dictionary
    }
}

extension NewCategory: Equatable {
    static func ==(lhs: NewCategory, rhs: NewCategory) -> Bool {
        return lhs.name == rhs.name
    }
}
