//
//  LoginVC.swift
//  Checkt
//
//  Created by Eliot Han on 11/2/16.
//  Copyright © 2016 Eliot Han. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SwiftMessages


class LoginVC: UIViewController {
    var loginTitle: UILabel!
    
    var emailTF: UITextField!
    var passwordTF: UITextField!
    var enterEmail: UILabel!
    var enterPassword: UILabel!
    var lineOne: UIImageView!
    var lineTwo: UIImageView!
    var rightArrow: UIButton!
    
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    
    func loginButton() {
        if ((emailTF.text?.isEmpty)! && (passwordTF.text?.isEmpty)!) {
            showErrorMessage(title: "Missing Fields", body: "Please enter your email and password.")
        } else if (emailTF.text?.range(of: "@") == nil) {
            showErrorMessage(title: "Invalid Email.", body: "Please enter a valid email address.")
        }
        login(email: emailTF.text!, password: passwordTF.text!)
    }

    
    func login(email: String?, password: String?) {
        // Sign In with credentials.
        guard let email = email, let password = password else { return }
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                self.showErrorMessage(title: "Invalid content", body: error.localizedDescription)
                print(error.localizedDescription)
                return
            }
            self.signedIn(user!)
        }
    }
    
    func showErrorMessage(title: String, body: String){
        let iconText = ["😳","😲","😧","😨","☹️"].sm_random()!
        let mview = MessageView.viewFromNib(layout: .CardView)
        mview.configureTheme(.warning)
        mview.configureDropShadow()
        var config = SwiftMessages.Config()
        config.dimMode = .gray(interactive: true)
        config.duration = .seconds(seconds: 3)
        mview.configureContent(title: title, body: body, iconImage: nil, iconText: iconText, buttonImage: nil, buttonTitle: "Hide", buttonTapHandler: { _ in SwiftMessages.hide() })
        SwiftMessages.show(config: config, view: mview)
    }
    
    func signedIn(_ user: FIRUser?) {
//        MeasurementHelper.sendLoginEvent()
    
        
        //AppState.currentUser = FIRAuth.auth()?.currentUser
        AppState.sharedInstance.signedIn = true
//        let notificationName = Notification.Name(rawValue: Constants.NotificationKeys.SignedIn)
//        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: nil)
        
        
        self.performSegue(withIdentifier: "segueToChecktboardFromLogin", sender: self)
     

        
    }
    
    
    override func viewDidLoad() {
        
        self.navigationController?.navigationBar.isHidden = true
        
        setupUI()
        

        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginVC.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    func setupUI() {
        let button = UIButton()
        button.frame = CGRect(x: 0.05 * screenWidth, y: 0.04 * screenHeight, width: 0.05 * screenWidth, height: 0.05 * screenWidth)
        button.setImage(#imageLiteral(resourceName: "cross"), for: .normal)
        button.addTarget(self, action: #selector(quitLogin), for: .touchUpInside)
        self.view.addSubview(button)
        
        loginTitle = UILabel(frame: CGRect(x: 0.1 * screenWidth, y: 0.05 * screenHeight, width: 0.9 * screenWidth, height: 0.2 * screenHeight))
        loginTitle.text = "Login"
        loginTitle.font = UIFont(name: "Montserrat-Medium", size: 25)
        loginTitle.textColor = UIColor.white
        self.view.addSubview(loginTitle)
        
        enterEmail = UILabel(frame: CGRect(x: 0.1 * screenWidth, y: 0.12 * screenHeight, width: 0.9 * screenWidth, height: 0.2 * screenHeight))
        enterEmail.text = "Email:"
        enterEmail.font = UIFont(name: "Montserrat-Light", size: 16)
        enterEmail.textColor = UIColor.white
        self.view.addSubview(enterEmail)
        
        emailTF = UITextField(frame: CGRect(x: 0.1 * screenWidth, y: 0.18 * screenHeight, width:  0.9 * screenWidth, height: 0.2 * screenHeight))
        emailTF.textColor = UIColor.white
        emailTF.placeholder = "checkt@checkt.org"
        emailTF.font = UIFont(name: "Montserrat-ExtraLight", size: 17)
        self.view.addSubview(emailTF)
        
        lineOne = UIImageView(frame: CGRect(x: 0.1 * screenWidth, y: 0.20 * screenHeight, width:  0.85 * screenWidth, height: 0.2 * screenHeight))
        lineOne.image = #imageLiteral(resourceName: "Line")
        lineOne.contentMode = UIViewContentMode.scaleAspectFit
        self.view.addSubview(lineOne)

        enterPassword = UILabel(frame: CGRect(x: 0.1 * screenWidth, y: 0.27 * screenHeight, width: 0.9 * screenWidth, height: 0.2 * screenHeight))
        enterPassword.text = "Password:"
        enterPassword.font = UIFont(name: "Montserrat-Light", size: 16)
        enterPassword.textColor = UIColor.white
        self.view.addSubview(enterPassword)
        
        passwordTF = UITextField(frame: CGRect(x: 0.1 * screenWidth, y: 0.33 * screenHeight, width:  0.9 * screenWidth, height: 0.2 * screenHeight))
        passwordTF.isSecureTextEntry = true
        passwordTF.textColor = UIColor.white
        passwordTF.font = UIFont(name: "Montserrat-ExtraLight", size: 17)
        self.view.addSubview(passwordTF)
        
        lineTwo = UIImageView(frame: CGRect(x: 0.1 * screenWidth, y: 0.35 * screenHeight, width:  0.85 * screenWidth, height: 0.2 * screenHeight))
        lineTwo.image = #imageLiteral(resourceName: "Line")
        lineTwo.contentMode = UIViewContentMode.scaleAspectFit
        self.view.addSubview(lineTwo)

        rightArrow = UIButton(frame: CGRect(x: 0.8 * screenWidth, y: 0.53 * screenHeight, width:  0.2 * screenWidth, height: 0.2 * screenWidth))
        rightArrow.setImage(#imageLiteral(resourceName: "Right-50"),for: .normal)
        rightArrow.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        rightArrow.addTarget(self, action: #selector(loginButton), for: .touchUpInside)
        self.view.addSubview(rightArrow)
        
        view.bringSubview(toFront: button)
    }
    
    
    
    func quitLogin() {
        print("quit")
        dismiss(animated: true, completion: nil)
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
}

