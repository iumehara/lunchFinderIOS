import UIKit

@testable import lunchFinderIOS

class SpyRouter: Router {
    let navigationController: UINavigationController!

    init() {
        self.navigationController = UINavigationController()
    }

    var showCategoryListScreen_wasCalled = false
    func showCategoryListScreen() {
        showCategoryListScreen_wasCalled = true
    }

    var showCategoryDetailScreen_wasCalledWith: Int?
    func showCategoryDetailScreen(id: Int) {
        showCategoryDetailScreen_wasCalledWith = id
    }

    var showNewCategoryModal_wasCalled = false
    func showNewCategoryModal() {
        showNewCategoryModal_wasCalled = true
    }

    var showEditCategoryModal_wasCalled = false
    func showEditCategoryModal(id: Int) {
        showEditCategoryModal_wasCalled = true
    }
    
    var showRestaurantListScreen_wasCalled = false
    func showRestaurantListScreen() {
        showRestaurantListScreen_wasCalled = true
    }

    var showRestaurantDetailScreen_wasCalledWith: Int?
    func showRestaurantDetailScreen(id: Int) {
        showRestaurantDetailScreen_wasCalledWith = id
    }

    var showNewRestaurantModal_wasCalled = false
    func showNewRestaurantModal() {
        showNewRestaurantModal_wasCalled = true
    }
    
    var showEditRestaurantModal_wasCalledWith: Int?
    func showEditRestaurantModal(id: Int) {
        showEditRestaurantModal_wasCalledWith = id
    }


    
    var dismissModal_wasCalled = false
    func dismissModal() {
        dismissModal_wasCalled = true
    }
}
