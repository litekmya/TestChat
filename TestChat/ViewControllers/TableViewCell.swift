//
//  TableViewCell.swift
//  TestChat
//
//  Created by Владимир Ли on 09.07.2022.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = CGColor(red: 201/255, green: 255/255, blue: 100/255, alpha: 1)
        
        return imageView
    }()
    
    let messageLabel: LabelPadding = {
        let label = LabelPadding()
        label.setup()
        
        return label
    }()
    
    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .medium
        indicator.hidesWhenStopped = true
        
        return indicator
    }()

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        customizeUI()
    }
    
    func getUserIcon(completion: @escaping(UIImage) -> Void) {
        indicator.startAnimating()
        NetworkManager.shared.fetchImage(with: URLs.imageURL.rawValue) {[unowned self] data in
            guard let image = UIImage(data: data) else { return }
            
            self.userImageView.image = image
            self.indicator.stopAnimating()
            
            completion(image)
        }
    }
    
    private func customizeUI() {
        addSubview(userImageView)
        addSubview(messageLabel)
        
        customizeImageView()
        customizeLabel()
    }
    
    private func customizeImageView() {
        userImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6).isActive = true
        userImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        userImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        userImageView.topAnchor.constraint(equalTo: topAnchor, constant: 6).isActive = true
        
        userImageView.addSubview(indicator)
        indicator.frame = userImageView.frame
    }
    
    private func customizeLabel() {
        messageLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 8).isActive = true
        messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -30).isActive = true
        messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6).isActive = true
    }
}
