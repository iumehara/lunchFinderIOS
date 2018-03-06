import Result
import BrightFutures
import Foundation

@testable import lunchFinderIOS

class SuccessStubCategoryRepo: CategoryRepo {
    func getAll() -> Future<[lunchFinderIOS.BasicCategory], NSError> {
        let promise = Promise<[lunchFinderIOS.BasicCategory], NSError>()
        promise.success([
            lunchFinderIOS.BasicCategory(id: 1, name: "Category A"),
            lunchFinderIOS.BasicCategory(id: 2, name: "Category B")
        ])

        return promise.future
    }

    func get(id: Int) -> Future<lunchFinderIOS.Category, NSError> {
        let promise = Promise<lunchFinderIOS.Category, NSError>()
        promise.success(
            Category(
                id: 1,
                name: "Category A",
                restaurants: [
                    lunchFinderIOS.BasicRestaurant(id: 1, name: "Restaurant A"),
                    lunchFinderIOS.BasicRestaurant(id: 2, name: "Restaurant B")
                ]
            )
        )
        return promise.future
    }

    var create_wasCalledWith: NewCategory?
    func create(newCategory: NewCategory) -> Future<Int, NSError> {
        create_wasCalledWith = newCategory
        let promise = Promise<Int, NSError>()
        promise.success(1)
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
