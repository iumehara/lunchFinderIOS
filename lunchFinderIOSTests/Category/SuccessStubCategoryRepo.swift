@testable import lunchFinderIOS

class SuccessStubCategoryRepo: CategoryRepo {
    func getAll() -> [Category] {
        return [
            Category(id: 1, name: "Test Pizza"),
            Category(id: 2, name: "Test Sushi")
        ]
    }
}
