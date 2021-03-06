import UIKit

class CategoryTableViewProtocols: NSObject {
    // MARK: - Properties
    static let cellIdentifier: String = String(describing: UITableViewCell.self)
    
    private let router: Router
    
    var categories: [BasicCategory] = []
    
    // MARK: - Constructors
    init(router: Router) {
        self.router = router
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }

    // MARK: - Public Methods
    func setCategories(categories: [BasicCategory]) {
        self.categories = categories
    }
}

// MARK: - Extension: UITableViewDataSource
extension CategoryTableViewProtocols: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewProtocols.cellIdentifier, for: indexPath)
        if cell.detailTextLabel == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: CategoryTableViewProtocols.cellIdentifier)
        }
 
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.name
        cell.detailTextLabel?.text = "\(category.restaurantCount) restaurants"
        return cell
    }
}

extension CategoryTableViewProtocols: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = categories[indexPath.row]
        router.showCategoryDetailScreen(id: selectedCategory.id)
    }
}
