import UIKit
import Foundation

struct NavigationRouter: Router {
    let navigationController: UINavigationController!
    let animated: Bool!
    let categoryRepo: CategoryRepo!
    let restaurantRepo: RestaurantRepo!
    let mapService: GoogleMapService!
    
    init(navigationController: UINavigationController, animated: Bool) {
        self.navigationController = navigationController
        self.animated = animated
        let urlSessionProvider = NetworkURLSessionProvider()
        self.categoryRepo = NetworkCategoryRepo(urlSessionProvider: urlSessionProvider)
        self.restaurantRepo = NetworkRestaurantRepo(urlSessionProvider: urlSessionProvider)
        self.mapService = GoogleMapService()
    }

    func showCategoryListScreen() {
        let categoryListViewController = CategoryListViewController(
            router: self,
            repo: categoryRepo
        )

        navigationController.setViewControllers([categoryListViewController], animated: animated)
    }
    
    func showCategoryDetailScreen(id: Int) {
        let categoryDetailViewController = CategoryDetailViewController(
            router: self,
            repo: categoryRepo,
            mapService: mapService,
            id: id
        )
        
        navigationController.pushViewController(categoryDetailViewController, animated: animated)
    }
    
    func showNewCategoryScreen() {
        let newCategoryViewController = NewCategoryViewController(
            router: self,
            repo: categoryRepo
        )
        
        navigationController.pushViewController(newCategoryViewController, animated: animated)
    }

    func showRestaurantListScreen() {
        let restaurantListViewController = RestaurantListViewController(
                router: self,
                repo: restaurantRepo
        )

        navigationController.pushViewController(restaurantListViewController, animated: animated)
    }

    func showRestaurantDetailScreen(id: Int) {
        let restaurantDetailViewController = RestaurantDetailViewController(
            router: self,
            repo: restaurantRepo,
            mapService: mapService,
            id: id
        )
        
        navigationController.pushViewController(restaurantDetailViewController, animated: animated)
    }
    
    func showNewRestaurantScreen() {
        let newRestaurantViewController = NewRestaurantViewController(
            router: self,
            repo: restaurantRepo,
            categoryRepo: categoryRepo,
            mapService: mapService
        )
        
        navigationController.pushViewController(newRestaurantViewController, animated: animated)
    }
    
    func showEditRestaurantScreen(id: Int) {
        let editRestaurantViewController = EditRestaurantViewController(
            router: self,
            repo: restaurantRepo,
            categoryRepo: categoryRepo,
            id: id
        )
        
        navigationController.pushViewController(editRestaurantViewController, animated: animated)
    }
}
