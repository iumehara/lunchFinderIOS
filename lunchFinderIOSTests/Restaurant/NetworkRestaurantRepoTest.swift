import XCTest
import Nimble
@testable import lunchFinderIOS

extension Int: Codable {}

class NetworkRestaurantRepoTest: XCTestCase {
    var repo: NetworkRestaurantRepo!
    var mockSession: MockSession!
    
    override func setUp() {
        super.setUp()

        self.continueAfterFailure = false
        let urlSessionProvider = MockURLSessionProvider()
        mockSession = urlSessionProvider.urlSession as! MockSession
        repo = NetworkRestaurantRepo(urlSessionProvider: urlSessionProvider)
    }

    func test_get_request() {
        repo.get(id: 1)

        expect(self.mockSession.url!.description).to(equal("http://testURL/restaurants/1"))
    }
    
    func test_get_responseHandling() {
        let future = repo.get(id: 1)
        let restaurantJSON: [String: Any] = [
            "id": 1,
            "name": "Restaurant A",
            "nameJp": "レストラン A",
            "website": "www.example.com",
            "categories": [["id": 1, "name": "Category A"]],
            "geolocation": ["lat": 1.0, "long": 1.0]
        ]

        let restaurantData = try! JSONSerialization.data(withJSONObject: restaurantJSON)
        mockSession.completionHandler!(restaurantData, nil, nil)

        let expectedRestaurant = Restaurant(
            id: 1,
            name: "Restaurant A",
            nameJp: "レストラン A",
            website: "www.example.com",
            categories: [BasicCategory(id: 1, name: "Category A")],
            geolocation: Geolocation(lat: 1.0, long: 1.0)
        )
        expect(future.result!.value!).to(equal(expectedRestaurant))
        expect(self.mockSession.urlSessionDataTaskSpy.resumeWasCalled).to(beTrue())
    }

    func test_create_request() {
        let newRestaurant = NewRestaurant(
                name: "Restaurant A",
                nameJp: "レストラン A",
                website: "www.example.com",
                categoryIds: [1],
                geolocation: Geolocation(lat: 1.0, long: 1.0)
        )
        repo.create(newRestaurant: newRestaurant)

        expect(self.mockSession.url!.description).to(equal("http://testURL/restaurants/"))

        let requestBody = try! JSONEncoder().encode(newRestaurant)
        expect(self.mockSession.body).to(equal(requestBody))
    }

    func test_create_responseHandling() {
        let newRestaurant = NewRestaurant(name: "Restaurant A")
        let future = repo.create(newRestaurant: newRestaurant)

        let responseId: [String: Int] = ["id": 1]
        let restaurantIdData = try! JSONEncoder().encode(responseId)

        mockSession.completionHandler!(restaurantIdData, nil, nil)

        expect(future.result!.value!).to(equal(1))
        expect(self.mockSession.urlSessionDataTaskSpy.resumeWasCalled).to(beTrue())
    }

    func test_update_request() {
        let newRestaurant = NewRestaurant(
                name: "Restaurant A",
                nameJp: "レストラン A",
                website: "www.example.com",
                categoryIds: [1],
                geolocation: Geolocation(lat: 1.0, long: 1.0)
        )
        repo.update(id: 1, newRestaurant: newRestaurant)

        expect(self.mockSession.url!.description).to(equal("http://testURL/restaurants/1"))
        let requestBody = try! JSONEncoder().encode(newRestaurant)
        expect(self.mockSession.body).to(equal(requestBody))
    }

    func test_update_responseHandling() {
        let newRestaurant = NewRestaurant(
                name: "Restaurant A",
                nameJp: "レストラン A",
                website: "www.example.com",
                categoryIds: [1],
                geolocation: Geolocation(lat: 1.0, long: 1.0)
        )
        let future = repo.update(id: 1, newRestaurant: newRestaurant)

        let httpResponse = HTTPURLResponse(url: URL(string: "")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        mockSession.completionHandler!(nil, httpResponse, nil)

        expect(future.result!.value).to(beNil())
        expect(self.mockSession.urlSessionDataTaskSpy.resumeWasCalled).to(beTrue())
    }
}
