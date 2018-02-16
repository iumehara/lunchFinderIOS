import UIKit

class RestaurantDetailViewController: UIViewController {
    private let router: Router
    private let repo: RestaurantRepo
    private let id: Int
    private var restaurant: Restaurant?
    
    init(router: Router, repo: RestaurantRepo, id: Int) {
        self.router = router
        self.repo = repo
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        repo.get(id: self.id)
            .onSuccess { restaurant in
                self.title = restaurant.name
                self.restaurant = restaurant
            }
    }
    
    
    
}
