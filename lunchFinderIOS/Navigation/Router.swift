import UIKit

protocol Router {
    var navigationController: UINavigationController! { get }

    func showCategoryListScreen()
    func showCategoryDetailScreen(id: Int)
    func showNewCategoryModal()
    func showEditCategoryModal(id: Int)

    func showRestaurantListScreen()
    func showRestaurantDetailScreen(id: Int)
    func showNewRestaurantModal()
    func showEditRestaurantModal(id: Int)
    
    func dismissModal()
}
