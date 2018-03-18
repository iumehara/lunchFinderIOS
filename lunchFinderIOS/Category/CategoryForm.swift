import UIKit

class CategoryForm: UIView {
    // MARK: - Properties
    private let nameInputRow: TextInputRow = TextInputRow(labelText: "name")
    
    // MARK: - Constructors
    init() {
        super.init(frame: CGRect.zero)
        viewDidLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    // MARK: - Public Methods
    func setDefaultValues(category: Category) {
        nameInputRow.setDefaultValue(defaultValue: category.name)
    }
    
    func newCategory() -> NewCategory? {
        guard let name = nameInputRow.text() else { return nil }
        return NewCategory(name: name)
    }

    // MARK: - Private Lifecycle Methods
    private func viewDidLoad() {
        setupSubviews()
        activateConstraints()
    }
    
    // MARK: - Private Methods
    private func setupSubviews() {
        self.addSubview(nameInputRow)
    }
    
    private func activateConstraints() {
        nameInputRow.translatesAutoresizingMaskIntoConstraints = false
        nameInputRow.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        nameInputRow.heightAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        nameInputRow.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        nameInputRow.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
}
