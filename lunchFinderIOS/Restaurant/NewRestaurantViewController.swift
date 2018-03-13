import UIKit

class NewRestaurantViewController: UIViewController {
    private let router: Router
    private let repo: RestaurantRepo
    private let form: RestaurantForm

    init(
        router: Router,
        repo: RestaurantRepo,
        categoryRepo: CategoryRepo,
        mapService: MapService
    ) {
        self.router = router
        self.repo = repo
        self.form = RestaurantForm(categoryRepo: categoryRepo, mapService: mapService)

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    override func viewDidLoad() {
        setupNavigationBar()
        setupSubviews()
        activateConstraints()
    }

    override func viewDidLayoutSubviews() {
        self.form.updateScrollViewContentView()
    }
    
    private func setupNavigationBar() {
        title = "New Restaurant"

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
    }

    private func activateConstraints() {
        let margins = self.view.safeAreaLayoutGuide

        form.translatesAutoresizingMaskIntoConstraints = false
        form.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        form.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        form.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        form.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }

    @objc func saveTapped() {
        guard let newRestaurant = form.newRestaurant() else { return }
        repo.create(newRestaurant: newRestaurant)
                .onSuccess { restaurantId in
                    self.router.showRestaurantDetailScreen(id: restaurantId)
                    self.dismissModal()
                }
    }

    @objc func dismissModal() {
        router.dismissModal()
    }
}
