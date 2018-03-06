import XCTest
@testable import lunchFinderIOS

class RestaurantFormTest: XCTestCase {
    var form: RestaurantForm!
    var categoryRepo: SuccessStubCategoryRepo!
    var mapService: SpyMapService!

    override func setUp() {
        categoryRepo = SuccessStubCategoryRepo()
        mapService = SpyMapService()
        form = RestaurantForm(categoryRepo: categoryRepo, mapService: mapService)
    }
    
    func test_subviews() {
        let subviews = form.subviews
        let subviewTypes = form.subviews.map { view in
            return String(describing: type(of: view))
        }
        
        XCTAssertEqual(subviews.count, 5)
        XCTAssertTrue(subviewTypes.contains("TextInputRow"))
        XCTAssertTrue(subviewTypes.contains("MultipleSelectInput"))
    }
}
