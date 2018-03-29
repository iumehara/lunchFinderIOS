import XCTest
import Nimble
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

    func test_displaysBothSections() {
        let selectInputTable = multipleSelectInput.subviews[1] as! UITableView
        expect(selectInputTable.numberOfSections).to(be(2))
    }
    
    func test_uiTableTextFieldCellIsDisplayed() {
        let selectInputTable = multipleSelectInput.subviews[1] as! UITableView
        selectInputTable.reloadData()
        
        let pickerCell = selectInputTable.cellForRow(at: IndexPath(row: 0, section: 1))
        
        expect(pickerCell).to(beAKindOf(UITableTextFieldCell.self))
    }

    func test_settingSelectedOption() {
        let selectInputTable = multipleSelectInput.subviews[1] as! UITableView
        selectInputTable.reloadData()
        expect(selectInputTable.numberOfRows(inSection: 0)).to(be(0))

        multipleSelectInput.setDefaultValues(options: [SelectOption(id: 12, name: "Spicy")])
        
        expect(selectInputTable.numberOfRows(inSection: 0)).to(be(1))
        expect(selectInputTable.cellForRow(at: IndexPath(row: 0, section: 0))?.textLabel?.text!).to(equal("Spicy"))
    }

    func test_pickingNewOption() {
        let selectInputTable = multipleSelectInput.subviews[1] as! UITableView
        selectInputTable.reloadData()
        expect(selectInputTable.numberOfRows(inSection: 0)).to(be(0))
        
        let pickerCell = selectInputTable.cellForRow(at: IndexPath(row: 0, section: 1)) as! UITableTextFieldCell
        let pickerView = pickerCell.input.inputView as! UIPickerView
        
        pickerCell.pickerView(pickerView, didSelectRow: 0, inComponent: 0)
        
        expect(selectInputTable.numberOfRows(inSection: 0)).to(be(1))
    }

    func test_pickingMultipleOption() {
        let selectInputTable = multipleSelectInput.subviews[1] as! UITableView
        selectInputTable.reloadData()
        expect(selectInputTable.numberOfRows(inSection: 0)).to(be(0))
        
        let pickerCell = selectInputTable.cellForRow(at: IndexPath(row: 0, section: 1)) as! UITableTextFieldCell
        let pickerView = pickerCell.input.inputView as! UIPickerView
        
        pickerCell.pickerView(pickerView, didSelectRow: 0, inComponent: 0)
        pickerCell.pickerView(pickerView, didSelectRow: 1, inComponent: 0)

        expect(selectInputTable.numberOfRows(inSection: 0)).to(be(2))
    }
}

