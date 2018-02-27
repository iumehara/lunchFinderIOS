import UIKit

class RestaurantForm: UIView {
    private let categoryRepo: CategoryRepo
    private let nameInputRow: TextInputRow = TextInputRow(labelText: "name")
    private let nameJpInputRow: TextInputRow = TextInputRow(labelText: "店名")
    private let websiteInputRow: TextInputRow = TextInputRow(labelText: "website")
    private let geolocationLabel: UILabel = UILabel()
    private let geolocationLatInputRow: TextInputRow = TextInputRow(labelText: "Lat", labelWidth: CGFloat(40))
    private let geolocationLongInputRow: TextInputRow = TextInputRow(labelText: "Long", labelWidth: CGFloat(40))
    private let categoriesInputRow: MultipleSelectInput = MultipleSelectInput(labelText: "categories")

    init(categoryRepo: CategoryRepo) {
        self.categoryRepo = categoryRepo
        self.geolocationLabel.text = "Geolocation"

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
        nameInputRow.setDefaultValue(defaultValue: restaurant.name)
        if let nameJp = restaurant.nameJp {
            nameJpInputRow.setDefaultValue(defaultValue: nameJp)
        }
        if let website = restaurant.website {
            websiteInputRow.setDefaultValue(defaultValue: website)
        }
        if let geolocation = restaurant.geolocation {
            geolocationLatInputRow.setDefaultValue(defaultValue: String(describing: geolocation.lat))
            geolocationLongInputRow.setDefaultValue(defaultValue: String(describing: geolocation.long))
        }
        
        categoriesInputRow.setDefaultValues(options: restaurant.categories.map { cat in SelectOption(id: cat.id, name: cat.name) })
    }

    func setupSubviews() {
        self.backgroundColor = UIColor.white
        
        addSubview(nameInputRow)
        addSubview(nameJpInputRow)	
        addSubview(websiteInputRow)
        addSubview(geolocationLabel)
        addSubview(geolocationLatInputRow)
        addSubview(geolocationLongInputRow)
        addSubview(categoriesInputRow)
    }
    
    func activateConstraints() {
        nameInputRow.translatesAutoresizingMaskIntoConstraints = false
        nameInputRow.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        nameInputRow.heightAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        nameInputRow.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        nameInputRow.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

        nameJpInputRow.translatesAutoresizingMaskIntoConstraints = false
        nameJpInputRow.topAnchor.constraint(equalTo: nameInputRow.bottomAnchor).isActive = true
        nameJpInputRow.heightAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        nameJpInputRow.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        nameJpInputRow.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

        websiteInputRow.translatesAutoresizingMaskIntoConstraints = false
        websiteInputRow.topAnchor.constraint(equalTo: nameJpInputRow.bottomAnchor).isActive = true
        websiteInputRow.heightAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        websiteInputRow.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        websiteInputRow.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

        geolocationLabel.translatesAutoresizingMaskIntoConstraints = false
        geolocationLabel.topAnchor.constraint(equalTo: websiteInputRow.bottomAnchor).isActive = true
        geolocationLabel.heightAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        geolocationLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        geolocationLabel.widthAnchor.constraint(equalToConstant: CGFloat(100)).isActive = true

        geolocationLatInputRow.translatesAutoresizingMaskIntoConstraints = false
        geolocationLatInputRow.topAnchor.constraint(equalTo: websiteInputRow.bottomAnchor).isActive = true
        geolocationLatInputRow.heightAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        geolocationLatInputRow.leadingAnchor.constraint(equalTo: geolocationLabel.trailingAnchor).isActive = true
        geolocationLatInputRow.widthAnchor.constraint(equalToConstant: CGFloat(130)).isActive = true

        geolocationLongInputRow.translatesAutoresizingMaskIntoConstraints = false
        geolocationLongInputRow.topAnchor.constraint(equalTo: websiteInputRow.bottomAnchor).isActive = true
        geolocationLongInputRow.heightAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        geolocationLongInputRow.leadingAnchor.constraint(equalTo: geolocationLatInputRow.trailingAnchor).isActive = true
        geolocationLongInputRow.widthAnchor.constraint(equalToConstant: CGFloat(130)).isActive = true

        categoriesInputRow.translatesAutoresizingMaskIntoConstraints = false
        categoriesInputRow.topAnchor.constraint(equalTo: geolocationLabel.bottomAnchor).isActive = true
        categoriesInputRow.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        categoriesInputRow.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

        self.bottomAnchor.constraint(equalTo: categoriesInputRow.bottomAnchor).isActive = true
    }

    func newRestaurant() -> NewRestaurant? {
        guard let name = nameInputRow.text() else { return nil }

        var geolocation: Geolocation? = nil
        if let latString = geolocationLatInputRow.text(), let longString = self.geolocationLongInputRow.text() {
            if let lat = Double(latString), let long = Double(longString) {
                geolocation = Geolocation(lat: lat, long: long)
            }
        }
        
        return NewRestaurant(
            name: name,
            nameJp: nameJpInputRow.text(),
            website: websiteInputRow.text(),
            categoryIds: categoriesInputRow.ids(),
            geolocation: geolocation
        )
    }
}
