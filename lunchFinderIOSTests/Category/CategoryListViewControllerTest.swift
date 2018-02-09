import XCTest
@testable import lunchFinderIOS

class CategoryListViewControllerTest: XCTestCase {
    var categoryListViewController: UITableViewController!

    override func setUp() {
        categoryListViewController = CategoryListViewController(
            router: DummyRouter(),
            repo: SuccessStubCategoryRepo()
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
        let numberOfRows = categoryListViewController.tableView(
            categoryListViewController.tableView,
            numberOfRowsInSection: 0
        )

        XCTAssertGreaterThan(numberOfRows, 0)
    }
}
