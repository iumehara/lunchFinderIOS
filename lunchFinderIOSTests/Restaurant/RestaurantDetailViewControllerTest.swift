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
    }
    
    func test_subviews() {
        let subviewTypes = controller.view.subviews.map { view in
            return String(describing: type(of: view))
        }
 
        expect(subviewTypes.count).to(equal(3))
        expect(subviewTypes).to(contain("RestaurantCard"))
        expect(subviewTypes).to(contain("UIView"))
        expect(subviewTypes).to(contain("UITableView"))
    }
    
    func test_map() {
        expect(self.mapService.createMap_wasCalled).to(beTrue())
        expect(self.mapService.setMarker_wasCalledWith).toEventually(equal(BasicRestaurant(restaurant: self.repo.stubRestaurant)))
    }
    
    func test_tableData() {
        let table = self.controller.view.subviews[2] as! UITableView
        
        expect(table.numberOfSections).toEventually(equal(1))
        expect(table.numberOfRows(inSection: 0)).toEventually(equal(2))
    }
    
    func test_editButtonAction() {
        let editButton = controller.navigationItem.rightBarButtonItem
        UIApplication.shared.sendAction(editButton!.action!, to: editButton!.target, from: self, for: nil)
        
        expect(self.router.showEditRestaurantModal_wasCalledWith).toEventually(equal(1))
    }
}
