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
            BasicCategory(id: 1, name: "Category A"),
            BasicCategory(id: 2, name: "Category B")
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

    var create_responseFuture = Future<Int, NSError>()
    func create(newRestaurant: NewRestaurant) -> Future<Int, NSError> {
        let promise = Promise<Int, NSError>()
        create_responseFuture = promise.future
        return create_responseFuture
    }

    func update(id: Int, newRestaurant: NewRestaurant) -> Future<Void, NSError> {
        fatalError("update(id:newRestaurant:) has not been implemented")
    }
}
