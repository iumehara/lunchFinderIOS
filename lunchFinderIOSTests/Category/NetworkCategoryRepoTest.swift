import XCTest
@testable import lunchFinderIOS

class NetworkCategoryRepoTest: XCTestCase {
    var repo: NetworkCategoryRepo!
    var mockSession: MockSession!
    
    override func setUp() {
        super.setUp()

        self.continueAfterFailure = false
        repo = NetworkCategoryRepo()
        mockSession = MockSession()
        repo.session = mockSession
    }
    
    func test_get_success() {
        let categoryJSON: [String: Any] = ["id": 1, "name": "Category A"]
        let categoryData = try! JSONSerialization.data(withJSONObject: categoryJSON)
        
        let future = repo.get(id: 1)
        
        mockSession.completionHandler!(categoryData, nil, nil)

        future.onSuccess { (response) -> Void in
            XCTAssertEqual(self.mockSession.url?.description, "http://localhost:8080/categories/1")
            XCTAssertEqual(response, Category(id: 1, name: "Category A", restaurants: []))
            XCTAssertTrue(self.mockSession.urlSessionDataTaskSpy.resumeWasCalled)
        }
        future.onFailure { _ in XCTFail()}
        
        XCTAssertTrue(future.isCompleted)
    }
    
    func test_getAll_success() {
        let categoriesJSON: [[String: Any]] = [["id": 1, "name": "Category A"], ["id": 2, "name": "Category B"]]
        let categoriesData = try! JSONSerialization.data(withJSONObject: categoriesJSON)
        
        let future = repo.getAll()
        
        mockSession.completionHandler!(categoriesData, nil, nil)
        
        future.onSuccess { (response) -> Void in
            XCTAssertEqual(self.mockSession.url?.description, "http://localhost:8080/categories")
            let expectedCategories = [Category(id: 1, name: "Category A", restaurants: []), Category(id: 2, name: "Category B", restaurants: [])]
            XCTAssertEqual(response, expectedCategories)
            XCTAssertTrue(self.mockSession.urlSessionDataTaskSpy.resumeWasCalled)
        }
        future.onFailure { _ in XCTFail()}
        
        XCTAssertTrue(future.isCompleted)
    }
}
