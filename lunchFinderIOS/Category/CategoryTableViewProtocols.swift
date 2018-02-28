import UIKit

class CategoryTableViewProtocols: NSObject {
    static let cellIdentifier: String = String(describing: UITableViewCell.self)
    private var categories: [BasicCategory] = []
    private let router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    func setCategories(categories: [BasicCategory]) {
        self.categories = categories
    }
}

extension CategoryTableViewProtocols: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewProtocols.cellIdentifier, for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
}

extension CategoryTableViewProtocols: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = categories[indexPath.row]
        router.showCategoryDetailScreen(id: selectedCategory.id)
    }
}
