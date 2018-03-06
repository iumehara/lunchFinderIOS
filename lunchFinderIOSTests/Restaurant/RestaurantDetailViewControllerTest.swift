import XCTest
import Nimble
import Result
@testable import lunchFinderIOS

class RestaurantDetailViewControllerTest: XCTestCase {
    var router: SpyRouter!
    var controller: RestaurantDetailViewController!
    var repo: SuccessStubRestaurantRepo!
    var mapService: SpyMapService!
    
    override func setUp() {
        self.router = SpyRouter()
        self.repo = SuccessStubRestaurantRepo()
        self.mapService = SpyMapService()
        self.controller = RestaurantDetailViewController(
            router: self.router,
            repo: self.repo,
            mapService: self.mapService,
            id: 1
        )
        
        controller.viewDidLoad()
    }

    func test_navigationBar() {
        expect(self.controller.title).toEventually(equal("Restaurant A"))
        expect(self.controller.navigationItem.rightBarButtonItem).toNot(beNil())
        expect(self.controller.navigationItem.leftBarButtonItem!.title).to(equal("Restaurants"))
    }
    
    func test_subviews() {
        let subviewTypes = controller.view.subviews.map { view in
            return String(describing: type(of: view))
        }

        expect(subviewTypes.count).to(equal(2))
        expect(subviewTypes).to(contain("UIView"))
        expect(subviewTypes).to(contain("UITableView"))
    }
    
    func test_map() {
        expect(self.mapService.createMap_wasCalled).to(beTrue())
        expect(self.mapService.setMarker_wasCalledWith).toEventually(equal(BasicRestaurant(restaurant: self.repo.stubRestaurant)))
    }
    
    func test_tableData() {
        let table = self.controller.view.subviews[1] as! UITableView
        expect(table.numberOfRows(inSection: 0)).toEventually(equal(2))
        
        let firstTableRow = table.cellForRow(at: IndexPath(row: 0, section: 0))!
        expect(firstTableRow.textLabel?.text).toEventually(equal("Category A"))
    }
    
    func test_editButtonAction() {
        let editButton = controller.navigationItem.rightBarButtonItem
        UIApplication.shared.sendAction(editButton!.action!, to: editButton!.target, from: self, for: nil)
        
        expect(self.router.showEditRestaurantScreen_wasCalledWith).toEventually(equal(1))
    }
}
