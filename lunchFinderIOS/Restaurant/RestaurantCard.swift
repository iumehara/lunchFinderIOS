import UIKit

class RestaurantCard: UIView {
    private var restaurant: Restaurant?
    private let nameLabel = UILabel()
    private let nameJpLabel = UILabel()
    private let websiteLabel = UITextView()
    
    init() {
        super.init(frame: CGRect.zero)

        setupSubviews()
        activateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    func set(restaurant: Restaurant) {
        nameLabel.text = restaurant.name
        nameJpLabel.text = restaurant.nameJp ?? restaurant.name
        if let website = restaurant.website {
            websiteLabel.text = website
        }
    }

    func setupSubviews() {
        self.backgroundColor = UIColor.white
        nameJpLabel.font = UIFont.systemFont(ofSize: 40.0, weight: UIFont.Weight.bold)
        nameLabel.font = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.bold)
        websiteLabel.font = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.light)
        websiteLabel.isEditable = false
        websiteLabel.isSelectable = true
        websiteLabel.dataDetectorTypes = .link
        
        addSubview(nameLabel)
        addSubview(nameJpLabel)
        addSubview(websiteLabel)
    }
    
    func activateConstraints() {
        nameJpLabel.translatesAutoresizingMaskIntoConstraints = false
        nameJpLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        nameJpLabel.heightAnchor.constraint(equalToConstant: CGFloat(40)).isActive = true
        nameJpLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        nameJpLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: nameJpLabel.bottomAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: CGFloat(30)).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

        websiteLabel.translatesAutoresizingMaskIntoConstraints = false
        websiteLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        websiteLabel.heightAnchor.constraint(equalToConstant: CGFloat(30)).isActive = true
        websiteLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        websiteLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        self.bottomAnchor.constraint(equalTo: websiteLabel.bottomAnchor).isActive = true
    }
}

