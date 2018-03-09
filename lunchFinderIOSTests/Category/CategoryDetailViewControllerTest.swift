import XCTest
import Nimble
import Result
@testable import lunchFinderIOS

class CategoryDetailViewControllerTest: XCTestCase {
    var router: SpyRouter!
    var controller: CategoryDetailViewController!
    var repo: SuccessStubCategoryRepo!
    var mapService: SpyMapService!
    
    override func setUp() {
        router = SpyRouter()
        repo = SuccessStubCategoryRepo()
        mapService = SpyMapService()
        controller = CategoryDetailViewController(
            router: router,
            repo: repo,
            mapService: mapService,
            id: 1
        )

        controller.viewDidLoad()
    }
    
    func test_navigationBar() {
        expect(self.controller.title).toEventually(equal("Category A"))
    }

    func test_subviews() {
        let subviews = controller.view.subviews
        expect(subviews.count).to(equal(2))
        expect(String(describing: type(of: subviews[0]))).to(equal("UIView"))
        expect(String(describing: type(of: subviews[1]))).to(equal("UITableView"))
    }
    
    func test_map() {
        expect(self.mapService.createMap_wasCalled).to(beTrue())
        let stubRestaurants = [
            BasicRestaurant(id: 1, name: "Restaurant A"),
            BasicRestaurant(id: 2, name: "Restaurant B")
        ]
        expect(self.mapService.setMarkers_wasCalledWith).toEventually(equal(stubRestaurants))
    }
    
    func test_tableData() {
        let table = self.controller.view.subviews[1] as! UITableView
        expect(table.cellForRow(at: IndexPath(row: 0, section: 0))!.textLabel!.text!).toEventually(equal("Restaurant A"))
    }
    
    func test_tableRowClick() {
        let table = self.controller.view.subviews[1] as! UITableView
        expect(table.numberOfRows(inSection: 0)).toEventually(equal(2))
        table.delegate!.tableView!(table, didSelectRowAt: IndexPath(row: 0, section: 0))
        expect(self.router.showRestaurantDetailScreen_wasCalledWith).to(equal(1))
    }
}
