import UIKit

class RestaurantForm: UIView {
    // MARK: - Properties
    private let categoryRepo: CategoryRepo
    private let mapService: MapService

    private let mapLabel: UILabel
    private let map: UIView
    private var scrollView: UIScrollView
    private let nameInputRow: TextInputRow = TextInputRow(labelText: "name")
    private let nameJpInputRow: TextInputRow = TextInputRow(labelText: "店名")
    private let websiteInputRow: UrlInputRow = UrlInputRow(labelText: "website")
    private let categoriesInputRow: MultipleSelectInput = MultipleSelectInput(labelText: "categories")

    // MARK: - Constructors
    init(categoryRepo: CategoryRepo, mapService: MapService) {
        self.categoryRepo = categoryRepo
        self.mapService = mapService
        self.mapLabel = UILabel()
        self.map = mapService.createMap(isSelectable: true)
        self.scrollView = UIScrollView()
        
        super.init(frame: CGRect.zero)
        
        viewDidLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }

    // MARK: - Public Methods
    func setDefaultValues(restaurant: Restaurant) {
        if let geolocation = restaurant.geolocation {
            self.mapService.setDraggableMarker(geolocation: geolocation)
        }
        
        nameInputRow.setDefaultValue(defaultValue: restaurant.name)
        if let nameJp = restaurant.nameJp {
            nameJpInputRow.setDefaultValue(defaultValue: nameJp)
        }
        if let website = restaurant.website {
            websiteInputRow.setDefaultValue(defaultValue: website)
        }
        
        categoriesInputRow.setDefaultValues(
            options: restaurant.categories.map { category in
                SelectOption(id: category.id, name: category.name)
            }
        )
    }
    
    func newRestaurant() -> NewRestaurant? {
        guard let name = nameInputRow.text() else { return nil }
        let geolocation = mapService.getMarkerPosition()
        
        return NewRestaurant(
            name: name,
            nameJp: nameJpInputRow.text(),
            website: websiteInputRow.text(),
            categoryIds: categoriesInputRow.ids(),
            geolocation: geolocation
        )
    }

    // MARK: - Lifecycle Methods
    private func viewDidLoad() {
        setupSubviews()
        activateConstraints()
        fetchData()
    }
    
    // MARK: - Setup Methods
    private func setupSubviews() {
        scrollView.frame = self.bounds
        scrollView.contentSize = CGSize(width: self.bounds.width, height: self.bounds.height)
        addSubview(scrollView)
        
        mapLabel.text = "Add a marker by tapping the restaurant location on the map"
        scrollView.addSubview(mapLabel)
        scrollView.addSubview(map)
        scrollView.addSubview(nameInputRow)
        scrollView.addSubview(nameJpInputRow)
        scrollView.addSubview(websiteInputRow)
        scrollView.addSubview(categoriesInputRow)
    }
    
    private func activateConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        mapLabel.translatesAutoresizingMaskIntoConstraints = false
        mapLabel.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        mapLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        mapLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

        map.translatesAutoresizingMaskIntoConstraints = false
        map.topAnchor.constraint(equalTo: mapLabel.bottomAnchor).isActive = true
        map.heightAnchor.constraint(equalToConstant: CGFloat(300)).isActive = true
        map.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        map.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

        nameInputRow.translatesAutoresizingMaskIntoConstraints = false
        nameInputRow.topAnchor.constraint(equalTo: map.bottomAnchor).isActive = true
        nameInputRow.heightAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        nameInputRow.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        nameInputRow.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

        nameJpInputRow.translatesAutoresizingMaskIntoConstraints = false
        nameJpInputRow.topAnchor.constraint(equalTo: nameInputRow.bottomAnchor).isActive = true
        nameJpInputRow.heightAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        nameJpInputRow.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        nameJpInputRow.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

        websiteInputRow.translatesAutoresizingMaskIntoConstraints = false
        websiteInputRow.topAnchor.constraint(equalTo: nameJpInputRow.bottomAnchor).isActive = true
        websiteInputRow.heightAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        websiteInputRow.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        websiteInputRow.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

        categoriesInputRow.translatesAutoresizingMaskIntoConstraints = false
        categoriesInputRow.topAnchor.constraint(equalTo: websiteInputRow.bottomAnchor).isActive = true
        categoriesInputRow.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        categoriesInputRow.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        categoriesInputRow.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

    // MARK: - Request Methods
    private func fetchData() {
        categoryRepo.getAll()
            .onSuccess { categories in
                let options = categories.map { category in
                    return SelectOption(id: category.id, name: category.name)
                }
                self.categoriesInputRow.setOptions(selectOptions: options)
            }
            .onComplete { _ in self.categoriesInputRow.reloadInputViews()}
    }
}
