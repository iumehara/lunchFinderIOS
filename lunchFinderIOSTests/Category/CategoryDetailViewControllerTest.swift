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
        expect(self.controller.navigationItem.rightBarButtonItem).toNot(beNil())
    }

    func test_navigationBar_editClick() {
        let rightBarButtonItem = self.controller.navigationItem.rightBarButtonItem!
        UIApplication.shared.sendAction(
            rightBarButtonItem.action!,
            to: rightBarButtonItem.target,
            from: self,
            for: nil
        )

        expect(self.router.showEditCategoryModal_wasCalled).to(beTrue())
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
    
    func test_table_data() {
        let table = self.controller.view.subviews[1] as! UITableView
        expect(table.numberOfSections).toEventually(equal(1))
        expect(table.numberOfRows(inSection: 0)).toEventually(equal(2))
        let firstRow = table.dataSource!.tableView(table,
                                                   cellForRowAt: IndexPath(row: 0, section: 0))
        
        expect(firstRow.textLabel!.text!).toEventually(equal("Restaurant A"))
    }
    
    func test_table_RowClick() {
        let table = self.controller.view.subviews[1] as! UITableView
        expect(table.numberOfRows(inSection: 0)).toEventually(equal(2))
        table.delegate!.tableView!(table, didSelectRowAt: IndexPath(row: 0, section: 0))
        expect(self.router.showRestaurantDetailScreen_wasCalledWith).to(equal(1))
    }
}
