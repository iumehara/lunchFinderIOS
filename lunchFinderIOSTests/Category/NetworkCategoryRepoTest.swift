import XCTest
import BrightFutures
@testable import lunchFinderIOS

class NetworkCategoryRepoTest: XCTestCase {
    var repo: NetworkCategoryRepo!
    var mockSession: MockSession!
    
    override func setUp() {
        super.setUp()

        self.continueAfterFailure = false
        let urlSessionProvider = MockURLSessionProvider()
        self.mockSession = urlSessionProvider.urlSession as! MockSession
        repo = NetworkCategoryRepo(urlSessionProvider: urlSessionProvider)
    }
    
    func test_get_success() {
        let future = repo.get(id: 1)

        XCTAssertEqual(self.mockSession.url?.description, "http://testURL/categories/1")

        let responseCategoryJSON: [String: Any] = ["id": 1, "name": "Category A"]
        let responseCategoryData = try! JSONSerialization.data(withJSONObject: responseCategoryJSON)
        mockSession.completionHandler!(responseCategoryData, nil, nil)

        future.onSuccess { (response) -> Void in
            XCTAssertEqual(response, Category(id: 1, name: "Category A", restaurants: []))
            XCTAssertTrue(self.mockSession.urlSessionDataTaskSpy.resumeWasCalled)
        }
        future.onFailure { _ in XCTFail()}
        
        XCTAssertTrue(future.isCompleted)
    }
    
    func test_getAll_success() {
        let future = repo.getAll()

        XCTAssertEqual(self.mockSession.url?.description, "http://testURL/categories")

        let responseCategoriesJSON: [[String: Any]] = [["id": 1, "name": "Category A"], ["id": 2, "name": "Category B"]]
        let responseCategoriesData = try! JSONSerialization.data(withJSONObject: responseCategoriesJSON)
        mockSession.completionHandler!(responseCategoriesData, nil, nil)

        future.onSuccess { (response) -> Void in
            let expectedCategories = [Category(id: 1, name: "Category A", restaurants: []), Category(id: 2, name: "Category B", restaurants: [])]
            XCTAssertEqual(response, expectedCategories)
            XCTAssertTrue(self.mockSession.urlSessionDataTaskSpy.resumeWasCalled)
        }
        future.onFailure { _ in XCTFail()}
        
        XCTAssertTrue(future.isCompleted)
    }
    
    func test_create_request() {
        let newCategory = NewCategory(name: "New Category A")
        repo.create(newCategory: newCategory)
    
        XCTAssertEqual(self.mockSession.url?.description, "http://testURL/categories/")

        let requestBody = try! JSONSerialization.data(withJSONObject: newCategory.dictionary())
        XCTAssertEqual(self.mockSession.body, requestBody)
    }

    func test_create_responseHandling() {
        let future = repo.create(newCategory: NewCategory(name: "New Category A"))
        
        let responseIntJson = "25"
        let responseIntData = responseIntJson.data(using: .utf8)
        mockSession.completionHandler!(responseIntData, nil, nil)
        
        future.onSuccess { (response) -> Void in
            XCTAssertEqual(response, 25)
            XCTAssertTrue(self.mockSession.urlSessionDataTaskSpy.resumeWasCalled)
        }
        future.onFailure { _ in XCTFail()}
        
        XCTAssertTrue(future.isCompleted)
    }
}
