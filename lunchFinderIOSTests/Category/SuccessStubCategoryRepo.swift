import Result
import BrightFutures
import Foundation

@testable import lunchFinderIOS

class SuccessStubCategoryRepo: CategoryRepo {
    var get_responseFuture = Future<lunchFinderIOS.Category, NSError>()
    func get(id: Int) -> Future<lunchFinderIOS.Category, NSError> {
        let promise = Promise<lunchFinderIOS.Category, NSError>()
        promise.success(
            Category(
                id: 1,
                name: "Category A",
                restaurants: [
                    Restaurant(id: 1, name: "Restaurant A"),
                    Restaurant(id: 2, name: "Restaurant B")
                ]
            )
        )
        get_responseFuture = promise.future
        return get_responseFuture
    }
    
    var getAll_responseFuture = Future<[lunchFinderIOS.Category], NSError>()
    func getAll() -> Future<[lunchFinderIOS.Category], NSError> {
        let promise = Promise<[lunchFinderIOS.Category], NSError>()
        promise.success([
            Category(id: 1, name: "Category A"),
            Category(id: 2, name: "Category B")
        ])
        
        getAll_responseFuture = promise.future
        return getAll_responseFuture
    }
}
