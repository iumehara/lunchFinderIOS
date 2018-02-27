import UIKit

class EditRestaurantViewController: UIViewController {
    private let id: Int
    private let router: Router
    private let repo: RestaurantRepo
    private let form: RestaurantForm
    
    init(
        router: Router,
        repo: RestaurantRepo,
        categoryRepo: CategoryRepo,
        id: Int
    ) {
        self.router = router
        self.repo = repo
        self.form = RestaurantForm(categoryRepo: categoryRepo)
        self.id = id
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    override func viewDidLoad() {
        title = "Edit Restaurant"
        
        fetchData()
        setupSubviews()
        activateConstraints()
    }

    func fetchData() {
        repo.get(id: id)
            .onSuccess { restaurant in
                self.form.setDefaultValues(restaurant: restaurant)
            }
    }
    
    func setupSubviews() {
        view.backgroundColor = UIColor.white
        let saveButton = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
        navigationItem.rightBarButtonItem = saveButton
        
        view.addSubview(form)
    }
    
    func activateConstraints() {
        let margins = self.view.safeAreaLayoutGuide
        
        form.translatesAutoresizingMaskIntoConstraints = false
        form.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        form.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        form.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
    }
    
    @objc
    func saveTapped() {
        guard let newRestaurant = form.newRestaurant() else { return }
        repo.update(id: id, newRestaurant: newRestaurant)
            .onSuccess { _ in self.router.showRestaurantDetailScreen(id: self.id)}
    }
}
