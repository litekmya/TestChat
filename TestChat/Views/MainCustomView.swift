//
//  CustomView.swift
//  TestChat
//
//  Created by Владимир Ли on 08.07.2022.
//

import UIKit

class MainCustomView: UIView {
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "  Message"
        textField.borderStyle = .line
        textField.clearButtonMode = .always
        
        return textField
    }()
    let doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "icon"), for: .normal)
        button.setImage(UIImage(named: "icon"), for: .disabled)
        button.contentMode = .scaleAspectFit
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customizeUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customizeUI()
    }
    
    func customizeViewLayout(view: UIView) {
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    private func customizeUI() {
        addSubview(textField)
        addSubview(doneButton)
        translatesAutoresizingMaskIntoConstraints = false
        
        customizeTextField()
        customizeButton()
    }
        
    private func customizeTextField() {
        textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        textField.trailingAnchor.constraint(equalTo: doneButton.leadingAnchor, constant: -16).isActive = true
        textField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        textField.heightAnchor.constraint(equalTo: heightAnchor, constant: -32).isActive = true
    }
    
    private func customizeButton() {
        doneButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        doneButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor).isActive = true
    }
}
