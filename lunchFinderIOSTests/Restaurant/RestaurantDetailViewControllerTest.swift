import XCTest
import Result
@testable import lunchFinderIOS

class RestaurantDetailViewControllerTest: XCTestCase {
    var controller: RestaurantDetailViewController!
    var repo: SuccessStubRestaurantRepo!
    var spyMapService: SpyMapService!
    
    override func setUp() {
        repo = SuccessStubRestaurantRepo()
        spyMapService = SpyMapService()
        controller = RestaurantDetailViewController(
            router: DummyRouter(),
            repo: repo,
            mapService: spyMapService,
            id: 1
        )
        
        controller.viewDidLoad()
    }
    
    func test_title() {
        repo.get_responseFuture
            .onSuccess(callback: { _ in
                let title = self.controller.title
                XCTAssertEqual(title, "Restaurant A")
            })
        XCTAssertTrue(repo.get_responseFuture.isCompleted)
    }
    
    func test_subviews() {
        let subviews = self.controller.view.subviews
        XCTAssertEqual(subviews.count, 2)
        XCTAssertEqual(String(describing: type(of: subviews[0])), "Map")
        XCTAssertEqual(String(describing: type(of: subviews[1])), "UITableView")
    }
    
    func test_map() {
        XCTAssertTrue(spyMapService.createMap_wasCalled)
        repo.get_responseFuture
            .onSuccess(callback: { restaurant in
                XCTAssertEqual(self.spyMapService.setMarker_wasCalledWith, restaurant)
            })
        XCTAssertTrue(repo.get_responseFuture.isCompleted)
    }
    
    func test_tableData() {
        repo.get_responseFuture
            .onSuccess(callback: { _ in
                let table = self.controller.view.subviews[1] as! UITableView
                XCTAssertEqual(table.numberOfRows(inSection: 0), 2)
                XCTAssertEqual(table.cellForRow(at: IndexPath(row: 0, section: 0))?.textLabel?.text, "Category A")
            })
        XCTAssertTrue(repo.get_responseFuture.isCompleted)
    }
}
