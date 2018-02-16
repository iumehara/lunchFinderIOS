import UIKit

class CategoryDetailViewController: UIViewController {
    private let router: Router
    private let repo: CategoryRepo
    private let tableViewCellIdentifier: String = String(describing: UITableViewCell.self)
    private let id: Int
    private let tableView: UITableView
    private var restaurants: [Restaurant] = []
    
    init(router: Router, repo: CategoryRepo, id: Int) {
        self.router = router
        self.repo = repo
        self.id = id
        self.tableView = UITableView()
        
        super.init(nibName: nil, bundle: nil)
        self.title = "test"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        repo.get(id: self.id)
            .onSuccess { category in
                self.title = category.name
                self.restaurants = category.restaurants
            }
            .onComplete { _ in self.tableView.reloadData() }
        
        addSubviews()
        configureSubviews()
    }
    
    func addSubviews() {
        view.addSubview(tableView)
    }
    
    func configureSubviews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableViewCellIdentifier)
        
        let margins = self.view.safeAreaLayoutGuide
        
        tableView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
    }
}

extension CategoryDetailViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier, for: indexPath)
        cell.textLabel?.text = restaurants[indexPath.row].name
        return cell
    }
}

extension CategoryDetailViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRestaurant = restaurants[indexPath.row]
        router.showRestaurantDetailScreen(id: selectedRestaurant.id)
    }
}
