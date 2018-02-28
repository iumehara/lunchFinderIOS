import XCTest
import Nimble
@testable import lunchFinderIOS

class CategoryListViewControllerTest: XCTestCase {
    var controller: CategoryListViewController!
    var repo: SuccessStubCategoryRepo!
    
    override func setUp() {
        repo = SuccessStubCategoryRepo()
        controller = CategoryListViewController(
            router: DummyRouter(),
            repo: repo
        )

        controller.viewDidLoad()
    }

    func test_navigationBar() {
        expect(self.controller.title).to(equal("LunchFinder"))
        expect(self.controller.navigationItem.leftBarButtonItem!.title).to(equal("Add Restaurant"))
        expect(self.controller.navigationItem.rightBarButtonItem!.title).to(equal("Add Category"))
    }

    func test_numberOfSections() {
        let numberOfSections = controller.numberOfSections(
            in: controller.tableView
        )

        XCTAssertEqual(numberOfSections, 1)
    }

    func test_tableData() {
        let table = self.controller.tableView!

        expect(table.cellForRow(at: IndexPath(row: 0, section: 0))!.textLabel!.text!).toEventually(equal("Category A"))
        expect(table.cellForRow(at: IndexPath(row: 1, section: 0))!.textLabel!.text!).toEventually(equal("Category B"))
    }
}
