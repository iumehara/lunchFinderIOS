import UIKit

protocol Router {
    var navigationController: UINavigationController! { get }

    func showCategoryListScreen()
    func showCategoryDetailScreen(id: Int)
    func showNewCategoryModal()

    func showRestaurantListScreen()
    func showRestaurantDetailScreen(id: Int)
    func showNewRestaurantModal()
    func showEditRestaurantModal(id: Int)
    
    func dismissModal()
}
