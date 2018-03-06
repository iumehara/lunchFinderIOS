import UIKit

class CategoryDetailViewController: UIViewController {
    private let router: Router
    private let repo: CategoryRepo
    private let mapService: MapService
    private let id: Int
    private let map: UIView
    private let restaurantTable: UITableView
    private let restaurantTableViewProtocols: RestaurantTableViewProtocols
    
    init(router: Router, repo: CategoryRepo, mapService: MapService, id: Int) {
        self.router = router
        self.repo = repo
        self.mapService = mapService
        self.id = id
        self.map = mapService.createMap()
        self.restaurantTable = UITableView()
        self.restaurantTableViewProtocols = RestaurantTableViewProtocols(router: router)
        
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
            .onSuccess { category in
                self.title = category.name
                self.restaurantTableViewProtocols.setRestaurants(restaurants: category.restaurants)
                self.mapService.setMarkers(restaurants: category.restaurants)
            }
            .onComplete { _ in self.restaurantTable.reloadData() }
    }

    private func setupNavigationBar() {
        title = "LunchFinder"
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(
                title: "Categories",
                style: .plain,
                target: self,
                action: #selector(categoriesTapped)
        )
    }

    private func setupSubviews() {
        view.addSubview(map)
        view.addSubview(restaurantTable)
        
        restaurantTable.dataSource = restaurantTableViewProtocols
        restaurantTable.delegate = restaurantTableViewProtocols
        restaurantTable.register(
            UITableViewCell.self,
            forCellReuseIdentifier: RestaurantTableViewProtocols.cellIdentifier
        )
    }
    
    private func activateConstraints() {
        let margins = self.view.safeAreaLayoutGuide
        
        map.translatesAutoresizingMaskIntoConstraints = false
        map.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        map.heightAnchor.constraint(equalToConstant: CGFloat(300)).isActive = true
        map.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        map.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        
        restaurantTable.translatesAutoresizingMaskIntoConstraints = false
        restaurantTable.topAnchor.constraint(equalTo: map.bottomAnchor).isActive = true
        restaurantTable.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        restaurantTable.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        restaurantTable.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
    }

    @objc private func categoriesTapped() {
        router.showCategoryListScreen()
    }
}
