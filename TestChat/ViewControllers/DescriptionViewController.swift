//
//  DescriptionViewController.swift
//  TestChat
//
//  Created by Владимир Ли on 09.07.2022.
//

import UIKit

class DescriptionViewController: UIViewController {
    
    let contentView = DescriptionCustomView()
    var message: Message!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        customizeUI()
    }
    
    private func customizeUI() {
        view.addSubview(contentView)
        view.backgroundColor = .white
        
        contentView.frame = view.frame
        addTargets()
    }
    
    private func addTargets() {
        contentView.backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        contentView.deleteButton.addTarget(self, action: #selector(deleteButtonAction), for: .touchUpInside)
    }
    
    private func deleteMessage() {
        if message != nil {
            CoreDataManager.shared.delete(message: message)
            dismiss(animated: true)
        } else {
            // Удаление из массива
        }
    }
    
    @objc private func backButtonAction() {
        dismiss(animated: true)
    }
    
    @objc private func deleteButtonAction() {
        deleteMessage()
    }
}
