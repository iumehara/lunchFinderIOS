import UIKit

class MultipleSelectInput: UIView {
    private var options: [SelectOption] = []
    private let selectLabel: UILabel
    private var selectInputCollection: UIView
    private var addButton: UIButton
    private var selectInputBottomAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>
    private var selectInputCollectionHeightConstraint: NSLayoutConstraint
    
    init(labelText: String) {
        self.selectLabel = UILabel()
        self.selectLabel.text = labelText
        self.selectInputCollection = UIView()
        self.addButton = UIButton(type: UIButtonType.contactAdd)
        self.selectInputBottomAnchor = NSLayoutAnchor()
        self.selectInputCollectionHeightConstraint = NSLayoutConstraint()

        super.init(frame: CGRect.zero)
        
        setupSubviews()
        activateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    func setupSubviews() {
        selectLabel.backgroundColor = UIColor.white
        addSubview(selectLabel)

        selectInputCollection.layer.borderColor = UIColor.black.cgColor
        selectInputCollection.layer.borderWidth = 1.0
        addSubview(selectInputCollection)
        
        addButton.addTarget(self, action: #selector(addTapped(sender:)), for: .touchUpInside)
        addSubview(addButton)
    }
    
    func setOptions(selectOptions: [SelectOption]) {
        self.options = selectOptions
    }
    
    func activateConstraints() {
        selectLabel.translatesAutoresizingMaskIntoConstraints = false
        selectLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        selectLabel.heightAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        selectLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        selectLabel.widthAnchor.constraint(equalToConstant: CGFloat(100)).isActive = true
    
        selectInputCollection.translatesAutoresizingMaskIntoConstraints = false
        selectInputCollection.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        selectInputCollection.leadingAnchor.constraint(equalTo: selectLabel.trailingAnchor).isActive = true
        selectInputCollection.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        selectInputCollectionHeightConstraint = selectInputCollection.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        selectInputCollectionHeightConstraint.isActive = true

        selectInputBottomAnchor = selectInputCollection.topAnchor
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.topAnchor.constraint(equalTo: selectInputCollection.bottomAnchor).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        addButton.leadingAnchor.constraint(equalTo: selectLabel.trailingAnchor).isActive = true
        addButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        self.bottomAnchor.constraint(equalTo: addButton.bottomAnchor).isActive = true
    }
    
    func ids() -> [Int] {
        var ids: [Int] = []
        
        for name in names() {
            let filteredIds = options.filter { option in option.name == name }
            if (filteredIds.count == 1) {
                ids.append(filteredIds[0].id)
            }
        }
        return ids
    }

    func names() -> [String] {
        var names: [String] = []
        for case let singleSelectInput as SingleSelectInput in selectInputCollection.subviews {
            if let name = singleSelectInput.text() {
                names.append(name)
            }
        }
        return names
    }
    
    func setDefaultValues(options: [SelectOption]) {
        for option in options {
            let filteredOptions = options.filter { option in !names().contains(option.name) }
            let selectInput = SingleSelectInput(options: filteredOptions)
            
            addToSubviewAndActivateContraints(selectInput: selectInput)
            let input = selectInput.subviews[0] as! UITextField
            input.text = option.name
        }
    }
    
    @objc
    func addTapped(sender: UIButton) {
        let filteredOptions = options.filter { option in !names().contains(option.name) }
        let selectInput = SingleSelectInput(options: filteredOptions)

        addToSubviewAndActivateContraints(selectInput: selectInput)
    }
    
    func addToSubviewAndActivateContraints(selectInput: SingleSelectInput) {
        selectInputCollection.addSubview(selectInput)
        
        selectInput.translatesAutoresizingMaskIntoConstraints = false
        selectInput.topAnchor.constraint(equalTo: selectInputBottomAnchor).isActive = true
        selectInput.leadingAnchor.constraint(equalTo: selectInputCollection.leadingAnchor).isActive = true
        selectInput.trailingAnchor.constraint(equalTo: selectInputCollection.trailingAnchor).isActive = true
        
        selectInputCollectionHeightConstraint.isActive = false
        
        let height = CGFloat(selectInputCollection.subviews.count * 50)
        selectInputCollectionHeightConstraint = selectInputCollection.heightAnchor.constraint(equalToConstant: height)
        selectInputCollectionHeightConstraint.isActive = true
        selectInputBottomAnchor = selectInput.bottomAnchor
    }
}
