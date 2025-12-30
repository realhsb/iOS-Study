//
//  LoginViewController.swift
//  Bankey
//
//  Created by Subeen on 12/29/25.
//

import UIKit
import Then
import SnapKit

class LoginViewController: UIViewController {
    
    let loginView = LoginView()
    let signInButton = UIButton(type: .system)
    let errorMessageLabel = UILabel()
    
    var username: String? {
        return loginView.usernameTextField.text
    }
    
    var password: String? {
        return loginView.passwordTextField.text
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
}

extension LoginViewController {
    private func style() {
        signInButton.do {
            $0.configuration = .filled()
            $0.configuration?.imagePadding = 8
            $0.setTitle("Sign In", for: [])
            $0.addTarget(self, action: #selector(signInTapped), for: .primaryActionTriggered)
        }
        
        errorMessageLabel.do {
            $0.textAlignment = .center
            $0.textColor = .systemRed
            $0.numberOfLines = 0
            $0.text = "Error failure"
            $0.isHidden = true
        }
    }
    
    private func layout() {
        view.addSubview(loginView)
        view.addSubview(signInButton)
        view.addSubview(errorMessageLabel)
        
        // LoginView
        loginView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }

        // Button
        signInButton.snp.makeConstraints { make in
            make.top.equalTo(loginView.snp.bottom).offset(16)
            make.leading.equalTo(loginView)
            make.trailing.equalTo(loginView)
        }
        // Error
        
        errorMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(signInButton.snp.bottom).offset(16)
            make.leading.equalTo(loginView)
            make.trailing.equalTo(loginView)
        }
    }
}

extension LoginViewController {
    @objc func signInTapped(sender: UIButton) {
        errorMessageLabel.isHidden = true
        login()
    }
    
    private func login() {
        guard let username = username, let password = password else {
            assertionFailure("Username / password should never be nil")
            return
        }
        
        if username.isEmpty || password.isEmpty {
            configureView(withMessage: "Username / password cannot be blank")
            return
        }
        
        if username == "Kevin" && password == "Welcome" {
            signInButton.configuration?.showsActivityIndicator = true
        } else {
            configureView(withMessage: "Incorrect username / password")
        }
    }
    
    private func configureView(withMessage message: String) {
        errorMessageLabel.isHidden = false
        errorMessageLabel.text = message
    }
}

#Preview {
    LoginViewController()
}
