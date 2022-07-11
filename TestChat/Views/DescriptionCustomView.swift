//
//  DescriptionCustomView.swift
//  TestChat
//
//  Created by Владимир Ли on 09.07.2022.
//

import Foundation

import UIKit

class DescriptionCustomView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 36, weight: .black)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Chat description"
        
        return label
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "minus.circle"), for: .normal)
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        
        return imageView
    }()
    
    let messageLabel: LabelPadding = {
        let label = LabelPadding()
        label.setup()
        
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.mm.yyyy  hh:mm"
        let dateString = formatter.string(from: Date())
        
        label.text = dateString

        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customizeUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customizeUI()
    }
    
    private func customizeUI() {
        addSubview(backButton)
        addSubview(deleteButton)
        addSubview(titleLabel)
        addSubview(imageView)
        addSubview(messageLabel)
        addSubview(dateLabel)
        translatesAutoresizingMaskIntoConstraints = false
        
        customizeButtons()
        customizeTitleLabel()
        customizeImageView()
        customizeLabels()
    }
    
    private func customizeButtons() {
        backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 7).isActive = true
        backButton.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        deleteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        deleteButton.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
    }
    
    private func customizeTitleLabel() {
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
        titleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 30).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
    }
    
    private func customizeImageView() {
        imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    private func customizeLabels() {
        dateLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 8).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16).isActive = true
        
        messageLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 30).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30).isActive = true
    }
}
