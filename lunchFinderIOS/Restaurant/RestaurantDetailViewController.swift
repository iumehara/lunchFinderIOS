import UIKit

class RestaurantDetailViewController: UIViewController {
    private let repo: RestaurantRepo
    private let mapService: MapService
    private let id: Int
    private let map: Map
    private let categoryTable: UITableView
    private let categoryTableViewProtocols: CategoryTableViewProtocols

    init(
        router: Router,
        repo: RestaurantRepo,
        mapService: MapService,
        id: Int
    ) {
        self.repo = repo
        self.id = id
        self.mapService = mapService
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

        setupSubviews()
        activateConstraints()
        
        repo.get(id: self.id)
            .onSuccess { restaurant in
                self.title = restaurant.name
                self.categoryTableViewProtocols.setCategories(categories: restaurant.categories)
                self.mapService.setMarker(restaurant: restaurant)
            }
            .onComplete { _ in self.categoryTable.reloadData() }
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
}
