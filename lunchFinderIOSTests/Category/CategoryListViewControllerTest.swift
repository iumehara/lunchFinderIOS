import XCTest
import Nimble
@testable import lunchFinderIOS

class CategoryListViewControllerTest: XCTestCase {
    var controller: CategoryListViewController!
    var repo: SuccessStubCategoryRepo!
    
    override func setUp() {
        repo = SuccessStubCategoryRepo()
        controller = CategoryListViewController(
            router: SpyRouter(),
            repo: repo
        )

        controller.viewDidLoad()
    }

    func test_navigationBar() {
        expect(self.controller.title).to(equal("Categories"))
        expect(self.controller.navigationItem.rightBarButtonItem).toNot(beNil())
        expect(self.controller.navigationItem.leftBarButtonItem!.title).to(equal("Restaurants"))
    }

    func test_subviews() {
        let subviewTypes = controller.view.subviews.map { view in
            return String(describing: type(of: view))
        }
        
        expect(subviewTypes.count).to(equal(1))
        expect(subviewTypes).to(contain("UITableView"))
    }

    func test_tableData() {
        let table = self.controller.view.subviews[0] as! UITableView
        
        expect(table.cellForRow(at: IndexPath(row: 0, section: 0))!.textLabel!.text!).toEventually(equal("Category A"))
    }
}
