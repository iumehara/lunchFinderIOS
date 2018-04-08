import UIKit

class RestaurantTableViewProtocols: NSObject {
    // MARK: - Properties
    static let cellIdentifier: String = String(describing: UITableViewCell.self)
    
    private let router: Router
    private let searchController: UISearchController?
    
    var restaurants: [BasicRestaurant] = []

    // MARK: - Constructors
    init(router: Router, searchController: UISearchController? = nil) {
        self.router = router
        self.searchController = searchController
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    // MARK: - Public Methods
    func setRestaurants(restaurants: [BasicRestaurant]) {
        self.restaurants = restaurants
    }
}

// MARK: - Extension: UITableViewDataSource
extension RestaurantTableViewProtocols: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: RestaurantTableViewProtocols.cellIdentifier, for: indexPath)
        if (cell.detailTextLabel == nil) {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: RestaurantTableViewProtocols.cellIdentifier)
        }
        
        let restaurant = restaurants[indexPath.row]
        cell.textLabel?.text = restaurant.nameJp ?? restaurant.name
        cell.detailTextLabel?.text = restaurant.name
        return cell
    }
}

// MARK: - Extension: UITableViewDelegate
extension RestaurantTableViewProtocols: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRestaurant = restaurants[indexPath.row]
        router.showRestaurantDetailScreen(id: selectedRestaurant.id)
    }
}

// MARK: - Extension: UISearchResultsUpdating
extension RestaurantTableViewProtocols: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
    }
    
    // MARK: - Private instance methods
    func searchBarIsEmpty() -> Bool {
        return searchController!.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        restaurants = restaurants.filter({( restaurant: BasicRestaurant) -> Bool in
            return restaurant.name.lowercased().contains(searchText.lowercased())
        })
        
//        tableView.reloadData()
    }
}
