import UIKit

class EditCategoryViewController: UIViewController {
    // MARK: - Properties
    private let router: Router
    private let repo: CategoryRepo
    
    private let id: Int
    
    private let form: CategoryForm
    private let deleteButton: UIButton
    
    // MARK: - Constructors
    init(router: Router, repo: CategoryRepo, id: Int) {
        self.router = router
        self.repo = repo
        self.id = id
        self.form = CategoryForm()
        self.deleteButton = UIButton()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        setupNavigationBar()
        setupSubviews()
        activateConstraints()
        fetchData()
    }
    
    // MARK: - Private Methods
    private func setupNavigationBar() {
        title = "Edit Category"

        navigationItem.rightBarButtonItem = UIBarButtonItem.init(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(saveTapped)
        )
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(dismissModal)
        )
    }
    
    private func  setupSubviews() {
        view.backgroundColor = UIColor.white
        
        view.addSubview(form)

        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        deleteButton.setTitle("Delete Category", for: .normal)
        deleteButton.setTitleColor(.white, for: .normal)
        deleteButton.backgroundColor = UIColor.red
        view.addSubview(deleteButton)
    }
    
    private func activateConstraints() {
        let margins = self.view.safeAreaLayoutGuide
        
        form.translatesAutoresizingMaskIntoConstraints = false
        form.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        form.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        form.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.topAnchor.constraint(equalTo: form.bottomAnchor).isActive = true
        deleteButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        deleteButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
    
    private func fetchData() {
        repo.get(id: id)
            .onSuccess { category in self.form.setDefaultValues(category: category) }
    }

    @objc private func saveTapped() {
        guard let newCategory = form.newCategory() else { return }
        repo.update(id: id, newCategory: newCategory)
            .onSuccess { _ in self.dismissModal() }
    }
    
    @objc private func deleteTapped() {
        repo.delete(id: id)
            .onSuccess { _ in
                self.router.showCategoryListScreen()
                self.dismissModal()
        }
    }
    
    @objc private func dismissModal() {
        NotificationCenter.default.post(name: NSNotification.Name("modalWasDismissed"), object: nil)
        router.dismissModal()
    }
}
