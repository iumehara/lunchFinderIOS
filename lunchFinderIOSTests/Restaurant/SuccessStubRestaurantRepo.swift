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

    func getAll() -> Future<[BasicRestaurant], NSError> {
        let promise = Promise<[BasicRestaurant], NSError>()
        promise.success([BasicRestaurant(restaurant: stubRestaurant)])

        return promise.future
    }

    func get(id: Int) -> Future<Restaurant, NSError> {
        let promise = Promise<Restaurant, NSError>()
        promise.success(stubRestaurant)
        
        return promise.future
    }

    var create_wasCalledWith: NewRestaurant?
    func create(newRestaurant: NewRestaurant) -> Future<Int, NSError> {
        create_wasCalledWith = newRestaurant
        let promise = Promise<Int, NSError>()
        promise.success(1)
        return promise.future
    }

    var update_wasCalledWith: (Int?, NewRestaurant?)
    func update(id: Int, newRestaurant: NewRestaurant) -> Future<Void, NSError> {
        update_wasCalledWith = (id, newRestaurant)
        let promise = Promise<Void, NSError>()
        promise.success(())
        return promise.future
    }

    var removeCategory_wasCalledWith: (Int?, categoryId: Int?)
    func removeCategory(id: Int, categoryId: Int) -> Future<Void, NSError> {
        removeCategory_wasCalledWith = (id, categoryId)
        let promise = Promise<Void, NSError>()
        promise.success(())
        return promise.future
    }

    var delete_wasCalledWith: Int?
    func delete(id: Int) -> Future<Void, NSError> {
        delete_wasCalledWith = id
        let promise = Promise<Void, NSError>()
        promise.success(())
        return promise.future
    }
}
