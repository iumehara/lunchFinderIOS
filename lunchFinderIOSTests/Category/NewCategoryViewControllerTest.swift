import XCTest
import Nimble
@testable import lunchFinderIOS

class NewCategoryViewControllerTest: XCTestCase {
    var controller: NewCategoryViewController!
    var repo: SuccessStubCategoryRepo!

    override func setUp() {
        repo = SuccessStubCategoryRepo()
        controller = NewCategoryViewController(
                router: DummyRouter(),
                repo: repo
        )

        controller.viewDidLoad()
    }

    func test_navigationBar() {
        expect(self.controller.title).to(equal("New Category"))
    }
}
