import UIKit

class NewRestaurantViewController: UIViewController {
    private let router: Router
    private let repo: RestaurantRepo
    private let form: RestaurantForm
    private let mapService: MapService
    private let map: Map

    init(
            router: Router,
            repo: RestaurantRepo,
            categoryRepo: CategoryRepo,
            mapService: MapService
    ) {
        self.router = router
        self.repo = repo
        self.form = RestaurantForm(categoryRepo: categoryRepo)
        self.mapService = mapService
        self.map = mapService.createMap(isSelectable: true)

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    override func viewDidLoad() {
        title = "New Restaurant"

        setupSubviews()
        activateConstraints()
    }
    
    func setupSubviews() {
        view.backgroundColor = UIColor.white
        let saveButton = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
        navigationItem.rightBarButtonItem = saveButton

        view.addSubview(map)

        view.addSubview(form)
    }
    
    func activateConstraints() {
        let margins = self.view.safeAreaLayoutGuide

        map.translatesAutoresizingMaskIntoConstraints = false
        map.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        map.heightAnchor.constraint(equalToConstant: CGFloat(300)).isActive = true
        map.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        map.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true

        form.translatesAutoresizingMaskIntoConstraints = false
        form.topAnchor.constraint(equalTo: map.bottomAnchor).isActive = true
        form.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        form.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
    }
    
    @objc
    func saveTapped() {
        let position = map.marker?.position
        var geolocation: Geolocation?
        if let lat = position?.latitude, let long = position?.longitude {
            geolocation = Geolocation(lat: lat, long: long)
        }
    
        guard let newRestaurant = form.newRestaurant(geolocation: geolocation) else { return }
        repo.create(newRestaurant: newRestaurant)
            .onSuccess { restaurantId in self.router.showRestaurantDetailScreen(id: restaurantId) }
    }
}
