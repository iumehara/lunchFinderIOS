import UIKit

class RestaurantDetailViewController: UIViewController {
    private let router: Router
    private let repo: RestaurantRepo
    private let mapService: MapService
    private let id: Int
    private let map: UIView
    private let categoryTable: UITableView
    private let categoryTableViewProtocols: CategoryTableViewProtocols

    init(router: Router, repo: RestaurantRepo, mapService: MapService, id: Int) {
        self.router = router
        self.repo = repo
        self.mapService = mapService
        self.id = id
        self.map = mapService.createMap()
        self.categoryTable = UITableView()
        self.categoryTableViewProtocols = CategoryTableViewProtocols(router: router)

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
        
        repo.get(id: self.id)
            .onSuccess { restaurant in
                self.title = restaurant.name
                self.categoryTableViewProtocols.setCategories(categories: restaurant.categories)
                self.mapService.setMarker(restaurant: BasicRestaurant(restaurant: restaurant))
            }
            .onComplete { _ in self.categoryTable.reloadData() }
    }

    private func setupNavigationBar() {
        title = "LunchFinder"
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(
                barButtonSystemItem: .edit,
                target: self,
                action: #selector(editTapped)
        )

        navigationItem.leftBarButtonItem = UIBarButtonItem.init(
                title: "Restaurants",
                style: .plain,
                target: self,
                action: #selector(restaurantsTapped)
        )
    }

    private func setupSubviews() {
        view.addSubview(map)
        view.addSubview(categoryTable)
        
        categoryTable.dataSource = categoryTableViewProtocols
        categoryTable.delegate = categoryTableViewProtocols
        categoryTable.register(
            UITableViewCell.self,
            forCellReuseIdentifier: CategoryTableViewProtocols.cellIdentifier
        )
    }
    
    private func activateConstraints() {
        let margins = self.view.safeAreaLayoutGuide
        
        map.translatesAutoresizingMaskIntoConstraints = false
        map.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        map.heightAnchor.constraint(equalToConstant: CGFloat(300)).isActive = true
        map.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        map.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        
        categoryTable.translatesAutoresizingMaskIntoConstraints = false
        categoryTable.topAnchor.constraint(equalTo: map.bottomAnchor).isActive = true
        categoryTable.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        categoryTable.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        categoryTable.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
    }

    @objc private func editTapped() {
        router.showEditRestaurantScreen(id: id)
    }

    @objc private func restaurantsTapped() {
        router.showRestaurantListScreen()
    }
}
