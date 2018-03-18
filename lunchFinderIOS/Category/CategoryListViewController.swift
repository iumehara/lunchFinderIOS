import UIKit

class CategoryListViewController: UIViewController {
    // MARK: - Properties
    private let router: Router
    private let repo: CategoryRepo
    private let tableViewProtocols: CategoryTableViewProtocols
    private var refreshControl: UIRefreshControl?
    
    private let table: UITableView

    // MARK: - Constructors
    init(router: Router, repo: CategoryRepo) {
        self.router = router
        self.repo = repo
        self.table = UITableView()
        self.tableViewProtocols = CategoryTableViewProtocols(router: router)
        
        super.init(nibName: nil, bundle:  nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupSubviews()
        activateConstraints()
        fetchData()
    }
    
    // MARK: - Private Methods
    private func setupNavigationBar() {
        title = "Categories"
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(
                barButtonSystemItem: UIBarButtonSystemItem.add,
                target: self,
                action: #selector(addCategoryTapped)
        )

        navigationItem.leftBarButtonItem = UIBarButtonItem.init(
            title: "Restaurants",
            style: UIBarButtonItemStyle.plain,
            target: self,
            action: #selector(restaurantsTapped)
        )
    }
    
    private func setupSubviews() {
        view.addSubview(table)
        
        table.dataSource = tableViewProtocols
        table.delegate = tableViewProtocols
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: CategoryTableViewProtocols.cellIdentifier)
        
        self.refreshControl = UIRefreshControl()
        if let control = refreshControl {
            table.refreshControl = control
            control.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        }
    }

    private func activateConstraints() {
        let margins = self.view.safeAreaLayoutGuide
        
        table.translatesAutoresizingMaskIntoConstraints = false
        table.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        table.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        table.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        table.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
    }
    
    private func fetchData() {
        repo.getAll()
            .onSuccess { categories in
                self.tableViewProtocols.setCategories(categories: categories)
            }
            .onFailure { error in print("failed \(error)") }
            .onComplete { _ in self.table.reloadData() }
    }

    @objc func addCategoryTapped() {
        router.showNewCategoryModal()
    }

    @objc func restaurantsTapped() {
        router.showRestaurantListScreen()
    }

    @objc func reloadData() {
        repo.getAll()
            .onSuccess { categories in
                self.tableViewProtocols.setCategories(categories: categories)
            }
            .onFailure { error in print("failed \(error)") }
            .onComplete { _ in
                self.table.reloadData()
                self.refreshControl!.endRefreshing()
            }
    }
}
