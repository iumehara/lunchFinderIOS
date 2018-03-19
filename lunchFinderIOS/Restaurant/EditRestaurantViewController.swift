import UIKit

class EditRestaurantViewController: UIViewController {
    // MARK: - Properties
    private let router: Router
    private let repo: RestaurantRepo
    private let mapService: MapService

    private let id: Int
    
    private let form: RestaurantForm
    private let deleteButton: UIButton

    // MARK: - Constructors
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
        self.id = id
        self.form = RestaurantForm(categoryRepo: categoryRepo, mapService: mapService)
        self.deleteButton = UIButton()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        setupNavigationBar()
        setupSubviews()
        activateConstraints()
        fetchData()
    }

    override func viewDidLayoutSubviews() {
        self.form.updateScrollViewContentView()
    }
    
    // MARK: - Setup Methods
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
                action: #selector(dismissModal)
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
        deleteButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
    
    // MARK: - Request Methods
    private func fetchData() {
        repo.get(id: id)
            .onSuccess { restaurant in self.form.setDefaultValues(restaurant: restaurant) }
    }

    private func deleteRestaurant() {
        repo.delete(id: id)
            .onSuccess { _ in
                self.router.showRestaurantListScreen()
                self.dismissModal()
            }
    }

    // MARK: - Action Methods
    @objc private func saveTapped() {
        guard let newRestaurant = form.newRestaurant() else { return }
        repo.update(id: id, newRestaurant: newRestaurant)
            .onSuccess { _ in self.dismissModal() }
    }
    
    @objc private func deleteTapped() {
        let alertController = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: UIAlertControllerStyle.actionSheet)
        alertController.addAction(UIAlertAction(title: "Delete Restaurant",
                                                style: UIAlertActionStyle.destructive,
                                                handler: { _ in self.deleteRestaurant() }))
        alertController.addAction(UIAlertAction(title: "Cancel",
                                                style: UIAlertActionStyle.cancel,
                                                handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

    @objc private func dismissModal() {
        NotificationCenter.default.post(name: NSNotification.Name("modalWasDismissed"), object: nil)
        router.dismissModal()
    }
}
