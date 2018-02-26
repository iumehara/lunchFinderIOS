import UIKit

class TextInputRow: UIView {
    private let textLabel: UILabel
    private let textInput: UITextField

    init(labelText: String) {
        self.textLabel = UILabel()
        self.textLabel.text = labelText
        self.textInput = UITextField()
        
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
        let margins = self.safeAreaLayoutGuide
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        textLabel.heightAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        textLabel.widthAnchor.constraint(equalToConstant: CGFloat(100)).isActive = true
        
        textInput.translatesAutoresizingMaskIntoConstraints = false
        textInput.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        textInput.heightAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        textInput.leadingAnchor.constraint(equalTo: textLabel.trailingAnchor).isActive = true
        textInput.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
    }
    
    func text() -> String? {
        return textInput.text
    }
}
