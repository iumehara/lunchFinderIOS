import UIKit

class SingleSelectInput: UIView {
    private var options: [SelectOption]
    private var input: UITextField
    
    init(options: [SelectOption]) {
        self.input = UITextField()
        self.options = options

        super.init(frame: CGRect.zero)

        setupSubviews()
        activateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }

    func setupSubviews() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        input.inputView = pickerView

        input.backgroundColor = UIColor.white
        input.layer.borderColor = UIColor.black.cgColor
        input.layer.borderWidth = 1.0
        
        addSubview(input)
    }
    
    func activateConstraints() {
        input.translatesAutoresizingMaskIntoConstraints = false
        input.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        input.heightAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        input.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        input.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        self.bottomAnchor.constraint(equalTo: input.bottomAnchor).isActive = true
    }
    
    func text() -> String? {
        return input.text
    }
}

extension SingleSelectInput: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
}

extension SingleSelectInput: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        input.text = options[row].name
    }
}
