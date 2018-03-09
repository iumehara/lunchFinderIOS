import Foundation
import BrightFutures

protocol CategoryRepo {
    func getAll() -> Future<[BasicCategory], NSError>
    func get(id: Int) -> Future<Category, NSError>
    func create(newCategory: NewCategory) -> Future<Int, NSError>
    func removeRestaurant(id: Int, restaurantId: Int) -> Future<Void, NSError>
    func delete(id: Int) -> Future<Void, NSError>
}
