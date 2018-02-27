import XCTest
@testable import lunchFinderIOS

class RestaurantFormTest: XCTestCase {
    var form: RestaurantForm!
    var categoryRepo: SuccessStubCategoryRepo!
    
    override func setUp() {
        categoryRepo = SuccessStubCategoryRepo()
        form = RestaurantForm(categoryRepo: categoryRepo)
    }
    
    func test_subviews() {
        let subviews = form.subviews
        let subviewTypes = form.subviews.map { view in
            return String(describing: type(of: view))
        }
        
        XCTAssertEqual(subviews.count, 7)
        XCTAssertTrue(subviewTypes.contains("TextInputRow"))
        XCTAssertTrue(subviewTypes.contains("MultipleSelectInput"))
    }
}
