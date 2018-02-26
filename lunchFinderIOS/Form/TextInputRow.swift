import UIKit

class TextInputRow: UIView {
    private let textLabel: UILabel = UILabel()
    private let textInput: UITextField = UITextField()
    private let labelWidth: CGFloat

    convenience init(labelText: String) {
        self.init(labelText: labelText, labelWidth: CGFloat(100))
    }

    init(labelText: String, labelWidth: CGFloat) {
        self.textLabel.text = labelText
        self.labelWidth = labelWidth

        super.init(frame: CGRect.zero)

        setupSubviews()
        activateConstraints()
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    func setupSubviews() {
        self.backgroundColor = UIColor.white
        
        textLabel.backgroundColor = UIColor.white
        addSubview(textLabel)
        
        textInput.backgroundColor = UIColor.white
        textInput.layer.borderColor = UIColor.black.cgColor
        textInput.layer.borderWidth = 1.0
        addSubview(textInput)
    }
    
    func activateConstraints() {
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textLabel.heightAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        textLabel.widthAnchor.constraint(equalToConstant: labelWidth).isActive = true
        
        textInput.translatesAutoresizingMaskIntoConstraints = false
        textInput.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textInput.heightAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        textInput.leadingAnchor.constraint(equalTo: textLabel.trailingAnchor).isActive = true
        textInput.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    func text() -> String? {
        return textInput.text
    }
}
