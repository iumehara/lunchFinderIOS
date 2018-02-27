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

    func test_navbar() {
        let title = controller.navigationItem.rightBarButtonItem!.title
        XCTAssertEqual(title, "Edit")
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
        let subviewTypes = controller.view.subviews.map { view in
            return String(describing: type(of: view))
        }

        XCTAssertEqual(subviewTypes.count, 2)
        XCTAssertTrue(subviewTypes.contains("Map"))
        XCTAssertTrue(subviewTypes.contains("UITableView"))
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
