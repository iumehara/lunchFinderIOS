import UIKit
import BrightFutures

class CategoryDetailViewController: UIViewController {
    // MARK: - Properties
    private let router: Router
    private let repo: CategoryRepo
    private let mapService: MapService
    private let restaurantTableViewProtocols: EditableRestaurantTableViewProtocols

    private let id: Int
    private var restaurants: [BasicRestaurant] = []
    
    private let map: UIView
    private let restaurantTable: UITableView

    // MARK: - Constructors
    init(router: Router, repo: CategoryRepo, mapService: MapService, id: Int) {
        self.router = router
        self.repo = repo
        self.mapService = mapService
        self.id = id
        self.map = mapService.createMap()
        self.restaurantTable = UITableView()
        self.restaurantTableViewProtocols = EditableRestaurantTableViewProtocols(router: router)
        
        super.init(nibName: nil, bundle: nil)
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
        setupNotifications()
        fetchData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let returningToPreviousViewController = self.isMovingFromParentViewController
        
        if (returningToPreviousViewController) {
            guard let previousViewController = self.router.navigationController.viewControllers.last else { return }
            previousViewController.viewDidLoad()
        }
    }

    // MARK: - Private Methods
    private func setupNavigationBar() {
        title = "Category"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .edit,
            target: self,
            action: #selector(editTapped)
        )
    }

    private func setupSubviews() {
        view.addSubview(map)
        view.addSubview(restaurantTable)
        
        restaurantTable.dataSource = restaurantTableViewProtocols
        restaurantTable.delegate = restaurantTableViewProtocols
        restaurantTable.register(
            UITableViewCell.self,
            forCellReuseIdentifier: EditableRestaurantTableViewProtocols.cellIdentifier
        )
        self.restaurantTableViewProtocols.setEditingCallback { (restaurantId) -> Future<Void, NSError> in
            self.repo.removeRestaurant(id: self.id, restaurantId: restaurantId)
                .onSuccess { _ in
                    guard let restaurantToRemove = self.restaurants.first(where: { $0.id == restaurantId }) else { return }
                    let remainingRestaurants = self.restaurants.filter { $0.id != restaurantId}
                    self.restaurantTableViewProtocols.setRestaurants(restaurants: remainingRestaurants)
                    self.mapService.removeMarker(restaurant: restaurantToRemove)
                }
                .onComplete { _ in self.restaurantTable.reloadData() }
        }
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
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.reloadView),
            name: NSNotification.Name("modalWasDismissed"),
            object: nil
        )
    }
    
    private func fetchData() {
        repo.get(id: self.id)
            .onSuccess { category in
                self.title = category.name
                self.restaurants = category.restaurants
                self.restaurantTableViewProtocols.setRestaurants(restaurants: self.restaurants)
                self.mapService.setMarkers(restaurants: self.restaurants)
            }
            .onComplete { _ in self.restaurantTable.reloadData() }
    }

    @objc private func categoriesTapped() {
        router.showCategoryListScreen()
    }
    
    
    @objc private func editTapped() {
        router.showEditCategoryModal(id: id)
    }
    
    @objc private func reloadView() {
        viewDidLoad()
    }
}
