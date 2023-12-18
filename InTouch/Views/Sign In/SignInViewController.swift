//
//  SignInViewController.swift
//  InTouch
//
//  Created by Red Wang on 2023/12/15.
//
import UIKit

enum Mode: String, CaseIterable {
    case logIn = "Log in"
    case signUp = "Sign up"
}

class SignInViewController: ITBaseViewController {
    
    private let authManager = AuthManager.shared
    private let firestoreManager = FirestoreManager.shared
    
    var userEmail: String?
    var mode: Mode = .logIn
    var alertState: AuthState?

    // MARK: - Subviews
    let appLabel: UILabel = {
        let label = UILabel()
        label.text = "InTouch"
        label.font = .medium(size: 40)
        label.textColor = .ITBlack
        return label
    }()
    let modeControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [Mode.logIn.rawValue, Mode.signUp.rawValue])
        control.selectedSegmentIndex = 0
        control.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        control.setTitleTextAttributes([.foregroundColor: UIColor.ITBlack], for: .normal)
        control.selectedSegmentTintColor = .ITBlack
        control.tintColor = .white
        control.backgroundColor = .white
        control.layer.borderColor = UIColor.ITBlack.cgColor
        control.layer.borderWidth = 1
        return control
    }()
    let accountTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.cornerRadius = 8
        textField.borderStyle = .roundedRect
        textField.font = .regular(size: 18)
        textField.placeholder = "Enter email"
        textField.addPadding(left: 5, right: 5)
        return textField
    }()
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.cornerRadius = 8
        textField.borderStyle = .roundedRect
        textField.font = .regular(size: 18)
        textField.placeholder = "Enter password"
        textField.addPadding(left: 5, right: 5)
        return textField
    }()
    let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .ITBlack
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .medium(size: 18)
        return button
    }()
    // MARK: - View Load
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ITYellow
        setUpLayouts()
        setUpActions()
        // Update UI
        updateUI(mode: mode)
        // Delegate
        accountTextField.delegate = self
        passwordTextField.delegate = self
    }
    private func setUpLayouts() {
        view.addSubview(appLabel)
        view.addSubview(accountTextField)
        view.addSubview(passwordTextField)
        view.addSubview(modeControl)
        view.addSubview(confirmButton)
        
        appLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
        }
        modeControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(appLabel.snp.bottom).offset(60)
            make.width.equalTo(150)
        }
        accountTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(modeControl.snp.bottom).offset(50)
            make.left.equalTo(view).offset(32)
            make.right.equalTo(view).offset(-32)
            make.height.equalTo(45)
        }
        passwordTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(accountTextField.snp.bottom).offset(16)
            make.left.equalTo(view).offset(32)
            make.right.equalTo(view).offset(-32)
            make.height.equalTo(45)
        }
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordTextField.snp.bottom).offset(36)
            make.left.equalTo(view).offset(32)
            make.right.equalTo(view).offset(-32)
            make.height.equalTo(40)
        }
    }
    private func setUpActions() {
        modeControl.addTarget(self, action: #selector(changeMode), for: .valueChanged)
        confirmButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    // MARK: - Methods
    @objc func changeMode(sender: UISegmentedControl) {
        if modeControl.selectedSegmentIndex == 0 {
            mode = .logIn
        } else {
            mode = .signUp
        }
        updateUI(mode: mode)
    }
  

    @objc func buttonPressed() {
        // Fetch input
        let userInput = getInfo()
        
        switch mode {
        case .logIn:
            authManager.logIn(userInput: userInput) { result in
                switch result {
                case .success(let email):
                    self.userEmail = email
                    self.logInToApp()
                    self.showAlert(with: self.authManager.alertState)
                case .failure(let error):
                    print("Error: \(error)")
                    self.showAlert(with: self.authManager.alertState)
                }
            }
        case .signUp:
            authManager.signUp(userInput: userInput) { result in
                switch result {
                case .success(let email):
                    self.userEmail = email
                    self.showAlert(with: self.authManager.alertState)
                case .failure(let error):
                    print("Error: \(error)")
                    self.showAlert(with: self.authManager.alertState)
                }
            }
        }
            
        updateUI(mode: .logIn)
    }
    
        // MARK: - Methods
    private func logInToApp() {
        guard let email = userEmail else { return }
               firestoreManager.getDocument(
                   asType: User.self,
                   documentId: email,
                   reference: firestoreManager.getRef(.users, groupId: nil)) { result in
                       switch result {
                       case .success(let user):
                           KeyChainManager.shared.loggedInUser = user
                   
                       case .failure(let error):
                           print("Error: \(error)")
                        
                       }
                       
                   }
               
           }
   
    func getInfo() -> Info {
        guard let account = accountTextField.text,
              let password = passwordTextField.text,
              accountTextField.text != "",
              passwordTextField.text != "" else {
            return Info(email: "", password: "")
        }
        return Info(email: account, password: password)
    }
    
    

    func updateUI(mode: Mode) {
        passwordTextField.text = ""
        accountTextField.text = ""
        textFieldDidBeginEditing(accountTextField)
        
        confirmButton.setTitle(mode.rawValue, for: .normal)
        
        if mode == .logIn {
            modeControl.selectedSegmentIndex = 0
        } else {
            modeControl.selectedSegmentIndex = 1
        }
    }
}



// MARK: - UITextField

extension SignInViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch (textField, mode) {
        case (accountTextField, _):
            return passwordTextField.becomeFirstResponder()
        default:
            return textField.resignFirstResponder()
        }
    }
}

// MARK: - AuthManagerDelegate, UIAlertController

extension SignInViewController {

    func showAlert(with alertState: AuthState) {
        
        let alert = UIAlertController(
            title: alertState.title,
            message: alertState.message,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(
            title: alertState.actionTitle ,
            style: .default,
            handler: nil)
        
        /// Action for alert after log in success
        let showLogInPage = UIAlertAction(
            title: alertState.actionTitle ,
            style: .default) { _ in
                
                // Present Tab bar controller
                let tabBarVC = ITTabBarViewController()
                tabBarVC.navigationItem.hidesBackButton = true
                self.navigationController?.pushViewController(tabBarVC, animated: true)
            }
        
        let showSignUpPage = UIAlertAction(
            title: alertState.actionTitle ,
            style: .default) { _ in
               
                let setUpVC = SetUpAccountViewController()
                setUpVC.userEmail = self.userEmail
                setUpVC.navigationItem.hidesBackButton = true
                self.navigationController?.pushViewController(setUpVC, animated: true)
            }
        
        switch alertState {
        case .logInSuccess:
            alert.addAction(showLogInPage)
        case .signUpSuccess:
            alert.addAction(showSignUpPage)
        default:
            alert.addAction(action)
        }
        
        // Show Alert
        self.present(alert, animated: true)
  
    }
    
    
}
