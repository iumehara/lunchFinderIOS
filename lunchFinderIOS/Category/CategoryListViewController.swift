import UIKit

class CategoryListViewController: UITableViewController {
    private let router: Router
    private let repo: CategoryRepo
    private let tableViewCellIdentifier: String = String(describing: UITableViewCell.self)
    private var categories: [BasicCategory] = []

    init(router: Router, repo: CategoryRepo) {
        self.router = router
        self.repo = repo
        super.init(nibName: nil, bundle:  nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        
        self.refreshControl = UIRefreshControl()
        if let control = refreshControl {
            tableView.refreshControl = control
            control.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        }
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableViewCellIdentifier)

        repo.getAll()
            .onSuccess { categories in self.categories = categories }
            .onFailure { error in print("failed \(error)") }
            .onComplete { _ in self.tableView.reloadData() }
    }
    
    private func setupNavigationBar() {
        title = "LunchFinder"
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(
            title: "Add Category",
            style: UIBarButtonItemStyle.plain,
            target: self,
            action: #selector(addCategoryTapped)
        )
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(
            title: "Add Restaurant",
            style: UIBarButtonItemStyle.plain,
            target: self,
            action: #selector(addRestaurantTapped)
        )
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

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let selectedCategory = categories[indexPath.row]
            repo.delete(id: selectedCategory.id)
                .onSuccess { _ in
                    self.categories.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
        }
    }

    @objc
    func addCategoryTapped() {
        router.showNewCategoryScreen()
    }

    @objc
    func addRestaurantTapped() {
        router.showNewRestaurantScreen()
    }

    @objc
    func reloadData() {
        repo.getAll()
                .onSuccess { categories in self.categories = categories }
                .onFailure { error in print("failed \(error)") }
                .onComplete { _ in
                    self.tableView.reloadData()
                    self.refreshControl!.endRefreshing()
                }
    }
}
