import UIKit

class NewCategoryViewController: UIViewController {
    private let router: Router
    private let repo: CategoryRepo
    private let nameLabel: UILabel
    private let nameInput: UITextField
    private let cellIdentifier: String = String(describing: UITableViewCell.self)
    
    init(router: Router, repo: CategoryRepo) {
        self.router = router
        self.repo = repo
        self.nameLabel = UILabel()
        self.nameInput = UITextField()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    override func viewDidLoad() {
        title = "New Category"
        
        setupSubviews()
        activateConstraints()
    }
    
    private func setupSubviews() {
        let saveButton = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
        navigationItem.rightBarButtonItem = saveButton
        
        view.backgroundColor = UIColor.white
        
        nameLabel.text = "Name"
        nameLabel.backgroundColor = UIColor.white
        view.addSubview(nameLabel)

        nameInput.backgroundColor = UIColor.white
        nameInput.layer.borderColor = UIColor.black.cgColor
        nameInput.layer.borderWidth = 1.0
        view.addSubview(nameInput)
    }
    
    private func activateConstraints() {
        let margins = self.view.safeAreaLayoutGuide
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: CGFloat(100)).isActive = true

        nameInput.translatesAutoresizingMaskIntoConstraints = false
        nameInput.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        nameInput.heightAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        nameInput.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
        nameInput.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
    }
    
    @objc
    func saveTapped() {
        if let name = nameInput.text {
            let newCategory = NewCategory(name: name)
            repo.create(newCategory: newCategory)
                .onSuccess { categoryId in
                    self.router.showCategoryDetailScreen(id: categoryId)
                }
                .onFailure { error in
                }
                .onComplete { value in
                }
        }
    }
}
