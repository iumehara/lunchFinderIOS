import UIKit

class CategoryDetailViewController: UIViewController {
    private let repo: CategoryRepo
    private let id: Int
    private let tableView: UITableView
    private let restaurantTableViewProtocols: RestaurantTableViewProtocols
    
    init(router: Router, repo: CategoryRepo, id: Int) {
        self.repo = repo
        self.id = id
        self.tableView = UITableView()
        self.restaurantTableViewProtocols = RestaurantTableViewProtocols(router: router)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        repo.get(id: self.id)
            .onSuccess { category in
                self.title = category.name
                self.restaurantTableViewProtocols.setRestaurants(restaurants: category.restaurants)
            }
            .onComplete { _ in self.tableView.reloadData() }
        
        addSubviews()
        configureSubviews()
    }
    
    func addSubviews() {
        view.addSubview(tableView)
    }
    
    func configureSubviews() {
        tableView.dataSource = restaurantTableViewProtocols
        tableView.delegate = restaurantTableViewProtocols
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: RestaurantTableViewProtocols.cellIdentifier
        )
        
        let margins = self.view.safeAreaLayoutGuide
        tableView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
    }
}
