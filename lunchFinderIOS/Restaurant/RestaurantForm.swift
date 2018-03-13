import UIKit

class RestaurantForm: UIView {
    private let categoryRepo: CategoryRepo
    private let mapService: MapService
    private let map: UIView
    private let nameInputRow: TextInputRow = TextInputRow(labelText: "name")
    private let nameJpInputRow: TextInputRow = TextInputRow(labelText: "店名")
    private let websiteInputRow: TextInputRow = TextInputRow(labelText: "website")
    private let categoriesInputRow: MultipleSelectInput = MultipleSelectInput(labelText: "categories")
    private var scrollView: UIScrollView

    init(categoryRepo: CategoryRepo, mapService: MapService) {
        self.categoryRepo = categoryRepo
        self.mapService = mapService
        self.map = mapService.createMap(isSelectable: true)
        self.scrollView = UIScrollView()
        
        super.init(frame: CGRect.zero)

        fetchData()
        setupSubviews()
        activateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }

    func fetchData() {
        categoryRepo.getAll()
            .onSuccess { categories in
                let options = categories.map { category in
                    return SelectOption(id: category.id, name: category.name)
                }
                self.categoriesInputRow.setOptions(selectOptions: options)
            }
    }
    
    func setDefaultValues(restaurant: Restaurant) {
        if let _ = restaurant.geolocation {
            self.mapService.setMarker(restaurant: BasicRestaurant(restaurant: restaurant))
        }

        nameInputRow.setDefaultValue(defaultValue: restaurant.name)
        if let nameJp = restaurant.nameJp {
            nameJpInputRow.setDefaultValue(defaultValue: nameJp)
        }
        if let website = restaurant.website {
            websiteInputRow.setDefaultValue(defaultValue: website)
        }

        categoriesInputRow.setDefaultValues(
                options: restaurant.categories.map { cat in SelectOption(id: cat.id, name: cat.name) }
        )
    }

    func setupSubviews() {
        scrollView.frame = self.bounds
        scrollView.contentSize = CGSize(width: self.bounds.width, height: self.bounds.height)

        addSubview(scrollView)
        scrollView.addSubview(map)
        scrollView.addSubview(nameInputRow)
        scrollView.addSubview(nameJpInputRow)
        scrollView.addSubview(websiteInputRow)
        scrollView.addSubview(categoriesInputRow)
    }

    func updateScrollViewContentView() {
        let pickerViewHeight = CGFloat(300)
        scrollView.contentSize.height = map.frame.height
            + nameInputRow.frame.height
            + nameJpInputRow.frame.height
            + websiteInputRow.frame.height
            + categoriesInputRow.frame.height
            + pickerViewHeight

        let initialCategoriesInputRowHeight = CGFloat(50)
        if categoriesInputRow.frame.height > initialCategoriesInputRowHeight {
            let offsetToBottom = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height)
            scrollView.setContentOffset(offsetToBottom, animated: true)
        }
    }
    
    func activateConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        map.translatesAutoresizingMaskIntoConstraints = false
        map.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
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
}
