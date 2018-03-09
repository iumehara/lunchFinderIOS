import UIKit

class RestaurantDetailViewController: UIViewController {
    private let router: Router
    private let repo: RestaurantRepo
    private let restaurantCard: RestaurantCard
    private let mapService: MapService
    private let id: Int
    private let map: UIView
    private let categoryTable: UITableView
    private let categoryTableViewProtocols: CategoryTableViewProtocols
    private let webView: UIWebView = UIWebView()
    
    init(router: Router, repo: RestaurantRepo, mapService: MapService, id: Int) {
        self.router = router
        self.repo = repo
        self.restaurantCard = RestaurantCard()
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

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.reloadView),
            name: NSNotification.Name("modalWasDismissed"),
            object: nil
        )
        
        self.webView.delegate = self
        
        setupNavigationBar()
        setupSubviews()
        activateConstraints()
        
        repo.get(id: self.id)
            .onSuccess { restaurant in
                self.title = restaurant.name
                self.restaurantCard.set(restaurant: restaurant)
                self.mapService.setMarker(restaurant: BasicRestaurant(restaurant: restaurant))
                self.categoryTableViewProtocols.setCategories(categories: restaurant.categories)
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
    }

    private func setupSubviews() {
        view.addSubview(restaurantCard)
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
        
        restaurantCard.translatesAutoresizingMaskIntoConstraints = false
        restaurantCard.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        restaurantCard.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        restaurantCard.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true

        map.translatesAutoresizingMaskIntoConstraints = false
        map.topAnchor.constraint(equalTo: restaurantCard.bottomAnchor).isActive = true
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
        router.showEditRestaurantModal(id: id)
    }

    @objc private func restaurantsTapped() {
        router.showRestaurantListScreen()
    }
    
    @objc func reloadView() {
        viewDidLoad()
    }
}

extension RestaurantDetailViewController: UIWebViewDelegate {}
