import UIKit
import Foundation

struct NavigationRouter: Router {
    // MARK: - Properties
    let navigationController: UINavigationController!
    let animated: Bool!
    let categoryRepo: CategoryRepo!
    let restaurantRepo: RestaurantRepo!
    
    // MARK: - Constructors
    init(navigationController: UINavigationController, animated: Bool) {
        self.navigationController = navigationController
        self.animated = animated
        let urlSessionProvider = NetworkURLSessionProvider()
        self.categoryRepo = NetworkCategoryRepo(urlSessionProvider: urlSessionProvider)
        self.restaurantRepo = NetworkRestaurantRepo(urlSessionProvider: urlSessionProvider)
    }

    // MARK: - Push Methods
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
            mapService: GoogleMapService(),
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
            mapService: GoogleMapService(),
            id: id
        )
        
        navigationController.pushViewController(restaurantDetailViewController, animated: animated)
    }
    
    // MARK: - Present Methods
    func showNewCategoryModal() {
        let newCategoryModal = UINavigationController(
            rootViewController: NewCategoryViewController(router: self, repo: categoryRepo)
        )
        navigationController.present(newCategoryModal, animated: animated, completion: nil)
    }
    
    func showEditCategoryModal(id: Int) {
        let editCategoryModal = UINavigationController(
            rootViewController: EditCategoryViewController(router: self, repo: categoryRepo, id: id)
        )
        navigationController.present(editCategoryModal, animated: animated, completion: nil)
    }
    
    func showNewRestaurantModal() {
        let newRestaurantModal = UINavigationController(
            rootViewController: NewRestaurantViewController(
                router: self,
                repo: restaurantRepo,
                categoryRepo: categoryRepo,
                mapService: GoogleMapService()
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
                mapService: GoogleMapService(),
                id: id
            )
        )

        navigationController.present(editRestaurantModal, animated: animated, completion: nil)
    }

    // MARK: - Dismiss Methods
    func dismissModal() {
        navigationController.dismiss(animated: animated, completion: nil)
    }
}
