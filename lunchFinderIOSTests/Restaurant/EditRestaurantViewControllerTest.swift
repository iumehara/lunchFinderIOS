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
        
        let leftBarButton = controller.navigationItem.leftBarButtonItem
        UIApplication.shared.sendAction(leftBarButton!.action!, to: leftBarButton!.target, from: self, for: nil)
        expect(self.router.dismissModal_wasCalled).to(beTrue())

        let rightBarButton = controller.navigationItem.rightBarButtonItem
        expect(rightBarButton).toNot(beNil())
    }
    
    func test_subviews() {
        let subviews = controller.view.subviews
        expect(subviews.count).to(equal(2))
        expect(String(describing: type(of: subviews[0]))).to(equal("RestaurantForm"))
        expect(String(describing: type(of: subviews[1]))).to(equal("UIButton"))
    }
    
    func test_formSubmission() {
        let restaurantForm = controller.view.subviews[0] as! RestaurantForm
        let nameInputField = restaurantForm.getNameInputField()
        nameInputField.text = "new value"
        
        let saveButton = controller.navigationItem.rightBarButtonItem
        UIApplication.shared.sendAction(saveButton!.action!, to: saveButton!.target, from: self, for: nil)
        
        expect(self.repo.update_wasCalledWith.0).to(equal(1))
        expect(self.repo.update_wasCalledWith.1).to(equal(NewRestaurant(name: "new value")))
        expect(self.router.dismissModal_wasCalled).toEventually(beTrue())
    }
    
    func test_delete() {
        UIApplication.shared.keyWindow?.rootViewController = controller
        
        let deleteButton = controller.view.subviews[1] as! UIButton
        deleteButton.sendActions(for: UIControlEvents.touchUpInside)
        
        let alertController = controller.presentedViewController as! UIAlertController
        
        let firstAction = alertController.actions[0]
        expect(firstAction.title).to(equal("Delete Restaurant"))
        expect(firstAction.style).to(equal(UIAlertActionStyle.destructive))

        let secondAction = alertController.actions[1]
        expect(secondAction.title).to(equal("Cancel"))
        expect(secondAction.style).to(equal(UIAlertActionStyle.cancel))
    }
}
