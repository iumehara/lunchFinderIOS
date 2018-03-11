import UIKit
import BrightFutures

class EditableCategoryTableViewProtocols: CategoryTableViewProtocols {
    private var editingCallback: ((Int) -> Future<Void, NSError>)?
    
    override init(router: Router) {
        super.init(router: router)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    func setEditingCallback(editingCallback: @escaping (Int) -> Future<Void, NSError>) {
        self.editingCallback = editingCallback
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
