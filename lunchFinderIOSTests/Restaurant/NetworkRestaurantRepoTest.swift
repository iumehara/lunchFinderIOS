import XCTest
@testable import lunchFinderIOS

class NetworkRestaurantRepoTest: XCTestCase {
    var repo: NetworkRestaurantRepo!
    var mockSession: MockSession!
    
    override func setUp() {
        super.setUp()

        self.continueAfterFailure = false
        repo = NetworkRestaurantRepo()
        mockSession = MockSession()
        repo.session = mockSession
    }
    
    func test_get_successfullyConvertsRequiredFields() {
        let restaurantJSON: [String: Any] = ["id": 1, "name": "Restaurant A"]
        let restaurantData = try! JSONSerialization.data(withJSONObject: restaurantJSON)
        
        let future = repo.get(id: 1)
        
        mockSession.completionHandler!(restaurantData, nil, nil)
        
        future.onSuccess { (response) -> Void in
            XCTAssertEqual(self.mockSession.url?.description, "http://localhost:8080/restaurants/1")
            XCTAssertEqual(response, Restaurant(id: 1, name: "Restaurant A"))
            XCTAssertTrue(self.mockSession.urlSessionDataTaskSpy.resumeWasCalled)
        }
        future.onFailure { _ in XCTFail()}
        
        XCTAssertTrue(future.isCompleted)
    }

    func test_get_successfullyConvertsAllFields() {
        let restaurantJSON: [String: Any] = [
            "id": 1,
            "name": "Restaurant A",
            "nameJp": "レストラン A",
            "website": "www.example.com",
            "categories": [["id": 1, "name": "Category A"]],
            "geolocation": ["lat": 1.0, "long": 1.0]
        ]
        let restaurantData = try! JSONSerialization.data(withJSONObject: restaurantJSON)
        
        let future = repo.get(id: 1)
        
        mockSession.completionHandler!(restaurantData, nil, nil)

        let expectedRestaurant = Restaurant(
            id: 1,
            name: "Restaurant A",
            nameJp: "レストラン A",
            website: "www.example.com",
            categories: [Category(id: 1, name: "Category A")],
            geolocation: Geolocation(lat: 1.0, long: 1.0)
        )
        future.onSuccess { (response) -> Void in XCTAssertEqual(response, expectedRestaurant)}
        future.onFailure { _ in XCTFail()}
        
        XCTAssertTrue(future.isCompleted)
    }
}
