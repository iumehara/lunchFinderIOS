import XCTest
import Result
@testable import lunchFinderIOS

class CategoryDetailViewControllerTest: XCTestCase {
    var controller: CategoryDetailViewController!
    var repo: SuccessStubCategoryRepo!
    var mapService: SpyMapService!
    
    override func setUp() {
        repo = SuccessStubCategoryRepo()
        mapService = SpyMapService()
        controller = CategoryDetailViewController(
            router: DummyRouter(),
            repo: repo,
            mapService: mapService,
            id: 1
        )

        controller.viewDidLoad()
    }
    
    func test_title() {
        repo.get_responseFuture
            .onSuccess(callback: { _ in
                let title = self.controller.title
                XCTAssertEqual(title, "Category A")
            })
        
        XCTAssertTrue(repo.get_responseFuture.isCompleted)
    }

    func test_subviews() {
        let subviews = controller.view.subviews
        XCTAssertEqual(subviews.count, 2)
        XCTAssertEqual(String(describing: type(of: subviews[0])), "Map")
        XCTAssertEqual(String(describing: type(of: subviews[1])), "UITableView")
    }
    
    func test_map() {
        XCTAssertTrue(mapService.createMap_wasCalled)
        repo.get_responseFuture
            .onSuccess(callback: { category in
                XCTAssertEqual(self.mapService.setMarkers_wasCalledWith, category.restaurants)
            })
        XCTAssertTrue(repo.get_responseFuture.isCompleted)
    }
    
    func test_tableData() {
        repo.get_responseFuture
            .onSuccess(callback: { _ in
                let table = self.controller.view.subviews[1] as! UITableView
                XCTAssertEqual(table.numberOfRows(inSection: 0), 2)
                XCTAssertEqual(table.cellForRow(at: IndexPath(row: 0, section: 0))?.textLabel?.text, "Restaurant A")
            })
        XCTAssertTrue(repo.get_responseFuture.isCompleted)
    }
}
