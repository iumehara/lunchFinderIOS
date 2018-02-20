import UIKit
import Foundation

struct NavigationRouter: Router {
    let navigationController: UINavigationController
    let animated: Bool
    let urlSessionProvider = NetworkURLSessionProvider()
    
    init(navigationController: UINavigationController, animated: Bool) {
        self.navigationController = navigationController
        self.animated = animated
    }

    func showCategoryListScreen() {
        let categoryListViewController = CategoryListViewController(
            router: self,
            repo: NetworkCategoryRepo(urlSessionProvider: urlSessionProvider)
        )

        navigationController.setViewControllers([categoryListViewController], animated: animated)
    }
    
    func showCategoryDetailScreen(id: Int) {
        let categoryDetailViewController = CategoryDetailViewController(
            router: self,
            repo: NetworkCategoryRepo(urlSessionProvider: urlSessionProvider),
            mapService: GoogleMapService(),
            id: id
        )
        
        navigationController.pushViewController(categoryDetailViewController, animated: animated)
    }
    
    func showRestaurantDetailScreen(id: Int) {
        let restaurantDetailViewController = RestaurantDetailViewController(
            router: self,
            repo: NetworkRestaurantRepo(urlSessionProvider: urlSessionProvider),
            mapService: GoogleMapService(),
            id: id
        )
        
        navigationController.pushViewController(restaurantDetailViewController, animated: animated)
    }
}
