//
//  SetUpAccountViewController.swift
//  InTouch
//
//  Created by Red Wang on 2023/12/17.
//

import UIKit

class SetUpAccountViewController: ITBaseViewController {
    
    private let firestoreManager = FirestoreManager.shared
    var userEmail: String?
    
    // MARK: - Subviews
    let userIdLabel: UILabel = {
        let label = UILabel()
        label.text = "User ID"
        label.font = .medium(size: 18)
        return label
    }()
    let userIdTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter user ID"
        textField.font = .medium(size: 18)
        textField.textColor = .ITBlack
        textField.addPadding(left: 8, right: 8)
        return textField
    }()
    let userNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter profile name"
        textField.font = .medium(size: 18)
        textField.textColor = .ITBlack
        textField.addPadding(left: 8, right: 8)
        return textField
    }()
    let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .ITDarkGrey
        return view
    }()
    let underlineView2: UIView = {
        let view = UIView()
        view.backgroundColor = .ITDarkGrey
        return view
    }()
    let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("CONFIRM", for: .normal)
        button.setTitleColor(.ITBlack, for: .normal)
        button.backgroundColor = .ITYellow
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .medium(size: 16)
        return button
    }()
    // MARK: - View Load
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpLayouts()
        setUpActions()
    }
    private func setUpLayouts() {
        view.addSubview(userIdLabel)
        view.addSubview(userIdTextField)
        view.addSubview(userNameTextField)
        view.addSubview(confirmButton)
        view.addSubview(underlineView)
        view.addSubview(underlineView2)
        
        userIdLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
        }
        userIdTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(userIdLabel.snp.bottom).offset(50)
            make.left.equalTo(view).offset(36)
            make.right.equalTo(view).offset(-36)
            make.height.equalTo(50)
        }
        underlineView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(userIdTextField.snp.bottom)
            make.left.equalTo(view).offset(36)
            make.right.equalTo(view).offset(-36)
            make.height.equalTo(1)
        }
        userNameTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(userIdTextField.snp.bottom).offset(24)
            make.left.equalTo(view).offset(36)
            make.right.equalTo(view).offset(-36)
            make.height.equalTo(50)
        }
        underlineView2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(userNameTextField.snp.bottom)
            make.left.equalTo(view).offset(36)
            make.right.equalTo(view).offset(-36)
            make.height.equalTo(1)
        }
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(userNameTextField.snp.bottom).offset(50)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
    }
    private func setUpActions() {
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    
    // MARK: - Methods
    
    @objc private func confirmButtonTapped() {
        guard let userId = userIdTextField.text,
              let userName = userNameTextField.text,
              userId != "",
              userName != "",
              let email = userEmail else {
            return
        }
        
        let user = User(
            userId: userId,
            userName: userName,
            userEmail: email,
            userIcon: "https://firebasestorage.googleapis.com/v0/b/intouch-da0b8.appspot.com/o/default%2FgroupIcons%2Fdefaultt.jpeg?alt=media&token=5c77fdfe-fa79-4232-aae5-5530f0d52088",
            userCover: "https://firebasestorage.googleapis.com/v0/b/intouch-da0b8.appspot.com/o/default%2FgroupCovers%2Fapple.png?alt=media&token=0b159cf9-f7a1-4c23-a8bc-c3cc78943e89",
            groups: [])
        
        KeyChainManager.shared.loggedInUser = user
        
        firestoreManager.addDocument(
            data: user,
            reference: firestoreManager.getRef(.users, groupId: nil),
            documentId: email) { result in
                switch result {
                case .success(let user):
                    self.showHomePage()
                    print("Success: \(user)")
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
    }
        
        
    
        private func showHomePage() {
            let tabBarVC = ITTabBarViewController()
            tabBarVC.navigationItem.hidesBackButton = true
        
            self.navigationController?.pushViewController(tabBarVC, animated: true)
        }
    
    
    
}
