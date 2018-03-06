import UIKit

class RestaurantListViewController: UIViewController {
    private let router: Router
    private let repo: RestaurantRepo
    private let table: UITableView
    private let tableViewProtocols: RestaurantTableViewProtocols
    private var refreshControl: UIRefreshControl?

    init(router: Router, repo: RestaurantRepo) {
        self.router = router
        self.repo = repo
        self.table = UITableView()
        self.tableViewProtocols = RestaurantTableViewProtocols(router: router)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupSubviews()
        activateConstraints()

        repo.getAll()
            .onSuccess { restaurants in
                self.tableViewProtocols.setRestaurants(restaurants: restaurants)
            }
                .onFailure { _ in print("failure")}
            .onComplete { _ in self.table.reloadData() }
    }

    private func setupNavigationBar() {
        title = "Restaurants"
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(
                barButtonSystemItem: UIBarButtonSystemItem.add,
                target: self,
                action: #selector(addRestaurantTapped)
        )

        navigationItem.leftBarButtonItem = UIBarButtonItem.init(
                title: "Categories",
                style: UIBarButtonItemStyle.plain,
                target: self,
                action: #selector(categoriesTapped)
        )
    }

    private func setupSubviews() {
        view.addSubview(table)

        table.dataSource = tableViewProtocols
        table.delegate = tableViewProtocols
        table.register(UITableViewCell.self, forCellReuseIdentifier: RestaurantTableViewProtocols.cellIdentifier)

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

    @objc func addRestaurantTapped() {
        router.showNewRestaurantScreen()
    }

    @objc func categoriesTapped() {
        router.showCategoryListScreen()
    }

    @objc func reloadData() {
        repo.getAll()
                .onSuccess { restaurants in
                    self.tableViewProtocols.setRestaurants(restaurants: restaurants)
                }
                .onFailure { error in print("failed \(error)") }
                .onComplete { _ in
                    self.table.reloadData()
                    self.refreshControl!.endRefreshing()
                }
    }
}
