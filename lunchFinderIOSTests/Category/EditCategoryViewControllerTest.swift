import XCTest
import Nimble
@testable import lunchFinderIOS

class EditCategoryViewControllerTest: XCTestCase {
    var controller: EditCategoryViewController!
    var router: SpyRouter!
    var repo: SuccessStubCategoryRepo!
    
    override func setUp() {
        self.router = SpyRouter()
        self.repo = SuccessStubCategoryRepo()
        self.controller = EditCategoryViewController(
            router: router,
            repo: repo,
            id: 1
        )
        
        controller.viewDidLoad()
    }
    
    func test_navigationBar() {
        expect(self.controller.title).to(equal("Edit Category"))
        
        let leftBarButton = controller.navigationItem.leftBarButtonItem
        UIApplication.shared.sendAction(leftBarButton!.action!,
                                        to: leftBarButton!.target,
                                        from: self,
                                        for: nil)
        expect(self.router.dismissModal_wasCalled).to(beTrue())
        
        let rightBarButton = controller.navigationItem.rightBarButtonItem
        expect(rightBarButton).toNot(beNil())
    }
    
    func test_subviews() {
        let subviews = controller.view.subviews
        expect(subviews.count).to(equal(2))
        expect(String(describing: type(of: subviews[0]))).to(equal("CategoryForm"))
        expect(String(describing: type(of: subviews[1]))).to(equal("UIButton"))
    }
    
    func test_formSubmission() {
        let form = controller.view.subviews[0] as! CategoryForm
        let nameInputField = form.getNameInputField()
        nameInputField.text = "new value"
        
        let saveButton = controller.navigationItem.rightBarButtonItem
        UIApplication.shared.sendAction(saveButton!.action!,
                                        to: saveButton!.target,
                                        from: self,
                                        for: nil)
        
        expect(self.repo.update_wasCalledWith.0).to(equal(1))
        expect(self.repo.update_wasCalledWith.1).to(equal(NewCategory(name: "new value")))
        expect(self.router.dismissModal_wasCalled).toEventually(beTrue())
    }
    
    func test_delete() {
        UIApplication.shared.keyWindow?.rootViewController = controller

        let deleteButton = controller.view.subviews[1] as! UIButton
        deleteButton.sendActions(for: UIControlEvents.touchUpInside)
        
        let alertController = controller.presentedViewController as! UIAlertController
        
        let firstAction = alertController.actions[0]
        expect(firstAction.title).to(equal("Delete Category"))
        expect(firstAction.style).to(equal(UIAlertActionStyle.destructive))
        
        let secondAction = alertController.actions[1]
        expect(secondAction.title).to(equal("Cancel"))
        expect(secondAction.style).to(equal(UIAlertActionStyle.cancel))

    }
}

extension CategoryForm {
    func getNameInputField() -> UITextField {
        let nameInputRow = self.subviews[0] as! TextInputRow
        return nameInputRow.subviews[1] as! UITextField
    }
}
