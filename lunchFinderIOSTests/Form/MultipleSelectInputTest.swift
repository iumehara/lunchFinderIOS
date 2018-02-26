import XCTest
@testable import lunchFinderIOS

class MultipleSelectInputTest: XCTestCase {
    var multipleSelectInput: MultipleSelectInput!
    
    override func setUp() {
        super.setUp()
        
        multipleSelectInput = MultipleSelectInput(labelText: "Test")
        
        let options = [
            SelectOption(id: 12, name: "Spicy"),
            SelectOption(id: 33, name: "Vegetarian")
        ]
        
        multipleSelectInput.setOptions(selectOptions: options)
    }
    
    func test_AddingNewSelectInputRow() {
        let selectInputCollection = multipleSelectInput.subviews[1]
        XCTAssertEqual(selectInputCollection.subviews.count, 0)
        
        let addButton = multipleSelectInput.subviews[2] as! UIButton
        addButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(selectInputCollection.subviews.count, 1)
    }

    func test_selectingCategory() {
        let addButton = multipleSelectInput.subviews[2] as! UIButton
        addButton.sendActions(for: .touchUpInside)
        
        let selectInputCollection = multipleSelectInput.subviews[1]
        let singleSelectInput = selectInputCollection.subviews[0] as! SingleSelectInput
        
        singleSelectInput.pickerView(singleSelectInput.subviews[0].inputView as! UIPickerView, didSelectRow: 1, inComponent: 0)
        XCTAssertEqual(multipleSelectInput.ids(), [33])
    }

    func test_selectingMultipleCategories() {
        let selectInputCollection = multipleSelectInput.subviews[1]
        let addButton = multipleSelectInput.subviews[2] as! UIButton
        
        addButton.sendActions(for: .touchUpInside)
        let firstSingleSelectInput = selectInputCollection.subviews[0] as! SingleSelectInput
        firstSingleSelectInput.pickerView(firstSingleSelectInput.subviews[0].inputView as! UIPickerView, didSelectRow: 1, inComponent: 0)
        XCTAssertEqual(multipleSelectInput.ids(), [33])
        
        addButton.sendActions(for: .touchUpInside)
        let secondSelectInput = selectInputCollection.subviews[1] as! SingleSelectInput
        secondSelectInput.pickerView(secondSelectInput.subviews[0].inputView as! UIPickerView, didSelectRow: 0, inComponent: 0)
        XCTAssertEqual(multipleSelectInput.ids(), [33, 12])
    }
}
