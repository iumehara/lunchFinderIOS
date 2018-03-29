import UIKit

class MultipleSelectInput: UIView {
    // MARK: - Properties
    private var options: [SelectOption] = []
    private var selectedOptions: [SelectOption] = []

    private let selectLabel: UILabel
    private var selectInputTable: UITableView
    
    // MARK: - Constructors
    init(labelText: String) {
        self.selectLabel = UILabel()
        self.selectLabel.text = labelText
        self.selectInputTable = UITableView()
        
        super.init(frame: CGRect.zero)
        
        setupSubviews()
        activateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    // MARK: - Setup Methods
    func setupSubviews() {
        selectLabel.backgroundColor = UIColor.white
        addSubview(selectLabel)
        
        selectInputTable.dataSource = self
        selectInputTable.delegate = self
        selectInputTable.register(UITableViewCell.self,
                                  forCellReuseIdentifier: MultipleSelectInput.dataCellIdentifier)
        selectInputTable.register(UITableTextFieldCell.self,
                                  forCellReuseIdentifier: MultipleSelectInput.pickerCellIdentifier)
        selectInputTable.separatorStyle = UITableViewCellSeparatorStyle.none
        addSubview(selectInputTable)
    }
    
    func activateConstraints() {
        selectLabel.translatesAutoresizingMaskIntoConstraints = false
        selectLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        selectLabel.heightAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        selectLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        selectLabel.widthAnchor.constraint(equalToConstant: CGFloat(100)).isActive = true
        
        selectInputTable.translatesAutoresizingMaskIntoConstraints = false
        selectInputTable.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        selectInputTable.leadingAnchor.constraint(equalTo: selectLabel.trailingAnchor).isActive = true
        selectInputTable.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        self.bottomAnchor.constraint(equalTo: selectInputTable.bottomAnchor).isActive = true
    }
    
    // MARK: - Accessor Methods
    func ids() -> [Int] {
        return selectedOptions.map { $0.id }
    }
    
    func setOptions(selectOptions: [SelectOption]) {
        self.options = selectOptions
    }

    func setDefaultValues(options: [SelectOption]) {
        self.selectedOptions = options
        self.selectInputTable.reloadData()
    }
    
    func addSelectedOption(option: SelectOption) {
        self.selectedOptions.append(option)
        
        let updatedOptions = options.filter { $0 != option }
        setOptions(selectOptions: updatedOptions)
        
        self.selectInputTable.reloadData()
    }
}

// MARK: - UITableViewDelegate
extension MultipleSelectInput: UITableViewDelegate {
    static let dataCellIdentifier: String = String(describing: UITableViewCell.self)
    static let pickerCellIdentifier: String = String(describing: UITableTextFieldCell.self)
    
    func tableView(_ tableView: UITableView,
                   titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath
        ) -> String? {
        guard indexPath.section == 0 else { return nil }

        return "Remove"
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath
        ) {
        guard indexPath.section == 0 else { return }
        
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            selectedOptions.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource
extension MultipleSelectInput: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return selectedOptions.count
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        if section == 1 {
            return UITableTextFieldCell(options: options)
        } else {
            var cell = tableView.dequeueReusableCell(withIdentifier: MultipleSelectInput.dataCellIdentifier,
                                                     for: indexPath)
            if (cell.detailTextLabel == nil) {
                cell = UITableViewCell(style: .subtitle,
                                       reuseIdentifier: MultipleSelectInput.dataCellIdentifier)
            }
            let title = selectedOptions[indexPath.row].name
            cell.textLabel?.text = title
            return cell
        }
    }
}
