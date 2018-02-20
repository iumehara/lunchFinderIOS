import XCTest
import Result
@testable import lunchFinderIOS

class CategoryDetailViewControllerTest: XCTestCase {
    var categoryDetailViewController: CategoryDetailViewController!
    var repo: SuccessStubCategoryRepo!
    
    override func setUp() {
        repo = SuccessStubCategoryRepo()
        categoryDetailViewController = CategoryDetailViewController(
            router: DummyRouter(),
            repo: repo,
            id: 1
        )

        categoryDetailViewController.viewDidLoad()
    }
    
    func test_title() {
        repo.get_responseFuture
            .onSuccess(callback: { _ in
                let title = self.categoryDetailViewController.title
                XCTAssertEqual(title, "Category A")
            })
        
        XCTAssertTrue(repo.get_responseFuture.isCompleted)
    }

    func test_tableData() {
        repo.get_responseFuture
            .onSuccess(callback: { _ in
                let table = self.categoryDetailViewController.view.subviews[0] as! UITableView
                XCTAssertEqual(table.numberOfRows(inSection: 0), 2)
                XCTAssertEqual(table.cellForRow(at: IndexPath(row: 0, section: 0))?.textLabel?.text, "Restaurant A")
            })
        
        XCTAssertTrue(repo.get_responseFuture.isCompleted)
    }
}
