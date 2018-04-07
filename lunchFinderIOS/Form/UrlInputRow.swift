import UIKit

class UrlInputRow: TextInputRow {
    override func setupSubviews() {
        super.setupSubviews()
        textField.keyboardType = UIKeyboardType.URL
        textField.autocapitalizationType = .none
    }
}
