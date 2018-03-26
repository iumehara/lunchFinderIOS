struct SelectOption {
    let id: Int
    let name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

extension SelectOption: Equatable {
    static func ==(lhs: SelectOption, rhs: SelectOption) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
    
    static func !=(lhs: SelectOption, rhs: SelectOption) -> Bool {
        return !(lhs == rhs)
    }
}
