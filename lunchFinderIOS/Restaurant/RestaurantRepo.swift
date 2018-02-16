import Foundation
import BrightFutures

protocol RestaurantRepo {
    func get(id: Int) -> Future<Restaurant, NSError>
}
