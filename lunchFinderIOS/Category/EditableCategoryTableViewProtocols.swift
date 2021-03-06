import UIKit
import BrightFutures

class EditableCategoryTableViewProtocols: CategoryTableViewProtocols {
    // MARK: - Properties
    private var editingCallback: ((Int) -> Future<Void, NSError>)?
    
    // MARK: - Constructors
    override init(router: Router) {
        super.init(router: router)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    // MARK: - Public Methods
    func setEditingCallback(editingCallback: @escaping (Int) -> Future<Void, NSError>) {
        self.editingCallback = editingCallback
    }

    // MARK: - Protocol Methods
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Categories"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let selectedCategory = self.categories[indexPath.row]
            if let callback = self.editingCallback {
                let _ = callback(selectedCategory.id)
            }
        }
    }
}
