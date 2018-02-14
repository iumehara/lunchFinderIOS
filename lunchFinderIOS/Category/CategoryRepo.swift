import Foundation
import BrightFutures

protocol CategoryRepo {
    func getAll() -> Future<[Category], NSError>
}
