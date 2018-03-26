import UIKit

class UITableTextFieldCell: UITableViewCell {
    // MARK: - Properties
    var options: [SelectOption]
    
    var input: UITextField
    
    // MARK: - Constructors
    init(options: [SelectOption]) {
        self.options = options
        self.input = UITextField()
        
        super.init(style: .subtitle, reuseIdentifier: "UITableTextFieldCell")
        
        setupSubviews()
        activateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    // MARK: - Setup Methods
    func setupSubviews() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        input.inputView = pickerView
        input.text = "Click to Add"
        input.textColor = UIColor.gray
        input.backgroundColor = UIColor.white
        addSubview(input)
    }
    
    func activateConstraints() {
        input.translatesAutoresizingMaskIntoConstraints = false
        input.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        input.heightAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        input.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        input.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        input.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}

// MARK: - UIPickerViewDataSource
extension UITableTextFieldCell: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
}

// MARK: - UIPickerViewDelegate
extension UITableTextFieldCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int
        ) -> String? {
        return options[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.updateSelectedOptions(option: options[row])
    }
    
    func updateSelectedOptions(option: SelectOption) {
        guard let selectInputTable = self.superview as? UITableView else { return }
        guard let multipleSelectInput = selectInputTable.superview as? MultipleSelectInput else { return }
        
        multipleSelectInput.addSelectedOption(option: option)
    }
}
