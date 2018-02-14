import XCTest
@testable import lunchFinderIOS

class CategoryListViewControllerTest: XCTestCase {
    var categoryListViewController: UITableViewController!
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

    func test_numberOfRows() {
        repo.responseFuture.onSuccess(callback: { _ in
            let numberOfRows = self.categoryListViewController.tableView(
                self.categoryListViewController.tableView,
                numberOfRowsInSection: 0
            )
            
            XCTAssertGreaterThan(numberOfRows, 0)
        })
    }
}
