import XCTest
@testable import lunchFinderIOS

class CategoryListViewControllerTest: XCTestCase {
    var categoryListViewController: CategoryListViewController!
    var repo: SuccessStubCategoryRepo!
    
    override func setUp() {
        repo = SuccessStubCategoryRepo()
        categoryListViewController = CategoryListViewController(
            router: DummyRouter(),
            repo: repo
        )

        categoryListViewController.viewDidLoad()
    }

    func test_title() {
        let title = categoryListViewController.title

        XCTAssertEqual(title, "Categories")
    }

    func test_numberOfSections() {
        let numberOfSections = categoryListViewController.numberOfSections(
            in: categoryListViewController.tableView
        )

        XCTAssertEqual(numberOfSections, 1)
    }

    func test_tableData() {
        repo.getAll_responseFuture.onSuccess(callback: { _ in
            let table = self.categoryListViewController.tableView!
            
            let firstRowText = table.cellForRow(at: IndexPath(row: 0, section: 0))?.textLabel?.text!
            let secondRowText = table.cellForRow(at: IndexPath(row: 1, section: 0))?.textLabel?.text!
            
            XCTAssertEqual(firstRowText, "Category A")
            XCTAssertEqual(secondRowText, "Category B")
        })
        
        XCTAssertTrue(repo.getAll_responseFuture.isCompleted)
    }
}
