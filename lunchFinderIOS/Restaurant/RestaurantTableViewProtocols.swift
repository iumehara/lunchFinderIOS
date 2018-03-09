import UIKit

class RestaurantTableViewProtocols: NSObject {
    static let cellIdentifier: String = String(describing: UITableViewCell.self)
    var restaurants: [BasicRestaurant] = []
    private let router: Router

    init(router: Router) {
        self.router = router
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    func setRestaurants(restaurants: [BasicRestaurant]) {
        self.restaurants = restaurants
    }
}

extension RestaurantTableViewProtocols: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantTableViewProtocols.cellIdentifier, for: indexPath)
        cell.textLabel?.text = restaurants[indexPath.row].name
        return cell
    }
}

extension RestaurantTableViewProtocols: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRestaurant = restaurants[indexPath.row]
        router.showRestaurantDetailScreen(id: selectedRestaurant.id)
    }
}
