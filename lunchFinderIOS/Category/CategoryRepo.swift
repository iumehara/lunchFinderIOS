import Foundation
import BrightFutures

protocol CategoryRepo {
    func getAll() -> Future<[Category], NSError>
    func get(id: Int) -> Future<Category, NSError>
}
