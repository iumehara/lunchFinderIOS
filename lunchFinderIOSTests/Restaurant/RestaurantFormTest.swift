import XCTest
import Nimble
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
        
        expect(self.form.subviews.count).to(equal(1))
        guard let scrollview = self.form.subviews.first as? UIScrollView else {
            expect(fail())
            return
        }

        let scrollViewSubviewTypes = scrollview.subviews.map { view in
            return String(describing: type(of: view))
        }

        expect(scrollViewSubviewTypes).to(contain("UIView"))
        expect(scrollViewSubviewTypes).to(contain("TextInputRow"))
        expect(scrollViewSubviewTypes).to(contain("MultipleSelectInput"))
    }
}
