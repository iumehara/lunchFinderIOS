import Foundation
import BrightFutures
import Result

@testable import lunchFinderIOS

class SuccessStubRestaurantRepo: RestaurantRepo {
    let stubRestaurant = Restaurant(
        id: 1,
        name: "Restaurant A",
        nameJp: "レストランA",
        website: "www.example.com",
        categories: [
            Category(id: 1, name: "Category A"),
            Category(id: 2, name: "Category B")
        ],
        geolocation: Geolocation(lat: 1.0, long: 1.0)
    )

    var get_responseFuture = Future<Restaurant, NSError>()
    func get(id: Int) -> Future<Restaurant, NSError> {
        let promise = Promise<Restaurant, NSError>()
        promise.success(stubRestaurant)
        
        get_responseFuture = promise.future
        return get_responseFuture
    }
}
