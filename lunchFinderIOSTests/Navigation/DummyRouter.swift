@testable import lunchFinderIOS

struct DummyRouter: Router {
    func showCategoryDetailScreen(id: Int) {}
    func showCategoryListScreen() {}
    func showNewCategoryScreen() {}
    func showRestaurantDetailScreen(id: Int) {}
    func showNewRestaurantScreen() {}
    func showEditRestaurantScreen(id: Int) {}
}
