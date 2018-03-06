import UIKit

class EditRestaurantViewController: UIViewController {
    private let id: Int
    private let router: Router
    private let repo: RestaurantRepo
    private let form: RestaurantForm
    private let mapService: MapService
    private let deleteButton: UIButton
    
    init(
        router: Router,
        repo: RestaurantRepo,
        categoryRepo: CategoryRepo,
        mapService: MapService,
        id: Int
    ) {
        self.router = router
        self.repo = repo
        self.mapService = mapService
        self.form = RestaurantForm(categoryRepo: categoryRepo, mapService: mapService)
        self.id = id
        self.deleteButton = UIButton()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    override func viewDidLoad() {
        fetchData()
        setupNavigationBar()
        setupSubviews()
        activateConstraints()
    }

    func fetchData() {
        repo.get(id: id)
            .onSuccess { restaurant in
                self.form.setDefaultValues(restaurant: restaurant)
            }
    }

    private func setupNavigationBar() {
        title = "Edit Restaurant"

        navigationItem.rightBarButtonItem = UIBarButtonItem.init(
                barButtonSystemItem: .save,
                target: self,
                action: #selector(saveTapped)
        )

        navigationItem.leftBarButtonItem = UIBarButtonItem.init(
                barButtonSystemItem: .cancel,
                target: self,
                action: #selector(cancelTapped)
        )
    }

    private func setupSubviews() {
        view.backgroundColor = UIColor.white

        view.addSubview(form)
        
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        deleteButton.setTitle("Delete Restaurant", for: .normal)
        deleteButton.setTitleColor(.white, for: .normal)
        deleteButton.backgroundColor = UIColor.red
        view.addSubview(deleteButton)
    }

    private func activateConstraints() {
        let margins = self.view.safeAreaLayoutGuide
        
        form.translatesAutoresizingMaskIntoConstraints = false
        form.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        form.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        form.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.topAnchor.constraint(equalTo: form.bottomAnchor).isActive = true
        deleteButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
    }
    
    @objc func saveTapped() {
        guard let newRestaurant = form.newRestaurant() else { return }
        repo.update(id: id, newRestaurant: newRestaurant)
            .onSuccess { _ in self.router.showRestaurantDetailScreen(id: self.id)}
    }
    
    @objc func deleteTapped() {
        repo.delete(id: id)
            .onSuccess { _ in self.router.showRestaurantListScreen()}
    }

    @objc func cancelTapped() {
        router.showRestaurantDetailScreen(id: id)
    }
}
