import XCTest
import Nimble
@testable import lunchFinderIOS

class EditRestaurantViewControllerTest: XCTestCase {
    var controller: EditRestaurantViewController!
    var router: SpyRouter!
    var repo: SuccessStubRestaurantRepo!
    var categoryRepo: SuccessStubCategoryRepo!
    
    
    override func setUp() {
        self.router = SpyRouter()
        self.repo = SuccessStubRestaurantRepo()
        self.categoryRepo = SuccessStubCategoryRepo()
        self.controller = EditRestaurantViewController(
            router: router,
            repo: repo,
            categoryRepo: categoryRepo,
            id: 1
        )
        
        controller.viewDidLoad()
    }
    
    func test_navigationBar() {
        expect(self.controller.title).to(equal("Edit Restaurant"))
        expect(self.controller.navigationItem.rightBarButtonItem).toNot(beNil())
    }
    
    func test_subviews() {
        let subviews = controller.view.subviews
        expect(subviews.count).to(equal(1))
        expect(String(describing: type(of: subviews[0]))).to(equal("RestaurantForm"))
    }
}
