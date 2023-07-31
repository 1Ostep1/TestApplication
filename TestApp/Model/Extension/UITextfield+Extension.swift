//
//  UITextfield+Extension.swift
//  TestApp
//
//  Created by Ramazan Iusupov on 29/7/23.
//

import UIKit

extension UITextField {
    func addInputViewDatePicker(
        target: Any,
        selector: Selector,
        type: UIDatePicker.Mode = .date
    ) {
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = type
        inputView = datePicker
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)
        inputAccessoryView = toolBar
    }
    
    @objc
    private func cancelPressed() {
        self.resignFirstResponder()
    }
}
