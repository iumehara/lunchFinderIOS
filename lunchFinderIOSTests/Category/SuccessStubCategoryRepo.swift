import Result
import BrightFutures
import Foundation

@testable import lunchFinderIOS

class SuccessStubCategoryRepo: CategoryRepo {
    var responseFuture = Future<[lunchFinderIOS.Category], NSError>()
    
    func getAll() -> Future<[lunchFinderIOS.Category], NSError> {
        let promise = Promise<[lunchFinderIOS.Category], NSError>()
        promise.success([
            Category(id: 1, name: "Test Pizza"),
            Category(id: 2, name: "Test Sushi")
        ])
        
        responseFuture = promise.future
        return responseFuture
    }
}
