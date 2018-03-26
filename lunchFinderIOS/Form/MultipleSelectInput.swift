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
    
    func setupSubviews() {
        selectLabel.backgroundColor = UIColor.white
        addSubview(selectLabel)
        
        selectInputTable.dataSource = self
        selectInputTable.delegate = self
        selectInputTable.register(UITableViewCell.self,
                                  forCellReuseIdentifier: MultipleSelectInput.cellIdentifier)
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
    
    func ids() -> [Int] { return [] }
    
    func names() -> [String] { return [] }
    
    func setOptions(selectOptions: [SelectOption]) {
        self.options = selectOptions
    }

    func setDefaultValues(options: [SelectOption]) {
        self.selectedOptions = options
        self.selectInputTable.reloadData()
    }
    
    func addDefaultValue(option: SelectOption) {
        self.selectedOptions.append(option)
    }
}

extension MultipleSelectInput: UITableViewDelegate {
    static let cellIdentifier: String = String(describing: UITableViewCell.self)
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("--didSelectRowAt: ", indexPath)
    }
    
    func tableView(
        _ tableView: UITableView,
        titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath
    ) -> String? {
        return "Remove"
    }
}

extension MultipleSelectInput: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedOptions.count + 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: MultipleSelectInput.cellIdentifier,
                                                 for: indexPath)
        if cell.detailTextLabel == nil {
            cell = UITableTextFieldCell(options: self.options)
        }
        
        return cell
    }
}

class UITableTextFieldCell: UITableViewCell {
    // MARK: - Properties
    var options: [SelectOption]
    
    var deleteButton: UIButton
    var input: UITextField
    
    // MARK: - Constructors
    init(options: [SelectOption]) {
        self.options = options
        self.deleteButton = UIButton()
        self.input = UITextField()
        
        super.init(style: .subtitle,
                   reuseIdentifier: MultipleSelectInput.cellIdentifier)
        
        setupSubviews()
        activateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    func setupSubviews() {
        deleteButton.backgroundColor = UIColor.white
        addSubview(deleteButton)
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        input.inputView = pickerView
        input.text = "Add Category"
        input.textColor = UIColor.gray
        input.backgroundColor = UIColor.white
        addSubview(input)
    }
    
    func activateConstraints() {
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        deleteButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        deleteButton.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true

        input.translatesAutoresizingMaskIntoConstraints = false
        input.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        input.heightAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        input.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        input.leadingAnchor.constraint(equalTo: deleteButton.trailingAnchor).isActive = true
        input.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    func text() -> String? {
        return input.text
    }
    
    func updateSelectedOptions(option: SelectOption) {
        guard let selectInputTable = self.superview as? UITableView else { return }
        guard let multipleSelectInput = selectInputTable.superview as? MultipleSelectInput else { return }
        
        multipleSelectInput.addDefaultValue(option: option)
        selectInputTable.reloadData()
    }
    
    @objc func deleteOption(sender: UIButton) {
        print("---delete option tapped", sender.tag)
    }
}

extension UITableTextFieldCell: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
}

extension UITableTextFieldCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int
        ) -> String? {
        return options[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var newCategory = false
        if input.text == "Add Category" {
            newCategory = true
        }
        input.text = options[row].name
        deleteButton.tag = row
        
        if newCategory {
            input.textColor = UIColor.black
            input.layer.borderColor = UIColor.black.cgColor
            input.layer.borderWidth = 1.0

            deleteButton.layer.borderColor = UIColor.black.cgColor
            deleteButton.layer.borderWidth = 1.0
            deleteButton.setTitle("-", for: .normal)
            deleteButton.setTitleColor(UIColor.red, for: .normal)
            deleteButton.addTarget(self, action: #selector(deleteOption), for: .touchUpInside)
            self.updateSelectedOptions(option: options[row])
        }
    }
}
