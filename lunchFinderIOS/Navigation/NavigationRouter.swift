import UIKit
import Foundation

struct NavigationRouter: Router {
    let navigationController: UINavigationController!
    let animated: Bool!
    let categoryRepo: CategoryRepo!
    let restaurantRepo: RestaurantRepo!
    let mapService: MapService!
    
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

        navigationController.pushViewController(categoryListViewController, animated: animated)
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
    
    func showNewCategoryModal() {
        let newCategoryModal = UINavigationController(
            rootViewController: NewCategoryViewController(router: self, repo: categoryRepo)
        )
        navigationController.present(newCategoryModal, animated: animated, completion: nil)
    }
    
    func showNewRestaurantModal() {
        let newRestaurantModal = UINavigationController(
            rootViewController: NewRestaurantViewController(
                router: self,
                repo: restaurantRepo,
                categoryRepo: categoryRepo,
                mapService: mapService
            )
        )
        
        navigationController.present(newRestaurantModal, animated: animated, completion: nil)
    }
    
    func showEditRestaurantModal(id: Int) {
        let editRestaurantModal = UINavigationController(
            rootViewController: EditRestaurantViewController(
                router: self,
                repo: restaurantRepo,
                categoryRepo: categoryRepo,
                mapService: mapService,
                id: id
            )
        )

        navigationController.present(editRestaurantModal, animated: animated, completion: nil)
    }

    func dismissModal() {
        navigationController.dismiss(animated: animated, completion: nil)
    }
}
