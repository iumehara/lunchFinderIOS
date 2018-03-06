@testable import lunchFinderIOS

class SpyRouter: Router {
    var showCategoryListScreen_wasCalled = false
    func showCategoryListScreen() {
        showCategoryListScreen_wasCalled = true
    }

    var showCategoryDetailScreen_wasCalledWith: Int?
    func showCategoryDetailScreen(id: Int) {
        showCategoryDetailScreen_wasCalledWith = id
    }

    var showNewCategoryScreen_wasCalled = false
    func showNewCategoryScreen() {
        showNewCategoryScreen_wasCalled = true
    }

    var showRestaurantListScreen_wasCalled = false
    func showRestaurantListScreen() {
        showRestaurantListScreen_wasCalled = true
    }



    var showRestaurantDetailScreen_wasCalledWith: Int?
    func showRestaurantDetailScreen(id: Int) {
        showRestaurantDetailScreen_wasCalledWith = id
    }
    
    var showNewRestaurantScreen_wasCalled = false
    func showNewRestaurantScreen() {
        showNewRestaurantScreen_wasCalled = true
    }
    
    var showEditRestaurantScreen_wasCalledWith: Int?
    func showEditRestaurantScreen(id: Int) {
        showEditRestaurantScreen_wasCalledWith = id
    }
}
