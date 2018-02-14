struct Category {
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
