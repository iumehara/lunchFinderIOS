class NetworkCategoryRepo: CategoryRepo {
    func getAll() -> [Category] {
        return [
            Category(id: 1, name: "Pizza"),
            Category(id: 2, name: "Sushi")
        ]
    }
}
