import XCTest
@testable import lunchFinderIOS

class NewRestaurantViewControllerTest: XCTestCase {
    var controller: NewRestaurantViewController!
    var repo: SuccessStubRestaurantRepo!
    var categoryRepo: SuccessStubCategoryRepo!
    
    override func setUp() {
        repo = SuccessStubRestaurantRepo()
        categoryRepo = SuccessStubCategoryRepo()
        controller = NewRestaurantViewController(router: DummyRouter(), repo: repo, categoryRepo: categoryRepo)
        
        controller.viewDidLoad()
    }
    
    func test_title() {
        XCTAssertEqual(controller.title, "New Restaurant")
    }
    
    func test_subviews() {
        let subviewTypes = controller.view.subviews.map { view in
            return String(describing: type(of: view))
        }

        XCTAssertEqual(subviewTypes.count, 1)
        XCTAssertTrue(subviewTypes.contains("RestaurantForm"))
    }
}
