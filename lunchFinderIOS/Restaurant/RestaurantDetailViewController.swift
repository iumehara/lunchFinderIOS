import UIKit

class RestaurantDetailViewController: UIViewController {
    private let repo: RestaurantRepo
    private let id: Int
    private var restaurant: Restaurant?
    private let card: UIView
    private let tableView: UITableView
    private let categoryTableViewProtocols: CategoryTableViewProtocols
    
    init(router: Router, repo: RestaurantRepo, id: Int) {
        self.repo = repo
        self.id = id
        self.card = UIView()
        self.tableView = UITableView()
        self.categoryTableViewProtocols = CategoryTableViewProtocols(router: router)
        
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
                self.categoryTableViewProtocols.setCategories(categories: restaurant.categories)
            }
            .onComplete { _ in self.tableView.reloadData() }
        
        view.addSubview(card)
        view.addSubview(tableView)
        
        tableView.dataSource = categoryTableViewProtocols
        tableView.delegate = categoryTableViewProtocols
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: CategoryTableViewProtocols.cellIdentifier
        )
        
        let margins = self.view.safeAreaLayoutGuide

        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = UIColor.red
        card.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        card.heightAnchor.constraint(equalToConstant: CGFloat(200)).isActive = true
        card.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        card.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: card.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
    }
}
