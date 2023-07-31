//
//  TextFieldWithHeader.swift
//  TestApp
//
//  Created by Ramazan Iusupov on 26/7/23.
//

import UIKit

protocol TextFieldWithHeaderDelegate: AnyObject {
    func textDidChange(_ type: TextFieldWithHeader.FieldType)
}

class TextFieldWithHeader: UIView {
    enum FieldType {
        case `default`(String), date(Date), time(Date)
    }
    
    private lazy var headerTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let textfield = CustomTextfield()
    private let fieldType: FieldType
    weak var delegate: TextFieldWithHeaderDelegate?

    init(headerTitle: String, type: FieldType = .default("")) {
        fieldType = type
        super.init(frame: .zero)
        headerTitleLabel.text = headerTitle
        setup()
        configureTextfield()
    }
    
    required init?(coder: NSCoder) {
        fieldType = .default("")
        super.init(coder: coder)
        setup()
        configureTextfield()
    }
    
    private func configureTextfield() {
        textfield.delegate = self
        switch fieldType {
        case .default: break
        case .date:
            textfield.addInputViewDatePicker(target: self, selector: #selector(doneTapped))
        case .time:
            textfield.addInputViewDatePicker(target: self, selector: #selector(doneTapped), type: .time)
        }
    }
    
    @objc
    private func doneTapped() {
        if let datePicker = textfield.inputView as? UIDatePicker {
            switch fieldType {
            case .default: break
            case .date:
                textfield.text = datePicker.date.format(format: .yyyyMMMMdd)
                delegate?.textDidChange(.date(datePicker.date))
            case .time:
                textfield.text = datePicker.date.format(format: .hhmm)
                delegate?.textDidChange(.time(datePicker.date))
            }
        }
        textfield.resignFirstResponder()
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        
        
        addSubview(headerTitleLabel)
        addSubview(textfield)
        
        NSLayoutConstraint.activate([
            headerTitleLabel.topAnchor.constraint(equalTo: topAnchor),
            headerTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            textfield.topAnchor.constraint(equalTo: headerTitleLabel.bottomAnchor, constant: Constants.Sizes.padding4),
            textfield.leadingAnchor.constraint(equalTo: leadingAnchor),
            textfield.trailingAnchor.constraint(equalTo: trailingAnchor),
            textfield.bottomAnchor.constraint(equalTo: bottomAnchor),
            textfield.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

extension TextFieldWithHeader: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if case .default = fieldType {
            delegate?.textDidChange(.default(textfield.text ?? ""))
        }
    }
}
