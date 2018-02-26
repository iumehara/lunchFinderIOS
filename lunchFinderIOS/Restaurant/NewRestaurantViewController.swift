import UIKit

class NewRestaurantViewController: UIViewController {
    private let router: Router
    private let repo: RestaurantRepo
    private let form: RestaurantForm

    init(router: Router, repo: RestaurantRepo, categoryRepo: CategoryRepo) {
        self.router = router
        self.repo = repo
        self.form = RestaurantForm(categoryRepo: categoryRepo)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    override func viewDidLoad() {
        title = "New Restaurant"

        setupSubviews()
        activateConstraints()
    }
    
    func setupSubviews() {
        view.backgroundColor = UIColor.white
        let saveButton = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
        navigationItem.rightBarButtonItem = saveButton

        view.addSubview(form)
    }
    
    func activateConstraints() {
        let margins = self.view.safeAreaLayoutGuide

        form.translatesAutoresizingMaskIntoConstraints = false
        form.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        form.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        form.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
    }
    
    @objc
    func saveTapped() {
        print("saveTapped \(form.newRestaurant())")
    }
}
