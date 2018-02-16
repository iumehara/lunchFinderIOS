struct Restaurant {
    var id = 0
    var name = ""
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    init(dictionary: [String: AnyObject]) {
        if let nameString = dictionary["name"] as? String {
            self.name = nameString
        }
        if let idInt = dictionary["id"] as? Int {
            self.id = idInt
        }
    }
}

extension Restaurant: Equatable {
    static func ==(lhs: Restaurant, rhs: Restaurant) -> Bool {
        return lhs.id == rhs.id &&
            lhs.name == rhs.name
    }
}
