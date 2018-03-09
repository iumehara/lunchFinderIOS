protocol Router {
    func showCategoryListScreen()
    func showCategoryDetailScreen(id: Int)
    func showNewCategoryModal()

    func showRestaurantListScreen()
    func showRestaurantDetailScreen(id: Int)
    func showNewRestaurantModal()
    func showEditRestaurantModal(id: Int)
    
    func dismissModal()
}
