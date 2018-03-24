import XCTest
import Nimble
import BrightFutures
@testable import lunchFinderIOS

class NetworkCategoryRepoTest: XCTestCase {
    var repo: NetworkCategoryRepo!
    var urlSessionProvider: MockURLSessionProvider!
    var mockSession: MockSession!
    let successfulHttpResponse = HTTPURLResponse(url: URL(string: "http://www.example.com")!,
                                                 statusCode: 200,
                                                 httpVersion: nil,
                                                 headerFields: nil)

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

        let responseJSON: [[String: Any]] = [["id": 1, "name": "Category A", "restaurantCount": 0],
                                             ["id": 2, "name": "Category B", "restaurantCount": 0]]
        let responseCategoriesData = try! JSONSerialization.data(withJSONObject: responseJSON)
        mockSession.completionHandler!(responseCategoriesData, successfulHttpResponse, nil)

        let expectedCategories = [BasicCategory(id: 1, name: "Category A", restaurantCount: 0),
                                  BasicCategory(id: 2, name: "Category B", restaurantCount: 0)]
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
        
        let responseJSON: [String: Any] = ["id": 1, "name": "Category A", "restaurants": []]
        let responseCategoryData = try! JSONSerialization.data(withJSONObject: responseJSON)
        mockSession.completionHandler!(responseCategoryData, successfulHttpResponse, nil)
        
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


        mockSession.completionHandler!(responseCategoryData, successfulHttpResponse, nil)

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

        mockSession.completionHandler!(Data(), successfulHttpResponse, nil)

        expect(future.result!.value).to(beVoid())
        expect(self.mockSession.urlSessionDataTaskSpy.resumeWasCalled).to(beTrue())
    }
}
