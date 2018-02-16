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
}
