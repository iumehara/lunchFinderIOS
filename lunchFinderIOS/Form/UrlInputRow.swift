import UIKit

class UrlInputRow: TextInputRow {
    override func setupSubviews() {
        super.setupSubviews()
        textInput.keyboardType = UIKeyboardType.URL
        textInput.autocapitalizationType = .none
    }
}
