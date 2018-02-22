import UIKit

class CategoryListViewController: UITableViewController {
    private let router: Router
    private let repo: CategoryRepo
    private let tableViewCellIdentifier: String = String(describing: UITableViewCell.self)
    private var categories: [Category] = []
    
    init(router: Router, repo: CategoryRepo) {
        self.router = router
        self.repo = repo
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Categories"
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(addTapped))
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableViewCellIdentifier)

        repo.getAll()
            .onSuccess { categories in self.categories = categories }
            .onFailure { error in print("failed \(error)") }
            .onComplete { _ in self.tableView.reloadData() }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier, for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = categories[indexPath.row]
        router.showCategoryDetailScreen(id: selectedCategory.id)
    }
    
    @objc
    func addTapped() {
        router.showNewCategoryScreen()
    }
}
