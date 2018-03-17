import UIKit
import BrightFutures

class RestaurantDetailViewController: UIViewController {
    // MARK: - Properties
    private let router: Router
    private let repo: RestaurantRepo
    private let mapService: MapService
    private let categoryTableViewProtocols: EditableCategoryTableViewProtocols
    
    private let id: Int
    private var categories: [BasicCategory] = []
    
    private let restaurantCard: RestaurantCard
    private let map: UIView
    private let categoryTable: UITableView
    private let webView: UIWebView = UIWebView()
    
    // MARK: - Constructors
    init(router: Router, repo: RestaurantRepo, mapService: MapService, id: Int) {
        self.router = router
        self.repo = repo
        self.restaurantCard = RestaurantCard()
        self.mapService = mapService
        self.id = id
        self.map = mapService.createMap()
        self.categoryTable = UITableView()
        self.categoryTableViewProtocols = EditableCategoryTableViewProtocols(router: router)

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
        title = "Restaurant"
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
        
        self.webView.delegate = self

        categoryTable.dataSource = categoryTableViewProtocols
        categoryTable.delegate = categoryTableViewProtocols
        categoryTable.register(
            UITableViewCell.self,
            forCellReuseIdentifier: CategoryTableViewProtocols.cellIdentifier
        )
        
        self.categoryTableViewProtocols.setEditingCallback { categoryId -> Future<Void, NSError> in
            self.repo.removeCategory(id: self.id, categoryId: categoryId)
                .onSuccess { _ in
                    let remainingCategories = self.categories.filter { $0.id != categoryId }
                    self.categoryTableViewProtocols.setCategories(categories: remainingCategories)
                }
                .onComplete { _ in self.categoryTable.reloadData() }
        }
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
            .onSuccess { restaurant in
                self.title = restaurant.name
                self.restaurantCard.set(restaurant: restaurant)
                self.mapService.setMarker(restaurant: BasicRestaurant(restaurant: restaurant))
                self.categories = restaurant.categories
                self.categoryTableViewProtocols.setCategories(categories: self.categories)
            }
            .onComplete { _ in self.categoryTable.reloadData() }
    }

    @objc private func editTapped() {
        router.showEditRestaurantModal(id: id)
    }

    @objc private func reloadView() {
        viewDidLoad()
    }
}

// MARK: - Extension: UIWebViewDelegate
extension RestaurantDetailViewController: UIWebViewDelegate {}
