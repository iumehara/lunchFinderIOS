import UIKit

struct NavigationRouter: Router {
    let navigationController: UINavigationController
    let animated: Bool

    init(navigationController: UINavigationController, animated: Bool) {
        self.navigationController = navigationController
        self.animated = animated
    }

    func showCategoryListScreen() {
        let categoryListViewController = CategoryListViewController(
            router: self,
            repo: NetworkCategoryRepo()
        )

        navigationController.setViewControllers([categoryListViewController], animated: animated)
    }
    
    func showCategoryDetailScreen(id: Int) {
        let categoryViewController = CategoryViewController(
            router: self,
            repo: NetworkCategoryRepo(),
            id: id
        )
        
        navigationController.pushViewController(categoryViewController, animated: animated)
    }
}
