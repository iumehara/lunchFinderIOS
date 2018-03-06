import XCTest
import Nimble
@testable import lunchFinderIOS

class NewCategoryViewControllerTest: XCTestCase {
    var controller: NewCategoryViewController!
    var repo: SuccessStubCategoryRepo!
    var router: SpyRouter!
    
    override func setUp() {
        self.repo = SuccessStubCategoryRepo()
        self.router = SpyRouter()
        self.controller = NewCategoryViewController(
            router: self.router,
            repo: self.repo
        )

        controller.viewDidLoad()
    }

    func test_navigationBar() {
        expect(self.controller.title).to(equal("New Category"))
        expect(self.controller.navigationItem.rightBarButtonItem).toNot(beNil())
        expect(self.controller.navigationItem.leftBarButtonItem).toNot(beNil())
    }
    
    func test_subviews() {
        let subviews = controller.view.subviews
        expect(subviews.count).to(equal(2))
        expect(String(describing: type(of: subviews[0]))).to(equal("UILabel"))
        expect(String(describing: type(of: subviews[1]))).to(equal("UITextField"))
    }
    
    func test_formSubmission() {
        let nameInput = controller.view.subviews[1] as! UITextField
        nameInput.text = "Category A"

        let saveButton = controller.navigationItem.rightBarButtonItem
        UIApplication.shared.sendAction(saveButton!.action!, to: saveButton!.target, from: self, for: nil)
        
        expect(self.repo.create_wasCalledWith).to(equal(NewCategory(name: "Category A")))
        expect(self.router.showCategoryDetailScreen_wasCalledWith).toEventually(equal(1))
    }
}
