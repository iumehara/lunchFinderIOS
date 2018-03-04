import Foundation
import BrightFutures

protocol RestaurantRepo {
    func get(id: Int) -> Future<Restaurant, NSError>
    func create(newRestaurant: NewRestaurant) -> Future<Int, NSError>
    func update(id: Int, newRestaurant: NewRestaurant) -> Future<Void, NSError>
    func delete(id: Int) -> Future<Void, NSError>
}
