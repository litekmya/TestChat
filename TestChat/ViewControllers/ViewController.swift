//
//  ViewController.swift
//  TestChat
//
//  Created by Владимир Ли on 08.07.2022.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Private properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Тестовое задание"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        
        return label
    }()
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        return tableView
    }()
    
    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.style = .large
        
        return indicator
    }()
    
    private let textInputView = MainCustomView()
    private let identifier = "Cell"
    private var messages: [String] = []
    private var savedMessages: [Message] = []
    private var loadData = false
    private var userImage: UIImage!

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getMessagesFromDatabase()
        getMessagesFromCoreData()
        view.keyboardLayoutGuide.followsUndockedKeyboard = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        customizeUI()
    }
    
    //MARK: - Layout
    private func customizeUI() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(textInputView)
        view.addSubview(indicator)
        
        customizeLabel()
        customizeTableView()
        customizeTextInputView()
        setupKeyboard()
        
        indicator.frame = view.frame
    }
    
    private func customizeLabel() {
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func customizeTableView() {
        tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: textInputView.topAnchor).isActive = true
        
        tableView.separatorStyle = .none
        tableView.register(TableViewCell.self, forCellReuseIdentifier: identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func customizeTextInputView() {
        textInputView.customizeViewLayout(view: view)
        textInputView.textField.delegate = self
        textInputView.doneButton.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
    }
    
    private func setupKeyboard() {
        let topConstraint = view.keyboardLayoutGuide.topAnchor.constraint(equalTo: textInputView.bottomAnchor)
        let bottomConstraint = view.keyboardLayoutGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        view.keyboardLayoutGuide.setConstraints([topConstraint, bottomConstraint],
                                                activeWhenAwayFrom: .top)
    }
    
    //MARK: - Private methods
    private func getMessagesFromDatabase() {
        indicator.startAnimating()
        NetworkManager.shared.fetchData(with: URLs.testURL.rawValue) {[unowned self] message, error in
            if let message = message {
                self.messages.append(message)
                
                let lastScrollOffset = tableView.contentOffset
                let indexPath = IndexPath(row: messages.count - 1, section: 0)
                
                tableView.insertRows(at: [indexPath], with: .bottom)
                tableView.layer.removeAllAnimations()
                tableView.setContentOffset(lastScrollOffset, animated: false)
            } else {
                showAlert()
            }
            
            self.indicator.stopAnimating()
        }
    }
    
    private func getMessagesFromCoreData() {
        savedMessages = []
        savedMessages = CoreDataManager.shared.fetchData()
        
        for message in savedMessages {
            guard let text = message.text else { return }
            add(message: text)
        }
    }
    
    private func add(message: String) {
        messages.insert(message, at: 0)
        
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .bottom)
    }
    
    private func goToDescription(message: String, at indexPath: Int) {
        let descriptionVC = DescriptionViewController()
        descriptionVC.modalPresentationStyle = .fullScreen
        descriptionVC.contentView.messageLabel.text = message
        descriptionVC.contentView.imageView.image = userImage
        
        if indexPath <= savedMessages.count - 1 {
            descriptionVC.message = savedMessages[indexPath]
        }
        
        present(descriptionVC, animated: true)
    }
    
    //MARK: - @objc
    @objc private func doneButtonAction() {
        guard let text = textInputView.textField.text else { return }
        guard let data = userImage.pngData() else { return }
        add(message: text)
        CoreDataManager.shared.save(message: text, imageData: data)
        textInputView.textField.text = ""
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! TableViewCell
        let message = messages[indexPath.row]
        
        cell.getUserIcon {[unowned self] image in
            self.userImage = image
        }
        cell.messageLabel.text = message
        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if loadData && indexPath.row == messages.count - 1 {
            getMessagesFromDatabase()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in
            self.loadData = true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let message = messages[indexPath.row]
        
        goToDescription(message: message, at: indexPath.row)
    }
}

//MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textInputView.textField {
            textField.becomeFirstResponder()
            if textInputView.doneButton.isEnabled {
                doneButtonAction()
            }
        }
        return true
    }
}

//MARK: - Alert
extension ViewController {
    
    private func showAlert() {
        let alert = UIAlertController(title: "Warning", message: "We have problems with internet access", preferredStyle: .alert)
        let tryAgainAction = UIAlertAction(title: "Try again", style: .default) { [unowned self] _ in
            self.getMessagesFromDatabase()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(tryAgainAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}

