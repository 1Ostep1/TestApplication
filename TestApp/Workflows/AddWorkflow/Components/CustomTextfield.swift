//
//  CustomTextfield.swift
//  TestApp
//
//  Created by Ramazan Iusupov on 26/7/23.
//

import UIKit

class CustomTextfield: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = Constants.Color.grayColor
        layer.cornerRadius = Constants.Corners.corner12
        font = .systemFont(ofSize: 16, weight: .medium)
        textColor = .black
        translatesAutoresizingMaskIntoConstraints = false
    }
}
