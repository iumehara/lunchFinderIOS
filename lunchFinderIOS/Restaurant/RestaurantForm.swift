import UIKit

class RestaurantForm: UIView {
    private let categoryRepo: CategoryRepo
    private let nameInputRow: TextInputRow = TextInputRow(labelText: "name")
    private let nameJpInputRow: TextInputRow = TextInputRow(labelText: "店名")
    private let websiteInputRow: TextInputRow = TextInputRow(labelText: "website")
    private let categoriesInputRow: MultipleSelectInput = MultipleSelectInput(labelText: "categories")

    init(categoryRepo: CategoryRepo) {
        self.categoryRepo = categoryRepo

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

    func setupSubviews() {
        self.backgroundColor = UIColor.white
        
        addSubview(nameInputRow)
        addSubview(nameJpInputRow)	
        addSubview(websiteInputRow)
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

        categoriesInputRow.translatesAutoresizingMaskIntoConstraints = false
        categoriesInputRow.topAnchor.constraint(equalTo: websiteInputRow.bottomAnchor).isActive = true
        categoriesInputRow.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        categoriesInputRow.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

        self.bottomAnchor.constraint(equalTo: categoriesInputRow.bottomAnchor).isActive = true
    }

    func newRestaurant() -> NewRestaurant? {
        guard let name = nameInputRow.text() else { return nil }

        return NewRestaurant(
            name: name,
            nameJp: nameJpInputRow.text(),
            website: websiteInputRow.text(),
            categoryIds: categoriesInputRow.ids(),
            geolocation: nil
        )
    }
}
