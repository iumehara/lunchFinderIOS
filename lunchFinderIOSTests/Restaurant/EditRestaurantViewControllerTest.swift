import XCTest
import Nimble
@testable import lunchFinderIOS

class EditRestaurantViewControllerTest: XCTestCase {
    var controller: EditRestaurantViewController!
    var router: SpyRouter!
    var repo: SuccessStubRestaurantRepo!
    var categoryRepo: SuccessStubCategoryRepo!
    var mapService: SpyMapService!

    override func setUp() {
        self.router = SpyRouter()
        self.repo = SuccessStubRestaurantRepo()
        self.categoryRepo = SuccessStubCategoryRepo()
        self.mapService = SpyMapService()
        self.controller = EditRestaurantViewController(
            router: router,
            repo: repo,
            categoryRepo: categoryRepo,
            mapService: mapService,
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
        expect(subviews.count).to(equal(2))
        expect(String(describing: type(of: subviews[0]))).to(equal("RestaurantForm"))
        expect(String(describing: type(of: subviews[1]))).to(equal("UIButton"))
    }
    
    func test_formSubmission() {
        let restaurantForm = controller.view.subviews[0] as! RestaurantForm
        
        let nameInputRow = restaurantForm.subviews[1] as! TextInputRow
        let nameInputField = nameInputRow.subviews[1] as! UITextField
        nameInputField.text = "new value"
        
        let saveButton = controller.navigationItem.rightBarButtonItem
        UIApplication.shared.sendAction(saveButton!.action!, to: saveButton!.target, from: self, for: nil)
        
        expect(self.repo.update_wasCalledWith.0).to(equal(1))
        expect(self.repo.update_wasCalledWith.1).to(equal(NewRestaurant(name: "new value")))
        expect(self.router.showRestaurantDetailScreen_wasCalledWith).toEventually(equal(1))
    }
    
    func test_delete() {
        let deleteButton = controller.view.subviews[1] as! UIButton
        deleteButton.sendActions(for: UIControlEvents.touchUpInside)
        
        expect(self.repo.delete_wasCalledWith).to(equal(1))
        expect(self.router.showRestaurantListScreen_wasCalled).toEventually(beTrue())
    }
}
