import XCTest
import Nimble
@testable import lunchFinderIOS

extension RestaurantForm {
    func getNameInputField() -> UITextField {
        let scrollView = self.subviews[0] as! UIScrollView
        let nameInputRow = scrollView.subviews[1] as! TextInputRow
        return nameInputRow.subviews[1] as! UITextField
    }
}
