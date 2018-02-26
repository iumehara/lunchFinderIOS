import UIKit

class MultipleSelectInput: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    private var selectOptions: [SelectOption] = []
    private let selectLabel: UILabel
    private var selectInputs: [UITextField] = []

    init(labelText: String) {
        self.selectLabel = UILabel()
        self.selectLabel.text = labelText

        super.init(frame: CGRect.zero)
        
        setupSubviews()
        activateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    func setupSubviews() {
        self.backgroundColor = UIColor.white
        
        selectLabel.backgroundColor = UIColor.white
        addSubview(selectLabel)
    }
    
    func setOptions(selectOptions: [SelectOption]) {
        self.selectOptions = selectOptions

        let selectInput = UITextField()
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        selectInput.inputView = pickerView
        
        addSubview(selectInput)
        
        let margins = self.safeAreaLayoutGuide

        selectInput.backgroundColor = UIColor.white
        selectInput.layer.borderColor = UIColor.black.cgColor
        selectInput.layer.borderWidth = 1.0
        
        selectInput.translatesAutoresizingMaskIntoConstraints = false
        selectInput.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        selectInput.heightAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        selectInput.leadingAnchor.constraint(equalTo: selectLabel.trailingAnchor).isActive = true
        selectInput.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true

    }
    
    func activateConstraints() {
        let margins = self.safeAreaLayoutGuide
        
        selectLabel.translatesAutoresizingMaskIntoConstraints = false
        selectLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        selectLabel.heightAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        selectLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        selectLabel.widthAnchor.constraint(equalToConstant: CGFloat(100)).isActive = true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return selectOptions[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return selectOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("selected \(row)")
    }
}
