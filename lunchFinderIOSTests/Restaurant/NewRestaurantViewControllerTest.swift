import XCTest
import Nimble
@testable import lunchFinderIOS

class NewRestaurantViewControllerTest: XCTestCase {
    var controller: NewRestaurantViewController!
    var router: SpyRouter!
    var repo: SuccessStubRestaurantRepo!
    var categoryRepo: SuccessStubCategoryRepo!
    
    override func setUp() {
        router = SpyRouter()
        repo = SuccessStubRestaurantRepo()
        categoryRepo = SuccessStubCategoryRepo()
        controller = NewRestaurantViewController(
            router: router,
            repo: repo,
            categoryRepo: categoryRepo
        )
        
        controller.viewDidLoad()
    }
    
    func test_navigationBar() {
        expect(self.controller.title).to(equal("New Restaurant"))
        expect(self.controller.navigationItem.rightBarButtonItem).toNot(beNil())
    }
    
    func test_subviews() {
        let subviewTypes = controller.view.subviews.map { view in
            return String(describing: type(of: view))
        }

        expect(subviewTypes.count).to(equal(1))
        expect(subviewTypes).to(contain("RestaurantForm"))
    }
    
    func test_formSubmission() {
        let restaurantForm = controller.view.subviews[0] as! RestaurantForm
        
        let nameInputRow = restaurantForm.subviews[0] as! TextInputRow
        let nameInputField = nameInputRow.subviews[1] as! UITextField
        nameInputField.text = "new value"
        
        let saveButton = controller.navigationItem.rightBarButtonItem
        UIApplication.shared.sendAction(saveButton!.action!, to: saveButton!.target, from: self, for: nil)

        expect(self.repo.create_wasCalledWith).to(equal(NewRestaurant(name: "new value")))
        expect(self.router.showRestaurantDetailScreen_wasCalledWith).toEventually(equal(1))
    }
}
