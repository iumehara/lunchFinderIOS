import XCTest
import Nimble
import BrightFutures
@testable import lunchFinderIOS

class NetworkCategoryRepoTest: XCTestCase {
    var repo: NetworkCategoryRepo!
    var urlSessionProvider: MockURLSessionProvider!
    var mockSession: MockSession!
    
    override func setUp() {
        super.setUp()

        self.continueAfterFailure = false
        self.urlSessionProvider = MockURLSessionProvider()
        self.mockSession = urlSessionProvider.urlSession as! MockSession
        repo = NetworkCategoryRepo(urlSessionProvider: urlSessionProvider)
    }

    func test_getAll_request() {
        repo.getAll()

        expect(self.mockSession.url!.description).to(equal("http://testURL/categories/"))
        expect(self.urlSessionProvider.getRequest_wasCalled).to(beTrue())
    }

    func test_getAll_responseHandling() {
        let future = repo.getAll()

        let responseCategoriesJSON: [[String: Any]] = [["id": 1, "name": "Category A"], ["id": 2, "name": "Category B"]]
        let responseCategoriesData = try! JSONSerialization.data(withJSONObject: responseCategoriesJSON)
        mockSession.completionHandler!(responseCategoriesData, nil, nil)

        let expectedCategories = [BasicCategory(id: 1, name: "Category A"), BasicCategory(id: 2, name: "Category B")]
        expect(future.result!.value!).to(equal(expectedCategories))


        expect(future.isSuccess).to(beTrue())
        expect(future.isCompleted).to(beTrue())
        expect(self.mockSession.urlSessionDataTaskSpy.resumeWasCalled).to(beTrue())
    }

    func test_get_request() {
        repo.get(id: 1)

        expect(self.mockSession.url?.description).to(equal("http://testURL/categories/1"))
        expect(self.urlSessionProvider.getRequest_wasCalled).to(beTrue())
    }

    func test_get_responseHandling() {
        let future = repo.get(id: 1)
        
        let responseCategoryJSON: [String: Any] = ["id": 1, "name": "Category A", "restaurants": []]
        let responseCategoryData = try! JSONSerialization.data(withJSONObject: responseCategoryJSON)
        mockSession.completionHandler!(responseCategoryData, nil, nil)
        
        let resultValue = future.result!.value!

        expect(resultValue).to(equal(Category(id: 1, name: "Category A", restaurants: [])))
        expect(future.isSuccess).to(beTrue())
        expect(future.isCompleted).to(beTrue())
        expect(self.mockSession.urlSessionDataTaskSpy.resumeWasCalled).to(beTrue())
    }

    func test_create_request() {
        let newCategory = NewCategory(name: "New Category A")
        repo.create(newCategory: newCategory)

        expect(self.mockSession.url?.description).to(equal("http://testURL/categories/"))
        expect(self.urlSessionProvider.postRequest_wasCalled).to(beTrue())

        let requestBody = try! JSONEncoder().encode(newCategory)
        expect(self.mockSession.body).to(equal(requestBody))
    }

    func test_create_responseHandling() {
        let newCategory = NewCategory(name: "Category A")
        let future = repo.create(newCategory: newCategory)

        let responseId: [String: Int] = ["id": 1]
        let responseCategoryData = try! JSONEncoder().encode(responseId)


        mockSession.completionHandler!(responseCategoryData, nil, nil)

        let resultValue = future.result!.value!
        expect(resultValue).to(equal(1))
        expect(future.isSuccess).to(beTrue())
        expect(future.isCompleted).to(beTrue())
        expect(self.mockSession.urlSessionDataTaskSpy.resumeWasCalled).to(beTrue())
    }

    func test_delete_request() {
        repo.delete(id: 1)

        expect(self.mockSession.url?.description).to(equal("http://testURL/categories/1/"))
        expect(self.urlSessionProvider.deleteRequest_wasCalled).to(beTrue())
    }

    func test_delete_responseHandling() {
        let future = repo.delete(id: 1)
        let httpResponse = HTTPURLResponse(url: URL(string: "http://www.example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)

        mockSession.completionHandler!(nil, httpResponse, nil)

        expect(future.result!.value).to(beVoid())
        expect(self.mockSession.urlSessionDataTaskSpy.resumeWasCalled).to(beTrue())
    }
}
