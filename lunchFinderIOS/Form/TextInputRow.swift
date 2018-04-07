import UIKit

class TextInputRow: UIView {
    private let label: UILabel = UILabel()
    let textField: UITextField = UITextField()
    private let labelWidth: CGFloat
    private let defaultValue: String?
    
    convenience init(labelText: String) {
        self.init(labelText: labelText, labelWidth: CGFloat(100))
    }

    convenience init(labelText: String, labelWidth: CGFloat) {
        self.init(labelText: labelText, labelWidth: labelWidth, defaultValue: nil)
    }

    init(labelText: String, labelWidth: CGFloat, defaultValue: String?) {
        self.label.text = labelText
        self.labelWidth = labelWidth
        self.defaultValue = defaultValue
        
        super.init(frame: CGRect.zero)
    
        setupSubviews()
        activateConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    func setDefaultValue(defaultValue: String) {
        textField.text = defaultValue
    }
    
    func setupSubviews() {
        self.backgroundColor = UIColor.white
        
        label.backgroundColor = UIColor.white
        addSubview(label)

        textField.backgroundColor = UIColor.white
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1.0
        addSubview(textField)
    }
    
    func activateConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: labelWidth).isActive = true
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textField.heightAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        textField.leadingAnchor.constraint(equalTo: label.trailingAnchor).isActive = true
        textField.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    func text() -> String? {
        guard textField.text != "" else {
            return nil
        }
        return textField.text
    }
}
