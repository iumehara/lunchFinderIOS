import UIKit

class CategoryDetailViewController: UIViewController {
    private let repo: CategoryRepo
    private let id: Int
    private let restaurantTable: UITableView
    private let restaurantTableViewProtocols: RestaurantTableViewProtocols
    
    init(router: Router, repo: CategoryRepo, id: Int) {
        self.repo = repo
        self.id = id
        self.restaurantTable = UITableView()
        self.restaurantTableViewProtocols = RestaurantTableViewProtocols(router: router)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        activateConstraints()

        repo.get(id: self.id)
            .onSuccess { category in
                self.title = category.name
                self.restaurantTableViewProtocols.setRestaurants(restaurants: category.restaurants)
            }
            .onComplete { _ in self.restaurantTable.reloadData() }
    }
    
    func setupSubviews() {
        view.addSubview(restaurantTable)
        
        restaurantTable.dataSource = restaurantTableViewProtocols
        restaurantTable.delegate = restaurantTableViewProtocols
        restaurantTable.register(
            UITableViewCell.self,
            forCellReuseIdentifier: RestaurantTableViewProtocols.cellIdentifier
        )
    }
    
    func activateConstraints() {
        let margins = self.view.safeAreaLayoutGuide
        
        restaurantTable.translatesAutoresizingMaskIntoConstraints = false
        restaurantTable.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        restaurantTable.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        restaurantTable.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        restaurantTable.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
    }
}
